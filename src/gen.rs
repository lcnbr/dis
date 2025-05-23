use _gammaloop::{
    feyngen::{
        diagram_generator::FeynGen, FeynGenFilter, FeynGenFilters, FeynGenOptions, GenerationType,
        SelfEnergyFilterOptions, SewedFilterOptions, SnailFilterOptions, TadpolesFilterOptions,
    },
    graph::BareGraph,
    model::Model,
    numerator::GlobalPrefactor,
};
use ahash::{HashMap, HashMapExt, HashSet};
use itertools::Itertools;
use log::info;

use crate::Pdg;

pub fn photon_self_energy_gen(nloops: usize, model: &Model) -> Vec<BareGraph> {
    let mut coupling = HashMap::new();
    coupling.insert("QED".into(), (2, Some(2)));

    let options = FeynGenOptions {
        max_multiplicity_for_fast_cut_filter: 1,
        generation_type: GenerationType::Amplitude,
        initial_pdgs: vec![22],
        final_pdgs_lists: vec![vec![22]],
        loop_count_range: (nloops, nloops),
        allow_symmetrization_of_external_fermions_in_amplitudes: false,
        symmetrize_final_states: true,
        symmetrize_initial_states: true,
        symmetrize_left_right_states: true,
        amplitude_filters: _gammaloop::feyngen::FeynGenFilters(vec![
            FeynGenFilter::ParticleVeto(vec![
                23, 24, 9000001, 9000002, 9000003, 9000004, 9000005, -9000005, 12, 14, 16, 2, 4, 6,
                3, 5, 25, 250, 251, 11, 13, 15,
            ]),
            FeynGenFilter::SelfEnergyFilter(SelfEnergyFilterOptions::default()),
            FeynGenFilter::ZeroSnailsFilter(SnailFilterOptions::default()),
            FeynGenFilter::TadpolesFilter(TadpolesFilterOptions::default()),
            FeynGenFilter::CouplingOrders(coupling),
        ]),
        cross_section_filters: _gammaloop::feyngen::FeynGenFilters(vec![]),
    };
    let diagram_gen = FeynGen::new(options);
    diagram_gen
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
        .unwrap()
}

pub fn dis_options_impl(
    init: &[Pdg],
    final_states: &[Vec<Pdg>],
    pert: usize,
    loop_count: usize,
    coupling: usize,
) -> FeynGen {
    let mut amp_coupling = HashMap::new();
    amp_coupling.insert("QED".into(), (2, Some(2)));
    amp_coupling.insert("LT".into(), (1, Some(1)));
    let mut xs_coupling = HashMap::new();
    xs_coupling.insert("QCD".into(), (coupling, Some(coupling)));

    let mut xs_pert = HashMap::new();
    xs_pert.insert("QCD".into(), 100);
    FeynGen {
        options: FeynGenOptions {
            generation_type: GenerationType::CrossSection,
            initial_pdgs: init.iter().map(|a| a.pdg as i64).collect(),
            final_pdgs_lists: final_states
                .iter()
                .map(|f| f.iter().map(|a| a.pdg as i64).collect())
                .collect(),
            loop_count_range: (loop_count, loop_count),
            symmetrize_initial_states: true,
            symmetrize_final_states: true,
            symmetrize_left_right_states: true,
            allow_symmetrization_of_external_fermions_in_amplitudes: false,
            max_multiplicity_for_fast_cut_filter: 0,
            amplitude_filters: FeynGenFilters(vec![
                FeynGenFilter::ParticleVeto(vec![
                    23, 24, 9000001, 9000002, 9000003, 9000004, 9000005, -9000005, 12, 14, 16, 2,
                    4, 6, 3, 5, 25, 250, 251, 13, 15,
                ]),
                FeynGenFilter::TadpolesFilter(TadpolesFilterOptions {
                    veto_tadpoles_attached_to_massive_lines: true,
                    veto_tadpoles_attached_to_massless_lines: true,
                    veto_only_scaleless_tadpoles: false,
                }),
                FeynGenFilter::ZeroSnailsFilter(SnailFilterOptions {
                    veto_snails_attached_to_massive_lines: false,
                    veto_snails_attached_to_massless_lines: true,
                    veto_only_scaleless_snails: false,
                }),
                FeynGenFilter::CouplingOrders(amp_coupling),
            ]),
            cross_section_filters: FeynGenFilters(vec![
                FeynGenFilter::SewedFilter(SewedFilterOptions {
                    filter_tadpoles: true,
                }),
                FeynGenFilter::ParticleVeto(vec![
                    23, 24, 9000001, 9000002, 9000003, 9000004, 9000005, -9000005, 12, 14, 16, 2,
                    4, 6, 3, 5, 25, 250, 251, 13, 15,
                ]),
                FeynGenFilter::TadpolesFilter(TadpolesFilterOptions {
                    veto_tadpoles_attached_to_massive_lines: true,
                    veto_tadpoles_attached_to_massless_lines: true,
                    veto_only_scaleless_tadpoles: false,
                }),
                FeynGenFilter::ZeroSnailsFilter(SnailFilterOptions {
                    veto_snails_attached_to_massive_lines: false,
                    veto_snails_attached_to_massless_lines: true,
                    veto_only_scaleless_snails: false,
                }),
                FeynGenFilter::PerturbativeOrders(xs_pert),
                FeynGenFilter::CouplingOrders(xs_coupling),
                FeynGenFilter::LoopCountRange((loop_count, loop_count)),
                FeynGenFilter::BlobRange(1..=1),
                FeynGenFilter::SpectatorRange(0..=200),
            ]),
        },
    }
}

pub fn dis_options(
    init: &[&'static str],
    final_states: &[Vec<&'static str>],
    pert: usize,
    model: &Model,
) -> FeynGen {
    let initial_pdgs: Vec<_> = init
        .iter()
        .map(|a| Pdg {
            pdg: model.get_particle(a).pdg_code,
        })
        .collect();

    let final_pdgs_lists: Vec<_> = final_states
        .iter()
        .map(|f| {
            f.iter()
                .map(|a| Pdg {
                    pdg: model.get_particle(a).pdg_code,
                })
                .collect()
        })
        .collect();

    let initial_state_mult = init.len();
    let loop_count = pert + 3 - initial_state_mult;
    let coupling = 2 * pert;
    dis_options_impl(&initial_pdgs, &final_pdgs_lists, pert, loop_count, coupling)
}
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

pub fn dis_cart_prod_impl(
    initial_states: &[Pdg],
    loop_count: usize,
    initial_state_template: Vec<Pdg>,
    final_state_template: Vec<Pdg>,
) -> Vec<FeynGen> {
    let mut options = vec![];

    let initial_states: HashSet<Pdg> = initial_states.into_iter().cloned().collect();

    let final_states = initial_states
        .iter()
        .map(|a| {
            let mut temp = final_state_template.clone();

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

            let pert = loop_count;
            let loop_count = pert + 2 - initial_state_mult;
            let coupling = 2 * pert;

            options.push(dis_options_impl(
                &init_states,
                &final_states,
                pert,
                loop_count,
                coupling,
            ));
        }
    }

    options
}

pub fn dis_cart_prod(
    initial_states: &[&'static str],
    loop_count: usize,
    model: &Model,
) -> Vec<FeynGen> {
    let initial_states: Vec<_> = initial_states
        .iter()
        .map(|a| Pdg::from_name(a, model))
        .collect_vec();
    dis_cart_prod_impl(
        &initial_states,
        loop_count,
        vec![Pdg::from_name("e-", model)],
        vec![Pdg::from_name("e-", model)],
    )
}

pub fn chain_dis_generate(options: &[FeynGen], model: &Model) -> Vec<BareGraph> {
    options
        .iter()
        .flat_map(|a| {
            a.generate(
                &model,
                &_gammaloop::feyngen::NumeratorAwareGraphGroupingOption::OnlyDetectZeroes,
                true,
                "DIS".into(),
                None,
                None,
                None,
                GlobalPrefactor::default(),
                Some(10),
            )
            .unwrap()
        })
        .collect()
}
