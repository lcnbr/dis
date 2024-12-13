use std::{collections::BTreeMap, path::Path, sync::LazyLock};

use _gammaloop::{
    graph::{
        half_edge::{
            layout::{FancySettings, LayoutParams, PositionalHedgeGraph},
            subgraph::{Cycle, Inclusion, OrientedCut, SubGraph, SubGraphOps},
            EdgeId, Hedge, HedgeGraph, Orientation,
        },
        BareGraph, Edge, Vertex,
    },
    model::{normalise_complex, Model},
    momentum::{Sign, SignOrZero},
    numerator::{AppliedFeynmanRule, GlobalPrefactor, Numerator, UnInit},
};
use ahash::AHashMap;
use indexmap::IndexMap;
use log::debug;
use serde::{Deserialize, Serialize};
use spenso::{
    arithmetic::ScalarMul,
    contraction::Contract,
    data::{DataTensor, StorageTensor},
    parametric::atomcore::PatternReplacement,
    shadowing::ETS,
    structure::{
        representation::{Rep, RepName},
        slot::IsAbstractSlot,
        ScalarTensor,
    },
};
use symbolica::{
    atom::{Atom, AtomCore, AtomView, FunctionBuilder, Symbol},
    coefficient::Coefficient,
    fun,
    id::{MatchSettings, Pattern, PatternOrMap, Replacement},
    state::{FunctionAttribute, State},
    symb,
};

#[derive(Debug, Clone, Eq, PartialEq)]
pub struct Embeddings {
    pub cuts: BTreeMap<Embedding, Vec<OrientedCut>>,
    pub basis: Vec<Cycle>,
}

#[derive(Debug, Clone, Eq, PartialEq, Hash, PartialOrd, Ord)]
pub struct Embedding {
    pub windings: Vec<i32>,
}

pub struct IFCuts {
    pub cuts: BTreeMap<Embedding, [Vec<OrientedCut>; 2]>,
    pub basis: Vec<Cycle>,
}

impl IFCuts {
    pub fn remove_empty(&mut self) {
        self.cuts.retain(|_, v| !v[0].is_empty() & !v[1].is_empty());
    }
}

impl Embedding {
    pub fn windings_in_field(&self, n: u32) -> Vec<u32> {
        self.windings
            .iter()
            .map(|&i| {
                if i < 0 {
                    (n as i32 + i) as u32
                } else {
                    i as u32
                }
            })
            .collect()
    }
}

impl Embeddings {
    pub fn remove_singles(&mut self) {
        self.cuts.retain(|_, v| v.len() > 1);
    }

    pub fn if_split<E, V>(self, graph: &HedgeGraph<E, V>, filter: &impl Fn(&E) -> bool) -> IFCuts {
        let cuts = self
            .cuts
            .into_iter()
            .map(|(k, v)| {
                let mut split = [Vec::new(), Vec::new()];
                for cut in v {
                    let mut is_in = false;
                    for (_, e) in cut.iter_edges(graph) {
                        if filter(e.as_ref().data.unwrap()) {
                            is_in = true;
                        }
                    }

                    if is_in {
                        split[0].push(cut);
                    } else {
                        split[1].push(cut);
                    }
                }

                (k, split)
            })
            .collect();

        IFCuts {
            cuts,
            basis: self.basis,
        }
    }

    pub fn classify(
        iter: impl IntoIterator<Item = OrientedCut>,
        basis: Vec<Cycle>,
        filter: impl Fn(&OrientedCut) -> bool,
        flip_sym: bool,
    ) -> Embeddings {
        let mut cuts = BTreeMap::new();

        for cut in iter {
            if !filter(&cut) {
                continue;
            }
            let mut windings = Vec::new();

            let mut first_non_zero = None;

            for cycle in basis.iter() {
                let mut winding_number = cut.winding_number(cycle);
                if flip_sym {
                    if let Some(sign) = first_non_zero {
                        winding_number *= sign as i32;
                    } else if winding_number > 0 {
                        first_non_zero = Some(Sign::Positive);
                    } else if winding_number < 0 {
                        first_non_zero = Some(Sign::Negative);
                        winding_number *= -1;
                    };
                }
                windings.push(winding_number);
            }
            cuts.entry(Embedding { windings })
                .or_insert_with(Vec::new)
                .push(cut);
        }

        Embeddings { cuts, basis }
    }
}

pub fn load_generic_model(name: &str) -> Model {
    Model::from_file(String::from(
        Path::new(&format!("models/{}.yaml", name))
            .to_str()
            .unwrap(),
    ))
    .unwrap()
}

pub trait ToDisGraph {
    fn to_dis_graph(&self) -> DisGraph;
}

impl ToDisGraph for BareGraph {
    fn to_dis_graph(&self) -> DisGraph {
        let mut h = self.hedge_representation.clone();

        let mut elec_node = None;

        if let Some((elec, d)) = h.iter_egdes(&h.full_filter()).find(|(e, n)| {
            if self.edges[**n.as_ref().data.unwrap()]
                .particle
                .pdg_code
                .abs()
                == 11
            {
                true
            } else {
                false
            }
        }) {
            if let EdgeId::Paired { source, sink } = elec {
                elec_node = Some(h.node_id(source).clone());
            }
        }

        let mut included_hedge = None;
        let node = if let Some(s) = elec_node {
            for i in s.hairs.included_iter() {
                if self.edges[*h.get_edge_data(i)].particle.pdg_code.abs() == 11 {
                    included_hedge = Some(i);
                    break;
                }
            }
            s
        } else {
            h.node_id(Hedge(0)).clone()
        };

        let (basis, tree) = h
            .paton_cycle_basis(&h.full_graph(), &node, included_hedge)
            .unwrap();
        h.align_to_tree_underlying(&tree);

        // println!("{}", h.base_dot());
        // println!("{}", h.dot(&tree.tree));

        let mut seen_pdg22 = None;
        let mut seen_pdg11 = None;
        let lmbsymb = symb!("k");
        let graph = h.map(
            |bare_vertex_id| DisVertex {
                bare_vertex_id,
                bare_vertex: self.vertices[bare_vertex_id].clone(),
            },
            |e, d| {
                let mut mom_e = Atom::new_num(0);

                let mut first_cycle = None;
                let mut only_cycle = true;

                for (i, c) in basis.iter().enumerate() {
                    if let EdgeId::Paired { source, .. } = e {
                        if c.filter.includes(&source) {
                            if first_cycle.is_none() {
                                first_cycle = Some(i);
                            } else {
                                only_cycle = false;
                            }
                            mom_e = mom_e + fun!(lmbsymb, i as i32)
                        }
                    }
                }
                d.and_then(|bare_edge_id| {
                    let bare_edge = self.edges[bare_edge_id].clone();

                    let marked = if only_cycle {
                        if let Some(i) = first_cycle {
                            match bare_edge.particle.pdg_code.abs() {
                                11 => {
                                    if seen_pdg11.is_some() {
                                        false
                                    } else {
                                        seen_pdg11 = Some((e, i));
                                        true
                                    }
                                }
                                22 => {
                                    if seen_pdg22.is_some() {
                                        false
                                    } else {
                                        seen_pdg22 = Some((e, i));
                                        true
                                    }
                                }
                                _ => false,
                            }
                        } else {
                            false
                        }
                    } else {
                        false
                    };

                    Some(DisEdge {
                        bare_edge,
                        bare_edge_id,
                        marked,
                        momentum: mom_e,
                    })
                })
            },
        );

        let mut outer_graph = graph.empty_filter();

        for (i, e) in graph.iter_egdes(&graph.full_filter()) {
            match i {
                EdgeId::Paired { source, sink } => {
                    if e.data.as_ref().unwrap().bare_edge.particle.pdg_code.abs() == 11 {
                        outer_graph.set(source.0, true);
                        for i in graph.node_id(sink).included_iter() {
                            outer_graph.set(i.0, true);
                        }
                        outer_graph.set(sink.0, true);
                    }
                }
                _ => {}
            }
        }

        let inner_graph = outer_graph.complement(&graph);

        let mink = Rep::new_self_dual("mink").unwrap();
        let mu = mink.new_slot(4, 3).to_atom();
        let nu = mink.new_slot(4, 2).to_atom();
        let metric = fun!(ETS.metric, mu, nu);
        let p = symb!("p");
        let phat2 = Atom::new_var(symb!("phat")).pow(&Atom::new_num(2));
        let pp = fun!(p, mu) * fun!(p, nu);
        let diminv = Atom::parse("1/(2-D)").unwrap();

        let w1_proj = GlobalPrefactor {
            color: Atom::new_num(1),
            colorless: &diminv * (&metric - &pp / &phat2),
        };

        let w2_proj = GlobalPrefactor {
            color: Atom::new_num(1),
            colorless: (diminv * (metric - &pp / &phat2) + &pp / &phat2) / &phat2,
        };

        let mut w1 = _gammaloop::numerator::Numerator::default()
            .from_dis_graph(self, &graph, &inner_graph, Some(&w1_proj))
            .color_simplify()
            .gamma_simplify()
            .get_single_atom()
            .unwrap()
            .0;

        let mut w2 = _gammaloop::numerator::Numerator::default()
            .from_dis_graph(self, &graph, &inner_graph, Some(&w2_proj))
            .color_simplify()
            .gamma_simplify()
            .get_single_atom()
            .unwrap()
            .0;

        numerator_dis_apply(&mut w1);
        numerator_dis_apply(&mut w2);

        let mut props = vec![];
        for (j, e) in graph.iter_egdes(&inner_graph) {
            let edge = &e.data.as_ref().unwrap().bare_edge;
            let i = e.data.as_ref().unwrap().bare_edge_id;
            if matches!(j, EdgeId::Paired { .. }) {
                let mass = edge.particle.mass.expression.clone();
                let emr_mom = fun!(DIS_SYMBOLS.emr_mom, i as i32);
                props.push(Prop::new(mass, emr_mom));
                // denominator = denominator * fun!(denomsymb, mass, emr_mom);
            };
        }

        DisGraph {
            graph,
            numerator: vec![w1.expand(), w2.expand()],
            denominator: DenominatorDis::new(props),
            lmb_photon: seen_pdg22.unwrap(),
            marked_electron_edge: seen_pdg11.unwrap(),
            basis,
        }
    }
}

pub struct DisSymbols {
    pub prop: Symbol,
    pub cut_mom: Symbol,
    pub photon_mom: Symbol,
    pub emr_mom: Symbol,
    pub loop_mom: Symbol,
    pub dim: Symbol,
    pub dot: Symbol,
}

const DIS_SYMBOLS: LazyLock<DisSymbols> = LazyLock::new(|| DisSymbols {
    prop: symb!("prop"),
    cut_mom: symb!("p"),
    photon_mom: symb!("q"),
    emr_mom: symb!("Q"),
    loop_mom: symb!("l"),
    dim: symb!("dim"),
    dot: State::get_symbol_with_attributes(
        "dot",
        &[FunctionAttribute::Symmetric, FunctionAttribute::Linear],
    )
    .unwrap(),
});

pub trait NumeratorFromHedgeGraph {
    fn from_dis_graph<S: SubGraph>(
        self,
        bare: &BareGraph,
        graph: &HedgeGraph<DisEdge, DisVertex>,
        subgrap: &S,
        prefactor: Option<&GlobalPrefactor>,
    ) -> Numerator<AppliedFeynmanRule>;
}

impl NumeratorFromHedgeGraph for Numerator<UnInit> {
    fn from_dis_graph<S: SubGraph>(
        self,
        bare: &BareGraph,
        graph: &HedgeGraph<DisEdge, DisVertex>,
        subgraph: &S,
        prefactor: Option<&GlobalPrefactor>,
    ) -> Numerator<AppliedFeynmanRule> {
        let mut vatoms = Vec::new();
        for (n, v) in graph.iter_node_data(subgraph) {
            if let Some(a) = v.bare_vertex.colorless_vertex_rule(bare) {
                vatoms.push(a);
            }
        }

        let mut eatoms: Vec<_> = vec![];
        let i = Atom::new_var(Atom::I);
        for (j, e) in graph.iter_egdes(subgraph) {
            let edge = &e.data.as_ref().unwrap().bare_edge;
            let [n, c] = edge.color_separated_numerator(bare);
            if matches!(j, EdgeId::Paired { .. }) {
                eatoms.push([&n * &i, c]);
            };
            // shift += s;
            // graph.shifts.0 += shift;
        }
        let mut colorless_builder = DataTensor::new_scalar(Atom::new_num(1));

        let mut colorful_builder = DataTensor::new_scalar(Atom::new_num(1));

        for [colorless, color] in &vatoms {
            colorless_builder = colorless_builder.contract(colorless).unwrap();
            colorful_builder = colorful_builder.contract(color).unwrap();
            // println!("vertex: {v}");
            // builder = builder * v;
        }

        for [n, c] in &eatoms {
            colorless_builder = colorless_builder.scalar_mul(n).unwrap();
            colorful_builder = colorful_builder.scalar_mul(c).unwrap();
        }

        if let Some(prefactor) = prefactor {
            colorless_builder = colorless_builder.scalar_mul(&prefactor.colorless).unwrap();
            colorful_builder = colorful_builder.scalar_mul(&prefactor.color).unwrap();
        }

        let mut num = AppliedFeynmanRule {
            colorless: colorless_builder.map_data(|a| normalise_complex(&a).into()),
            color: colorful_builder.map_data(|a| normalise_complex(&a).into()),
            state: Default::default(),
        };
        num.simplify_ids();

        let state = num;
        debug!(
            "Applied feynman rules:\n\tcolor:{}\n\tcolorless:{}",
            state.color, state.colorless
        );
        Numerator { state }
    }
}

pub fn numerator_dis_apply(num: &mut Atom) {
    let f_ = symb!("f_");
    let g_ = symb!("g_");
    let a_ = Atom::new_var(symb!("a_"));
    let b_ = Atom::new_var(symb!("b_"));
    let c_ = Atom::new_var(symb!("c_"));

    let dim = DIS_SYMBOLS.dim;
    let p = DIS_SYMBOLS.cut_mom;
    let q = DIS_SYMBOLS.photon_mom;
    let emrmom = DIS_SYMBOLS.emr_mom;
    let dot = DIS_SYMBOLS.dot;

    let reps = vec![
        (
            fun!(ETS.metric, a_, b_).pow(&Atom::new_num(2)),
            Atom::new_var(dim),
        ),
        (
            fun!(emrmom, b_, a_) * fun!(emrmom, c_, a_),
            fun!(dot, fun!(emrmom, b_), fun!(emrmom, c_)),
        ),
        (
            fun!(p, a_) * fun!(emrmom, c_, a_),
            fun!(dot, p, fun!(emrmom, c_)),
        ),
        (
            fun!(q, a_) * fun!(emrmom, c_, a_),
            fun!(dot, q, fun!(emrmom, c_)),
        ),
        (fun!(p, a_) * fun!(p, a_), fun!(dot, p, p)),
        (fun!(p, a_) * fun!(q, a_), fun!(dot, p, q)),
        (fun!(q, a_) * fun!(q, a_), fun!(dot, q, q)),
        (
            fun!(ETS.metric, a_, b_) * fun!(emrmom, c_, a_),
            fun!(emrmom, c_, b_),
        ),
        (fun!(ETS.metric, a_, b_) * fun!(p, a_), fun!(p, b_)),
        (fun!(ETS.metric, a_, b_) * fun!(q, a_), fun!(q, b_)),
    ];

    let replacements: Vec<Replacement> = reps
        .into_iter()
        .map(|(a, b)| Replacement::new(a.to_pattern(), b.to_pattern()))
        .collect();

    num.replace_all_multiple_repeat_mut(&replacements)
}

// impl HedgeGraph<(usize, crate::graph::Edge, bool), (usize, crate::graph::Vertex)> {
//     pub fn dis_graph(mut self) -> HedgeGraph<DisEdge, DisVertex> {
//         let (basis, tree) = self.cycle_basis();
//         self.align_to_tree_underlying(&tree);

//         let lmbsymb = symb!("k");
//         self.map(
//             |(bare_vertex_id, bare_vertex)| DisVertex {
//                 bare_vertex_id,
//                 bare_vertex,
//             },
//             |e, d| {
//                 let mut mom_e = Atom::new_num(0);
//                 for (i, c) in basis.iter().enumerate() {
//                     if let EdgeId::Paired { source, .. } = e {
//                         if c.filter.includes(&source) {
//                             mom_e = mom_e + fun!(lmbsymb, i as i32)
//                         }
//                     }
//                 }
//                 d.and_then(|(bare_edge_id, bare_edge, marked)| {
//                     Some(DisEdge {
//                         bare_edge,
//                         bare_edge_id,
//                         marked,
//                         momentum: mom_e,
//                     })
//                 })
//             },
//         )
//     }

//     // pub fn propagators()
// }

pub struct DisGraph {
    graph: HedgeGraph<DisEdge, DisVertex>,
    marked_electron_edge: (EdgeId, usize),
    lmb_photon: (EdgeId, usize),
    numerator: Vec<Atom>,
    denominator: DenominatorDis,
    basis: Vec<Cycle>,
}

impl DisGraph {
    pub fn numerator(&self, cut: &OrientedCut, total: Symbol) -> Vec<Atom> {
        let emr_to_lmb_cut = self.emr_to_lmb_and_cut(cut, total);

        self.numerator
            .iter()
            .map(|a| a.replace_all_multiple(&emr_to_lmb_cut))
            .collect()
    }

    pub fn denominator(&self, cut: &OrientedCut, total: Symbol) -> DenominatorDis {
        let emr_to_lmb_cut = self.emr_to_lmb_and_cut(cut, total);
        self.denominator
            .map_all(&|a| a.replace_all_multiple(&emr_to_lmb_cut).expand())
    }

    pub fn emr_to_lmb_and_cut(&self, cut: &OrientedCut, total: Symbol) -> Vec<Replacement> {
        let (all_rest, solved_for) = self.cut_constraint(cut, total);

        let pattern = &solved_for.to_pattern();
        let rhs = &all_rest.to_pattern();

        let mut emr_to_lmb_cut = AHashMap::new();
        for (e, d) in self.graph.iter_egdes(&self.graph.full_graph()) {
            let data = d.data.unwrap();
            emr_to_lmb_cut.insert(
                fun!(symb!("Q"), data.bare_edge_id as i32),
                data.momentum
                    .replace_all(pattern, rhs, None, None)
                    .to_pattern(),
            );
        }

        emr_to_lmb_cut
            .into_iter()
            .map(|(k, v)| Replacement::new(k.to_pattern(), v))
            .collect()
    }

    pub fn cut_constraint(&self, cut: &OrientedCut, total: Symbol) -> (Atom, Atom) {
        let mut sum = Atom::new_num(0);

        let mut total = Atom::new_var(total);
        let electron_momenta = fun!(symb!("k"), self.marked_electron_edge.1 as i32);
        // println!("p_e {}", electron_momenta);

        let photon_momenta = fun!(symb!("k"), self.lmb_photon.1 as i32);
        // println!("q:{}", photon_momenta);

        if let EdgeId::Paired { source, sink } = self.marked_electron_edge.0 {
            match cut.relative_orientation(source) {
                Orientation::Default => {
                    total = total + &electron_momenta;
                }
                Orientation::Reversed => {
                    total = total - &electron_momenta;
                }
                _ => {}
            }
        }

        for (o, cut_edge) in cut.iter_edges_relative(&self.graph) {
            // println!(
            //     "{}{}{}",
            //     SignOrZero::from(o),
            //     cut_edge.as_ref().data.unwrap().bare_edge_id,
            //     SignOrZero::from(o) * cut_edge.as_ref().data.unwrap().momentum.clone()
            // );
            sum = sum + SignOrZero::from(o) * cut_edge.as_ref().data.unwrap().momentum.clone();
        }

        let mut var = None;
        let mut all_rest = Atom::new_num(0);

        if let AtomView::Add(a) = sum.expand().as_view() {
            for e in a.iter() {
                if var.is_none() {
                    match e {
                        AtomView::Mul(m) => {
                            let mut iter = m.iter();
                            if let AtomView::Fun(v) = iter.next().unwrap() {
                                if photon_momenta.as_view() == v.as_view()
                                    || electron_momenta.as_view() == v.as_view()
                                {
                                    all_rest = all_rest + e;
                                } else {
                                    var = Some(e.to_owned());
                                }
                            } else {
                                panic!("{}", e)
                            }
                        }
                        AtomView::Fun(f) => {
                            if photon_momenta.as_view() == f.as_view()
                                || electron_momenta.as_view() == f.as_view()
                            {
                                all_rest = all_rest + e;
                            } else {
                                var = Some(e.to_owned());
                            }
                        }
                        _ => {
                            panic!("{}", e)
                        }
                    }
                } else {
                    all_rest = all_rest + e;
                }
            }
        }

        all_rest = total - all_rest;

        let (solved_for, coef) = match var.as_ref().unwrap().as_view() {
            AtomView::Mul(a) => {
                let mut solved = None;
                let mut coef = None;

                for i in a.iter() {
                    match i {
                        AtomView::Num(a) => match a.get_coeff_view().to_owned() {
                            symbolica::coefficient::Coefficient::Rational(a) => {
                                coef = Some(Coefficient::Rational(a.inv()));
                            }
                            _ => panic!("str"),
                        },
                        AtomView::Fun(f) => {
                            solved = Some(f.as_view().to_owned());
                        }
                        _ => panic!("str"),
                    }
                }
                (solved.unwrap(), Atom::new_num(coef.unwrap()))
            }
            AtomView::Fun(f) => (f.as_view().to_owned(), Atom::new_num(1)),
            _ => {
                panic!("should be a function or mul")
            }
        };

        // println!("coef:{coef}");

        // println!("all_rest: {}", (&all_rest * &coef).expand());
        // println!("solved_for: {}", solved_for);
        (all_rest * coef, solved_for)
    }
}

#[derive(Debug, Clone)]
pub struct DisEdge {
    pub bare_edge_id: usize,
    pub bare_edge: Edge,
    marked: bool,
    momentum: Atom,
}

#[derive(Debug, Clone)]
pub struct DisVertex {
    pub bare_vertex_id: usize,
    pub bare_vertex: Vertex,
}

pub struct MathematicaIntegrand {
    pq_to_ext: Vec<(Pattern, PatternOrMap)>,
    ext_to_pq: Vec<(Atom, Atom)>,
    prefactor: Atom,
    topology: HedgeGraph<(usize, Atom), ()>,
    numerators: Vec<Atom>,
}

#[derive(Clone, PartialEq, Eq, Debug)]
pub struct DenominatorDis {
    props: IndexMap<Prop, u8>,
    prefactor: Atom,
}

impl DenominatorDis {
    pub fn new(prop_iter: impl IntoIterator<Item = Prop>) -> Self {
        let mut props = IndexMap::new();
        for p in prop_iter {
            *props.entry(p).or_insert(1) += 1;
        }

        Self {
            props,
            prefactor: Atom::new_num(1),
        }
    }

    pub fn map_all(&self, f: &impl Fn(&Atom) -> Atom) -> Self {
        let props = self.props.iter().map(|(p, n)| (p.map_all(f), *n)).collect();
        let prefactor = f(&self.prefactor);
        Self { props, prefactor }
    }
}

#[derive(Clone, Hash, PartialEq, Eq, PartialOrd, Ord, Debug)]
pub struct Prop {
    pub mass: Option<Atom>,
    pub momentum: Atom,
}

impl Prop {
    pub fn new(mass: Option<Atom>, momentum: Atom) -> Self {
        Self { mass, momentum }
    }

    pub fn map_all(&self, f: &impl Fn(&Atom) -> Atom) -> Self {
        Self {
            mass: self.mass.as_ref().map(f),
            momentum: f(&self.momentum),
        }
    }
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct LayoutIters {
    n_iters: u64,
    temp: f64,
    seed: u64,
}

pub fn dis_cut_layout<'a>(
    cut: OrientedCut,
    graph: &'a DisGraph,
    params: LayoutParams,
    iter_params: LayoutIters,
    settings: Option<&FancySettings>,
    edge_len: f64,
) -> PositionalHedgeGraph<(&'a DisEdge, Orientation), &'a DisVertex> {
    // let layout_graph = graph.graph.map_edges_ref(f)

    // let file = std::fs::File::open("layout_params.json").unwrap();
    // let layout_iters = serde_yaml::from_reader::<_, LayoutIters>(file).unwrap();
    let mut pos = cut.layout(
        &graph.graph,
        params,
        iter_params.seed,
        iter_params.n_iters,
        iter_params.temp,
        edge_len,
    );

    if let Some(settings) = settings {
        pos.to_fancy(settings);
        pos
    } else {
        pos
    }
}
