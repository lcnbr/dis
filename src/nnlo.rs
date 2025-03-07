use std::{
    fs,
    io::{self, Write},
};

use _gammaloop::{
    feyngen::{
        diagram_generator::FeynGen, FeynGenFilter, FeynGenOptions, GenerationType,
        SelfEnergyFilterOptions, SnailFilterOptions, TadpolesFilterOptions,
    },
    numerator::GlobalPrefactor,
};
use ahash::{HashMap, HashMapExt};
use dis::{load_generic_model, DisGraph};
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
    let mut coupling = HashMap::new();
    coupling.insert("QED".into(), 2);
    let options = FeynGenOptions {
        generation_type: GenerationType::Amplitude,
        initial_pdgs: vec![22],
        final_pdgs: vec![22],
        loop_count_range: (nloops, nloops),
        allow_symmetrization_of_external_fermions_in_amplitudes: false,
        symmetrize_final_states: true,
        symmetrize_initial_states: true,
        symmetrize_left_right_states: true,
        amplitude_filters: _gammaloop::feyngen::FeynGenFilters(vec![
            FeynGenFilter::ParticleVeto(vec![
                23, 24, 9000001, 9000002, 9000003, 9000004, 12, 14, 16, 2, 4, 6, 3, 5, 25, 250,
                251, 11, 13, 15,
            ]),
            FeynGenFilter::SelfEnergyFilter(SelfEnergyFilterOptions::default()),
            FeynGenFilter::ZeroSnailsFilter(SnailFilterOptions::default()),
            FeynGenFilter::TadpolesFilter(TadpolesFilterOptions::default()),
            FeynGenFilter::CouplingOrders(coupling),
        ]),
        cross_section_filters: _gammaloop::feyngen::FeynGenFilters(vec![]),
    };
    let diagram_gen = FeynGen::new(options);

    let diagrams: Vec<_> = diagram_gen
        .generate(
            &model,
            &_gammaloop::feyngen::NumeratorAwareGraphGroupingOption::OnlyDetectZeroes,
            true,
            "DIS".into(),
            None,
            None,
            None,
            GlobalPrefactor::default(),
            None,
        )
        .unwrap();

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
