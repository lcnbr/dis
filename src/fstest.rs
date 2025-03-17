use _gammaloop::{
    feyngen::{
        diagram_generator::FeynGen, FeynGenFilter, FeynGenOptions, GenerationType,
        GraphGroupingOptions, SelfEnergyFilterOptions, SnailFilterOptions, TadpolesFilterOptions,
    },
    numerator::GlobalPrefactor,
};
use ahash::{HashMap, HashMapExt};
use dis::load_generic_model;

fn main() {
    let model = load_generic_model("sm");
    let d = model.get_particle("d");
    let a = model.get_particle("a");
    let em = model.get_particle("e-");
    let g = model.get_particle("g");
    let mut coupling = HashMap::new();
    coupling.insert("QED".into(), 2);
    let options = FeynGenOptions {
        max_multiplicity_for_fast_cut_filter: 1,
        generation_type: GenerationType::CrossSection,
        initial_pdgs: vec![d.pdg_code as i64, em.pdg_code as i64],
        final_pdgs: vec![d.pdg_code as i64, em.pdg_code as i64],
        loop_count_range: (1, 1),
        allow_symmetrization_of_external_fermions_in_amplitudes: false,
        symmetrize_final_states: true,
        symmetrize_initial_states: true,
        symmetrize_left_right_states: true,
        amplitude_filters: _gammaloop::feyngen::FeynGenFilters(vec![
            FeynGenFilter::ParticleVeto(vec![
                23, 24, 9000001, 9000002, 9000003, 9000004, 12, 14, 16, 4, 6, 3, 5, 25, 250, 251,
                13, 15,
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
            &_gammaloop::feyngen::NumeratorAwareGraphGroupingOption::GroupIdenticalGraphUpToScalarRescaling(GraphGroupingOptions::default()),
            true,
            "DIS".into(),
            None,
            None,
            None,
            GlobalPrefactor::default(),
            None,
        )
        .unwrap();
}
