use _gammaloop::{
    feyngen::{
        diagram_generator::FeynGen, FeynGenFilter, FeynGenFilters, FeynGenOptions, GenerationType,
        GraphGroupingOptions, SelfEnergyFilterOptions, SewedFilterOptions, SnailFilterOptions,
        TadpolesFilterOptions,
    },
    graph::{BareGraph, HedgeGraphExt},
    model::Model,
    momentum::SignOrZero,
    numerator::GlobalPrefactor,
};
use ahash::{AHashSet, HashMap, HashMapExt};
use dis::{
    gen::{chain_dis_generate, dis_options, photon_self_energy_gen},
    load_generic_model, DisCompVertex, DisCutGraph, DisGraph, IFCuts,
};
use indexmap::{IndexMap, IndexSet};
use itertools::Itertools;

use libc::SIGHUP;
use linnet::half_edge::{
    involution::{EdgeData, Flow, Orientation},
    HedgeGraph,
};
use log::{debug, error, info, trace, warn, LevelFilter};
use std::{env, time::SystemTime};

fn setup_logger() -> Result<(), fern::InitError> {
    let log_level = env::var("RUST_LOG").unwrap_or_else(|_| "info".to_string());

    // Parse it into a LevelFilter
    let level_filter = log_level
        .parse::<LevelFilter>()
        .unwrap_or(LevelFilter::Info);

    fern::Dispatch::new()
        .format(|out, message, record| {
            out.finish(format_args!(
                "//[{} {} {}] {}",
                humantime::format_rfc3339_seconds(SystemTime::now()),
                record.level(),
                record.target(),
                message
            ))
        })
        .level(level_filter)
        .chain(std::io::stdout())
        .chain(fern::log_file("output.log")?)
        .apply()?;
    Ok(())
}
fn main() {
    setup_logger().unwrap();

    let model = load_generic_model("sm_dis");
    let d = model.get_particle("d");
    let a = model.get_particle("a");
    let em = model.get_particle("e-");
    let g = model.get_particle("g");

    let d = dis_options(
        &["e-", "d"],
        &[vec!["e-", "d"], vec!["e-", "g"], vec!["e-", "d~"]],
        2,
        2,
        1,
        &model,
    );

    let dx = dis_options(
        &["e-", "d~"],
        &[vec!["e-", "d"], vec!["e-", "g"], vec!["e-", "d~"]],
        2,
        2,
        1,
        &model,
    );

    let g = dis_options(
        &["e-", "g"],
        &[vec!["e-", "d"], vec!["e-", "g"], vec!["e-", "d~"]],
        2,
        2,
        1,
        &model,
    );

    let dg = dis_options(
        &["e-", "d", "g"],
        &[vec!["e-", "d"], vec!["e-", "g"], vec!["e-", "d~"]],
        2,
        1,
        1,
        &model,
    );

    let dxg = dis_options(
        &["e-", "d~", "g"],
        &[vec!["e-", "d"], vec!["e-", "g"], vec!["e-", "d~"]],
        2,
        1,
        1,
        &model,
    );

    let dd = dis_options(
        &["e-", "d", "d"],
        &[vec!["e-", "d"], vec!["e-", "g"], vec!["e-", "d~"]],
        2,
        1,
        1,
        &model,
    );

    let dxdx = dis_options(
        &["e-", "d~", "d~"],
        &[vec!["e-", "d"], vec!["e-", "g"], vec!["e-", "d~"]],
        2,
        1,
        1,
        &model,
    );

    let ddx = dis_options(
        &["e-", "d", "d~"],
        &[vec!["e-", "d"], vec!["e-", "g"], vec!["e-", "d~"]],
        2,
        1,
        1,
        &model,
    );

    // let ddxg = dis_options(
    //     &["e-", "d", "d~"],
    //     &[vec!["e-", "d"], vec!["e-", "g"], vec!["e-", "d~"]],
    //     2,
    //     1,
    //     1,
    //     &model,
    // );

    // let diagram_gen = FeynGen::new(options);

    let fs_diagrams: Vec<_> = chain_dis_generate(&[d, dx, g, dd, dxdx, ddx, dg, dxg], &model);

    info!("Number of fs diagrams: {}", fs_diagrams.len());
    let mut fs_can: IndexMap<DisCutGraph, (usize, Option<DisCutGraph>)> = IndexMap::new();

    for p in &fs_diagrams {
        let cuto = DisCutGraph::from_bare(p);

        let electron_disconnects = cuto.electron_disconnects();
        if !electron_disconnects {
            // println!("//original\n{}", cuto);
            let cutc = cuto.clone().canonize();

            let entry = fs_can.entry(cutc.clone());
            let id = entry.index();

            entry
                .and_modify(|a| {
                    a.0 += 1;
                    info!("//Seen {} {} times", id, a.0);
                })
                .or_insert_with(|| {
                    info!("//Not seen {}", id);
                    info!("//original\n{}", cuto);
                    info!("//canonical\n{}", cutc);
                    (1, Some(cuto))
                });
        }
    }

    for (i, (k, v)) in fs_can.iter().enumerate() {
        if v.0 == 2 {
            if let Some(c) = &v.1 {
                info!("//{i}");
                info!("//original\n{}", c);
            }
        }
    }

    let self_energies = photon_self_energy_gen(2, &model);

    info!("{}", self_energies.len());

    // let bar = ProgressBar::new(diagrams.len() as u64);
    let diagrams: Vec<_> = self_energies
        .into_iter()
        // .progress_with(bar)
        .map(|a| DisGraph::from_self_energy_bare(&a, &model))
        .collect::<Vec<_>>()
        .into_iter()
        .enumerate()
        .collect();

    info!("Now comparing");
    diagrams.iter().for_each(|(i, d)| {
        let ifsplit = d.full_dis_filter_split();

        let all = ifsplit.collect_all_cuts(d);

        for h in all {
            let cut = h.clone().canonize();
            let entry = fs_can.entry(cut.clone());
            let id = entry.index();

            entry
                .and_modify(|a| {
                    a.0 += 1;
                    info!("//Seen {} {} times", id, a.0);
                })
                .or_insert_with(|| {
                    info!("//Not seen {}", id);

                    info!("//OriginalCut:\n{}", h);
                    info!("//canonical\n{}", cut);

                    (1, Some(h))
                });
        }
        // bar.inc(1);
    });

    info!("Finished comparing");

    for (i, (k, v)) in fs_can.iter().enumerate() {
        if v.0 == 1 {
            info!("//{i}");
            info!("//canonical\n{}", k);
            if let Some(c) = &v.1 {
                info!("//original\n{}", c);
            }
        }
    }
}
