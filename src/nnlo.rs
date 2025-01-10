use _gammaloop::{
    feyngen::{
        diagram_generator::FeynGen, FeynGenFilter, FeynGenOptions, GenerationType,
        SelfEnergyFilterOptions, SnailFilterOptions, TadpolesFilterOptions,
    },
    model::Model,
};
use ahash::{HashMap, HashMapExt};
use dis::{load_generic_model, DisGraph};
use indicatif::ProgressBar;

fn main() {
    let nloops = 3;

    let model = load_generic_model("sm");
    let mut coupling = HashMap::new();
    coupling.insert("QED".into(), 2);
    let options = FeynGenOptions {
        generation_type: GenerationType::CrossSection,
        initial_pdgs: vec![22],
        final_pdgs: vec![],
        loop_count_range: (nloops, nloops),
        symmetrize_final_states: true,
        symmetrize_initial_states: true,
        symmetrize_left_right_states: true,
        filters: _gammaloop::feyngen::FeynGenFilters(vec![
            FeynGenFilter::ParticleVeto(vec![
                23, 24, 9000001, 9000002, 9000003, 9000004, 12, 14, 16, 2, 4, 6, 3, 5, 25, 250,
                251, 11, 13, 15,
            ]),
            FeynGenFilter::SelfEnergyFilter(SelfEnergyFilterOptions::default()),
            FeynGenFilter::ZeroSnailsFilter(SnailFilterOptions::default()),
            FeynGenFilter::TadpolesFilter(TadpolesFilterOptions::default()),
            FeynGenFilter::CouplingOrders(coupling),
        ]),
    };
    let diagram_gen = FeynGen::new(options);

    let diagrams: Vec<_> = diagram_gen
        .generate(
            &model,
            _gammaloop::feyngen::NumeratorAwareGraphGroupingOption::OnlyDetectZeroes,
            true,
            "DIS".into(),
            None,
            None,
            None,
        )
        .unwrap()
        .into_iter()
        .map(|a| DisGraph::from_self_energy_bare(&a, &model))
        .collect();

    let mut bar = ProgressBar::new(diagrams.len() as u64);

    for (i, d) in diagrams.iter().enumerate() {
        let ifsplit = d.full_dis_filter_split();
        ifsplit.to_typst(d, &format!("supergraph{i}.typ")).unwrap();
        bar.inc(1);
    }
    DisGraph::to_typst(&diagrams, 10., "nnlo.typ").unwrap();
}
