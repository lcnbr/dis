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
    load_generic_model, CutGraph, DisCompVertex, DisGraph, IFCuts,
};
use indexmap::{IndexMap, IndexSet};
use itertools::Itertools;

use libc::SIGHUP;
use linnet::half_edge::{
    involution::{EdgeData, Orientation},
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
                "[{} {} {}] {}",
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

    let ddx = dis_options(
        &["e-", "d", "d~"],
        &[vec!["e-", "d"], vec!["e-", "g"], vec!["e-", "d~"]],
        2,
        1,
        1,
        &model,
    );

    // let diagram_gen = FeynGen::new(options);

    let fs_diagrams: Vec<_> = chain_dis_generate(&[d, dx, g, dd, ddx, dg, dxg], &model);

    println!("{}", fs_diagrams.len());
    let mut fs_can: IndexMap<CutGraph, (usize, Option<CutGraph>)> = IndexMap::new();

    for p in &fs_diagrams {
        let cuto = CutGraph::from_bare(p);
        let cutc = cuto.clone().canonize();

        let entry = fs_can.entry(cutc.clone());
        let id = entry.index();

        entry
            .and_modify(|a| {
                a.0 += 1;
                println!("//Seen {} {} times", id, a.0);
            })
            .or_insert_with(|| {
                println!("//Not seen {}", id);
                // println!("//original\n{}", cuto);
                // println!("//canonical\n{}", cutc);
                (1, Some(cuto))
            });
    }

    let self_energies = photon_self_energy_gen(2, &model);

    println!("{}", self_energies.len());

    // let bar = ProgressBar::new(diagrams.len() as u64);
    let diagrams: Vec<_> = self_energies
        .into_iter()
        // .progress_with(bar)
        .map(|a| DisGraph::from_self_energy_bare(&a, &model))
        .collect::<Vec<_>>()
        .into_iter()
        .enumerate()
        .collect();

    println!("Now comparing");
    diagrams.iter().for_each(|(i, d)| {
        let ifsplit = d.full_dis_filter_split();

        let all = ifsplit.collect_all_cuts(d);

        for h in all {
            let cut = CutGraph::from_hairy(h.clone(), true).canonize();
            let entry = fs_can.entry(cut.clone());
            let id = entry.index();

            entry
                .and_modify(|a| {
                    a.0 += 1;
                    println!("//Seen {} {} times", id, a.0);
                })
                .or_insert_with(|| {
                    println!("//Not seen {}", id);

                    println!(
                        "//OriginalCut:\n{}",
                        h.dot_impl(
                            &h.full_filter(),
                            "",
                            &|a| {
                                let label = match a.1 {
                                    Orientation::Default => format!("Default:{}", a.2),
                                    Orientation::Reversed => format!("Reversed:{}", a.2),
                                    Orientation::Undirected => "".to_string(),
                                };
                                Some(format!(
                                    "pdg={},orient={:?},edgeid={},label=\"{}\"",
                                    a.0,
                                    a.1,
                                    usize::from(a.2),
                                    label
                                ))
                            },
                            &|b| { Some(format!("label = \"{}\",nodetype={}", b, b)) }
                        )
                    );
                    println!("//canonical\n{}", cut);

                    (1, None)
                });
        }
        // bar.inc(1);
    });

    for (i, (k, v)) in fs_can.iter().enumerate() {
        if v.0 == 1 {
            if let Some(c) = &v.1 {
                println!("//{i}");
                println!("//original\n{}", c);
            }
        }
    }
}
