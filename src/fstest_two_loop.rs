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
use ahash::{AHashSet, HashMap, HashMapExt, HashSet};
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

struct CombinationsWithRepetition<T> {
    elements: Vec<T>,
    k: usize,
    current: Vec<usize>,
    done: bool,
}

impl<T: Clone + Ord> CombinationsWithRepetition<T> {
    fn new(set: HashSet<T>, k: usize) -> Self {
        let elements: Vec<T> = set.into_iter().sorted().collect();
        CombinationsWithRepetition {
            elements,
            k,
            current: vec![0; k],
            done: false,
        }
    }
}

impl<T: Clone> Iterator for CombinationsWithRepetition<T> {
    type Item = Vec<T>;

    fn next(&mut self) -> Option<Self::Item> {
        if self.done {
            return None;
        }

        let result = self
            .current
            .iter()
            .map(|&i| self.elements[i].clone())
            .collect();

        // Generate next combination (non-decreasing sequence)
        let n = self.elements.len();
        let mut i = self.k - 1;
        while i < self.k && self.current[i] == n - 1 {
            i = i.wrapping_sub(1);
        }
        if i >= self.k {
            self.done = true;
        } else {
            self.current[i] += 1;
            for j in (i + 1)..self.k {
                self.current[j] = self.current[i];
            }
        }

        Some(result)
    }
}

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

pub fn dis_cart_prod(
    initial_states: &[&'static str],
    loop_count: usize,
    model: &Model,
) -> Vec<FeynGen> {
    let mut options = vec![];

    let initial_states: HashSet<&str> = initial_states.into_iter().cloned().collect();

    // let final_states = vec![vec!["e-", "d"], vec!["e-", "g"], vec!["e-", "d~"]];

    let initial_state_template = vec![&"e-"];
    let final_states = initial_states
        .iter()
        .map(|a| {
            let mut temp = initial_state_template.iter().map(|b| **b).collect_vec();

            temp.extend([*a]);
            temp
        })
        .collect_vec();

    for initial_state_mult in 1..(loop_count + 2) {
        for mut init_states in
            CombinationsWithRepetition::new(initial_states.clone(), initial_state_mult)
        {
            init_states.extend(initial_state_template.clone());

            let init_states = init_states.into_iter().map(|a| a).collect_vec();

            info!("initial states: {:?}\nfinal states: {:?}\ncross_section_orders:{}\nloop_count:{}\nn_unresolved:{}", init_states, final_states,2*loop_count ,loop_count+ 2 - initial_state_mult,loop_count);

            options.push(dis_options(
                &init_states,
                &final_states,
                2 * loop_count,
                loop_count + 2 - initial_state_mult,
                loop_count,
                &model,
            ));
        }
    }

    options
}

fn main() {
    setup_logger().unwrap();

    let model = load_generic_model("sm_dis");
    let d = model.get_particle("d");
    let a = model.get_particle("a");
    let em = model.get_particle("e-");
    let g = model.get_particle("g");

    let options = dis_cart_prod(&["d", "d~", "g", "ghG", "ghG~"], 1, &model);

    info!("Number of options: {}", options.len());

    // let options = dis_cart_prod(&["d", "d~", "g"], 1, &model);

    // info!("Number of options: {}", options.len());
    let fs_diagrams: Vec<_> = chain_dis_generate(&options, &model);

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
                    debug!("//original\n{}", cuto);
                    debug!("//canonical\n{}", cutc);
                    (1, Some(cuto))
                });
        }
    }

    // for (i, (k, v)) in fs_can.iter().enumerate() {
    //     if v.0 == 2 {
    //         if let Some(c) = &v.1 {
    //             info!("//{i}");
    //             info!("//original\n{}", c);
    //         }
    //     }
    // }

    // let self_energies = photon_self_energy_gen(2, &model);

    // info!("{}", self_energies.len());

    // // let bar = ProgressBar::new(diagrams.len() as u64);
    // let diagrams: Vec<_> = self_energies
    //     .into_iter()
    //     // .progress_with(bar)
    //     .map(|a| DisGraph::from_self_energy_bare(&a, &model))
    //     .collect::<Vec<_>>()
    //     .into_iter()
    //     .enumerate()
    //     .collect();

    // info!("Now comparing");
    // diagrams.iter().for_each(|(i, d)| {
    //     let ifsplit = d.full_dis_filter_split();

    //     let all = ifsplit.collect_all_cuts(d);

    //     for h in all {
    //         let cut = h.clone().canonize();
    //         let entry = fs_can.entry(cut.clone());
    //         let id = entry.index();

    //         entry
    //             .and_modify(|a| {
    //                 a.0 += 1;
    //                 info!("//Seen {} {} times", id, a.0);
    //             })
    //             .or_insert_with(|| {
    //                 info!("//Not seen {}", id);

    //                 info!("//OriginalCut:\n{}", h);
    //                 info!("//canonical\n{}", cut);

    //                 (1, Some(h))
    //             });
    //     }
    //     // bar.inc(1);
    // });

    // info!("Finished comparing");

    // for (i, (k, v)) in fs_can.iter().enumerate() {
    //     if v.0 == 1 {
    //         info!("//{i}");
    //         info!("//canonical\n{}", k);
    //         if let Some(c) = &v.1 {
    //             info!("//original\n{}", c);
    //         }
    //     }
    // }
}
