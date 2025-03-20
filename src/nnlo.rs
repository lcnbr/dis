use std::{
    fs,
    io::{self, Write},
};

use _gammaloop::{
    feyngen::{
        diagram_generator::FeynGen, FeynGenFilter, FeynGenFilters, FeynGenOptions, GenerationType,
        SelfEnergyFilterOptions, SewedFilterOptions, SnailFilterOptions, TadpolesFilterOptions,
    },
    graph::BareGraph,
    model::Model,
    numerator::GlobalPrefactor,
};
use ahash::{HashMap, HashMapExt};
use dis::{gen::photon_self_energy_gen, load_generic_model, DisGraph};
use indicatif::{ParallelProgressIterator, ProgressBar, ProgressIterator};
use rayon::iter::{IntoParallelRefIterator, ParallelIterator};

fn main() {
    let nloops: usize;

    loop {
        print!("Please enter the number of loops: ");
        // Flush the prompt to ensure it's displayed immediately
        io::stdout().flush().expect("Failed to flush stdout");

        let mut input = String::new();
        io::stdin()
            .read_line(&mut input)
            .expect("Failed to read line");

        match input.trim().parse::<u8>() {
            Ok(num) => {
                nloops = num as usize; // Store the valid input in the variable
                break; // Exit the loop once a valid non-zero number is obtained
            }
            Err(_) => {
                println!("Invalid input. Please enter a non-negative integer.");
            }
        }
    }
    let model = load_generic_model("sm");
    let diagrams = photon_self_energy_gen(nloops, &model);
    println!("Generated {} supergraphs", diagrams.len());

    let bar = ProgressBar::new(diagrams.len() as u64);
    let diagrams: Vec<_> = diagrams
        .into_iter()
        .progress_with(bar)
        .map(|a| DisGraph::from_self_energy_bare(&a, &model))
        .collect::<Vec<_>>()
        .into_iter()
        .enumerate()
        .collect();

    // let bar = ProgressBar::new(diagrams.len() as u64);
    let padding = num_digits(diagrams.len());

    fs::create_dir_all(&format!("./outputs/{nloops}lo")).unwrap();

    diagrams.par_iter().progress().for_each(|(i, d)| {
        let ifsplit = d.full_dis_filter_split();
        println!("{} embeddings for graph: {}", ifsplit.cuts.len(), i);

        let n_cuts = ifsplit
            .cuts
            .iter()
            .fold(0, |acc, a| acc + a.1 .1[0].len() + a.1 .1[1].len());

        println!("{} cuts for graph: {}", n_cuts, i);
        ifsplit
            .to_typst(
                d,
                &format!("./outputs/{nloops}lo/supergraph{i:0a$}.typ", a = padding),
            )
            .unwrap();
        // bar.inc(1);
        ifsplit
            .to_other_mathematica_file(
                &d,
                &format!("./outputs/{nloops}lo/supergraph{i:0a$}.m", a = padding),
            )
            .unwrap();
        // bar.inc(1);
    });
    DisGraph::to_typst(
        &diagrams,
        10.,
        &format!("./outputs/{nloops}lo/all_supergraphs.typ"),
    )
    .unwrap();
    println!("Generated {} self energies", diagrams.len())
}

fn num_digits(n: usize) -> usize {
    if n == 0 {
        1
    } else {
        (n.ilog10() + 1) as usize
    }
}
