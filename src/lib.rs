use std::{
    collections::{BTreeMap, HashMap},
    fmt::Display,
    fs::File,
    io::Write,
    ops::Neg,
    path::Path,
    sync::{Arc, LazyLock},
};

use _gammaloop::{
    graph::{
        half_edge::{
            drawing::Decoration,
            layout::{FancySettings, LayoutIters, LayoutParams, PositionalHedgeGraph},
            subgraph::{Cycle, Inclusion, OrientedCut, SubGraph, SubGraphOps},
            EdgeData, EdgeId, Flow, Hedge, HedgeGraph, HedgeGraphBuilder, InvolutiveMapping,
            Orientation, TraversalTree,
        },
        BareGraph, Edge, Vertex,
    },
    model::{normalise_complex, Model},
    momentum::{Sign, SignOrZero, Signature},
    numerator::{AppliedFeynmanRule, GlobalPrefactor, Numerator, UnInit},
    utils::DAY,
};
use ahash::{AHashMap, AHashSet};
use bitvec::vec::BitVec;
use indexmap::{IndexMap, IndexSet};
use itertools::Itertools;
use log::debug;
use ref_ops::RefMutNot;
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
    atom::{Atom, AtomCore, AtomView, FunctionAttribute, Symbol},
    coefficient::ConvertToRing,
    domains::{
        integer::{Integer, Z},
        rational::{FractionField, Rational, Q},
        rational_polynomial::{RationalPolynomial, RationalPolynomialField},
        Ring, SelfRing,
    },
    fun,
    id::{Pattern, PatternOrMap, Replacement},
    poly::{PositiveExponent, Variable},
    symb,
    tensors::matrix::{Matrix, MatrixError},
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

    pub fn to_mathematica_file(&self, graph: &DisGraph, filename: &str) -> std::io::Result<()> {
        let mut embeddings = vec![];

        for (i, (e, cuts)) in self.cuts.iter().enumerate() {
            let mut map = AHashMap::new();
            let first_initial = &cuts[0][0];
            map.insert("embedding".to_string(), e.windings.to_math());
            let denom = graph.denominator(first_initial);
            let numers = graph.numerator(first_initial);
            // for n in &numers {
            //     println!(":{n}");
            // }
            let denoms = denom
                .partial_fraction()
                .into_iter()
                .map(|a| MathematicaIntegrand::new(a.topology(), &numers))
                .collect_vec();

            map.insert("partial_fractions".to_string(), denoms.to_math());

            embeddings.push(map);
        }

        let mut f = File::create(filename)?;
        write!(f, "{}", embeddings.to_math())?;
        Ok(())
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

pub struct DisSymbols {
    pub prop: Symbol,
    pub internal_mom: Symbol,
    pub external_mom: Symbol,
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
    loop_mom: symb!("k"),
    dim: symb!("dim"),
    internal_mom: symb!("l"),
    external_mom: symb!("p"),
    dot: Symbol::new_with_attributes(
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
        for (_, v) in graph.iter_node_data(subgraph) {
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
        println!("from dis success");
        Numerator { state }
    }
}

pub fn numerator_dis_apply(num: &mut Atom) {
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

pub struct DisGraph {
    graph: HedgeGraph<DisEdge, DisVertex>,
    marked_electron_edge: (EdgeId, usize),
    lmb_photon: (EdgeId, usize),
    numerator: Vec<Atom>,
    denominator: DenominatorDis,
    basis: Vec<Cycle>,
}

impl DisGraph {
    pub fn full_dis_filter_split(&self) -> IFCuts {
        let mut i = Embeddings::classify(
            OrientedCut::all_initial_state_cuts(&self.graph),
            self.basis.clone(),
            |c| {
                let contains_electron = self
                    .graph
                    .iter_egdes(c)
                    .filter(|(_, d)| d.data.unwrap().bare_edge.particle.pdg_code.abs() == 11)
                    .count();
                let alligned_electron = c.iter_edges_relative(&self.graph).all(|(o, d)| {
                    if d.data.as_ref().unwrap().bare_edge.particle.pdg_code.abs() == 11 {
                        match (o, d.orientation) {
                            (Orientation::Default, Orientation::Default) => true,
                            (Orientation::Reversed, Orientation::Reversed) => true,
                            _ => false,
                        }
                    } else {
                        true
                    }
                });
                let contains_photon = self
                    .graph
                    .iter_egdes(c)
                    .any(|(_, d)| d.data.unwrap().bare_edge.particle.pdg_code.abs() == 22);

                let mut complement = c.reference.complement(&self.graph);

                for i in self.graph.full_filter().included_iter() {
                    if self
                        .graph
                        .get_edge_data(i)
                        .bare_edge
                        .particle
                        .pdg_code
                        .abs()
                        == 11
                    {
                        complement.set(i.0, false);
                    }
                }

                let electron_disconnects = !self.graph.is_connected(&complement);

                contains_electron == 1
                    && !contains_photon
                    && alligned_electron
                    && !electron_disconnects
            },
            true,
        )
        .if_split(&self.graph, &|e| e.marked);
        i.remove_empty();
        i
    }

    pub fn from_bare(bare: &BareGraph) -> DisGraph {
        let mut h = bare.hedge_representation.clone();

        let mut elec_node = None;

        if let Some((elec, _)) = h.iter_egdes(&h.full_filter()).find(|(_, n)| {
            if bare.edges[**n.as_ref().data.unwrap()]
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
            if let EdgeId::Paired { source, .. } = elec {
                elec_node = Some(h.node_hairs(source).clone());
            }
        }

        let mut included_hedge = None;
        let node = if let Some(s) = elec_node {
            for i in s.hairs.included_iter() {
                if bare.edges[*h.get_edge_data(i)].particle.pdg_code.abs() == 11 {
                    included_hedge = Some(i);
                    break;
                }
            }
            s
        } else {
            h.node_hairs(Hedge(0)).clone()
        };

        println!("finding basis");

        let (basis, tree) = h
            .paton_cycle_basis(&h.full_graph(), &node, included_hedge)
            .unwrap();

        println!("aligning tree");
        h.align_to_tree_underlying(&tree);

        println!("{}", h.base_dot());
        println!("{}", h.dot(&tree.tree));

        let mut seen_pdg22 = None;
        let mut seen_pdg11 = None;
        let lmbsymb = symb!("k");
        let graph = h.map(
            |bare_vertex_id| DisVertex {
                bare_vertex_id,
                bare_vertex: bare.vertices[bare_vertex_id].clone(),
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
                    let bare_edge = bare.edges[bare_edge_id].clone();

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

                    let emr_mom = fun!(DIS_SYMBOLS.emr_mom, bare_edge_id as i32);

                    Some(DisEdge {
                        bare_edge,
                        bare_edge_id,
                        marked,
                        lmb_momentum: mom_e,
                        emr_momentum: emr_mom,
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
                        for i in graph.node_hairs(sink).included_iter() {
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
        let diminv = Atom::parse("1/(2-dim)").unwrap();

        let w1_proj = GlobalPrefactor {
            color: Atom::new_num(1),
            colorless: &diminv * (&metric - &pp / &phat2),
        };

        let w2_proj = GlobalPrefactor {
            color: Atom::new_num(1),
            colorless: (diminv * (metric - &pp / &phat2) + &pp / &phat2) / &phat2,
        };

        let mut w1 = _gammaloop::numerator::Numerator::default()
            .from_dis_graph(bare, &graph, &inner_graph, Some(&w1_proj))
            .color_simplify()
            .gamma_simplify()
            .get_single_atom()
            .unwrap()
            .0;

        let mut w2 = _gammaloop::numerator::Numerator::default()
            .from_dis_graph(bare, &graph, &inner_graph, Some(&w2_proj))
            .color_simplify();

        println!("color simplified:{}", w2.state.colorless);

        let mut w2 = w2.gamma_simplify();

        println!("gamma simplified: {}", w2.state.colorless);

        let mut w2 = w2.get_single_atom().unwrap().0;

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
    pub fn numerator(&self, cut: &OrientedCut) -> Vec<Atom> {
        let emr_to_lmb_cut = self.emr_to_lmb_and_cut(cut);

        self.numerator
            .iter()
            .map(|a| {
                let a = a.replace_all_multiple_repeat(&emr_to_lmb_cut);

                a
            })
            .collect()
    }

    pub fn denominator(&self, cut: &OrientedCut) -> DenominatorDis {
        let emr_to_lmb_cut = self.emr_to_lmb_and_cut(cut);
        self.denominator
            .map_all(&|a| a.replace_all_multiple(&emr_to_lmb_cut).expand())
    }

    pub fn emr_to_lmb_and_cut(&self, cut: &OrientedCut) -> Vec<Replacement> {
        let photon_momenta = fun!(DIS_SYMBOLS.loop_mom, self.lmb_photon.1 as i32);
        let mut reps = vec![Replacement::new(
            photon_momenta.to_pattern(),
            Atom::new_var(DIS_SYMBOLS.photon_mom).to_pattern(),
        )];
        if let Some((all_rest, solved_for)) = self.cut_constraint(cut) {
            reps.push(Replacement::new(
                solved_for.to_pattern(),
                all_rest.to_pattern(),
            ));
        }

        let mut emr_to_lmb_cut = AHashMap::new();
        for (_, d) in self.graph.iter_egdes(&self.graph.full_graph()) {
            let data = d.data.unwrap();

            println!(
                "{}->{}",
                fun!(DIS_SYMBOLS.emr_mom, data.bare_edge_id as i32),
                data.lmb_momentum.replace_all_multiple(&reps)
            );
            emr_to_lmb_cut.insert(
                fun!(DIS_SYMBOLS.emr_mom, data.bare_edge_id as i32),
                data.lmb_momentum.replace_all_multiple(&reps).to_pattern(),
            );
        }

        emr_to_lmb_cut
            .into_iter()
            .map(|(k, v)| Replacement::new(k.to_pattern(), v))
            .collect()
    }

    pub fn cut_constraint(&self, cut: &OrientedCut) -> Option<(Atom, Atom)> {
        let mut sum = Atom::new_num(0);

        // let mut total = Atom::new_var(DIS_SYMBOLS.cut_mom);
        // let electron_momenta = fun!(DIS_SYMBOLS.loop_mom, self.marked_electron_edge.1 as i32);
        let photon_momenta = fun!(DIS_SYMBOLS.loop_mom, self.lmb_photon.1 as i32);

        for (o, cut_edge) in cut.iter_edges_relative(&self.graph) {
            if cut_edge
                .data
                .as_ref()
                .unwrap()
                .bare_edge
                .particle
                .pdg_code
                .abs()
                != 11
            {
                sum = sum
                    + SignOrZero::from(o) * cut_edge.as_ref().data.unwrap().lmb_momentum.clone();
            }
        }
        sum = sum - Atom::new_var(DIS_SYMBOLS.cut_mom);
        sum = sum
            .replace_all_multiple(&[Replacement::new(
                photon_momenta.to_pattern(),
                Atom::new_var(DIS_SYMBOLS.photon_mom).to_pattern(),
            )])
            .expand();

        let loop_mom_pat = fun!(DIS_SYMBOLS.loop_mom, symb!("x_")).to_pattern();

        // println!("{sum}");
        let solving_var = sum
            .expand()
            .pattern_match(&loop_mom_pat, None, None)
            .next_detailed()?
            .target
            .to_owned();

        let solution = <Atom as AtomCore>::solve_linear_system::<u8, Atom, Atom>(
            &[sum],
            &[solving_var.clone()],
        )
        .unwrap()[0]
            .clone();

        // println!("solution: {}", solution);
        // println!("solving_var: {}", solving_var);

        Some((solution, solving_var))
    }
}

#[derive(Debug, Clone)]
pub struct DisEdge {
    pub bare_edge_id: usize,
    pub bare_edge: Edge,
    marked: bool,
    lmb_momentum: Atom,
    emr_momentum: Atom,
}

impl DisEdge {
    pub fn decoration(&self) -> Decoration {
        self.bare_edge.particle.decoration()
    }

    pub fn label(&self) -> String {
        self.lmb_momentum.to_string()
    }
}

#[derive(Debug, Clone)]
pub struct DisVertex {
    pub bare_vertex_id: usize,
    pub bare_vertex: Vertex,
}

pub struct MathematicaIntegrand {
    pq_to_ext: Vec<Replacement>,
    ext_to_pq: Vec<(Atom, Atom)>,
    prefactor: Atom,
    topology: Topology,
    numerators: Vec<Atom>,
}

impl MathematicaIntegrand {
    pub fn new(topology: Topology, numerators: &[Atom]) -> Self {
        let pq_to_ext = topology.map_pq_ext();
        let ext_to_pq = topology.map_ext_pq();

        let prefactor = topology.prefactor().replace_all_multiple(&pq_to_ext);

        let numerators = numerators
            .iter()
            .map(|a| a.replace_all_multiple(&pq_to_ext))
            .collect();

        Self {
            pq_to_ext,
            prefactor,
            ext_to_pq,
            topology,
            numerators,
        }
    }
}

impl ToMathematica for MathematicaIntegrand {
    fn to_math(&self) -> String {
        let mut map = AHashMap::new();

        map.insert("topology".to_string(), self.topology.to_math());

        map.insert(
            "ext_to_pq".to_string(),
            self.ext_to_pq
                .iter()
                .map(|(a, b)| (a, b))
                .collect::<AHashMap<_, _>>()
                .to_math(),
        );

        for n in &self.numerators {
            println!("num:{n}");
        }

        map.insert(
            "numerators".to_string(),
            self.numerators
                .iter()
                .map(|a| a * &self.prefactor)
                .collect_vec()
                .to_math(),
        );

        map.to_math()
    }
}

pub trait ToMathematica {
    fn to_math(&self) -> String;
}

impl<K: ToMathematica, V: ToMathematica> ToMathematica for AHashMap<K, V> {
    fn to_math(&self) -> String {
        let mut out = String::new();
        out.push_str("<|");
        let mut first = true;
        for (k, v) in self {
            if !first {
                out.push(',');
            } else {
                first = false;
            }
            out.push('"');
            out.push_str(&k.to_math());
            out.push('"');
            out.push_str("->");
            out.push_str(&v.to_math());
        }
        out.push_str("|>");
        out
    }
}

impl ToMathematica for String {
    fn to_math(&self) -> String {
        self.clone()
    }
}

impl ToMathematica for i32 {
    fn to_math(&self) -> String {
        self.to_string()
    }
}

impl ToMathematica for Atom {
    fn to_math(&self) -> String {
        self.printer(symbolica::printer::PrintOptions::mathematica())
            .to_string()
    }
}

impl ToMathematica for &Atom {
    fn to_math(&self) -> String {
        self.printer(symbolica::printer::PrintOptions::mathematica())
            .to_string()
    }
}

impl<E: ToMathematica> ToMathematica for Vec<E> {
    fn to_math(&self) -> String {
        let mut out = String::new();

        out.push_str("{");
        let mut first = true;
        for v in self {
            if !first {
                out.push(',');
            } else {
                first = false;
            }
            out.push_str(&v.to_math());
        }
        out.push('}');
        out
    }
}

#[derive(Debug, Clone)]
pub struct TopologyEdge {
    pub edgeid: usize,
    pub signature: Signature,
    pub propagator: Prop,
    pub power: u8,
}

pub struct Topology {
    pub graph: HedgeGraph<TopologyEdge, ()>,
    pub prefactor: Atom,
}

impl ToMathematica for Topology {
    fn to_math(&self) -> String {
        let mut map = AHashMap::new();

        let mut numbering_map = IndexSet::new();
        let mut nodelist = Vec::new();

        for (e, d) in self.graph.iter_egdes(&self.graph.external_filter()) {
            if let EdgeId::Unpaired { hedge, flow } = e {
                let (a, _) = numbering_map.insert_full(hedge);
                nodelist.push(vec![format!("{}p[{}]", SignOrZero::from(flow), a)]);
            } else {
                panic!("ahhhh");
            }
        }
        let ext_shift = numbering_map.len();

        for (n, _) in self.graph.iter_nodes() {
            let mut list = vec![];

            for (e, d) in self.graph.iter_egdes(&n.hairs) {
                match e {
                    EdgeId::Split {
                        source,
                        sink,
                        split,
                    } => {
                        let (a, _) = numbering_map.insert_full(source);
                        list.push(format!("{}l[{}]", SignOrZero::from(split), a - ext_shift));
                    }
                    EdgeId::Unpaired { hedge, flow } => {
                        let (a, _) = numbering_map.insert_full(hedge);
                        list.push(format!("{}p[{}]", SignOrZero::from(flow), a));
                    }
                    _ => {}
                }
            }
            nodelist.push(list);
        }
        map.insert(String::from("Neclace"), nodelist.to_math());

        let mut massmap = AHashMap::new();

        for (e, d) in self.graph.iter_egdes(&self.graph.full_filter()) {
            match e {
                EdgeId::Paired { source, sink } => {
                    let (a, _) = numbering_map.insert_full(source);
                    let k = format!("l[{}]", a - ext_shift);
                    massmap.insert(k, "0".to_string());
                }
                EdgeId::Unpaired { hedge, flow } => {
                    let (a, _) = numbering_map.insert_full(hedge);
                    let k = format!("p[{a}]");
                    massmap.insert(
                        k,
                        d.data
                            .unwrap()
                            .propagator
                            .mass
                            .as_ref()
                            .map_or("0".to_string(), |a| a.to_math()),
                    );
                }
                _ => {}
            }
        }

        map.insert(String::from("masses"), massmap.to_math());

        map.to_math()
    }
}

/// Solve a system that is linear in `vars`, if possible.
/// Each expression in `system` is understood to yield 0.
pub fn solve_linear_system<E: PositiveExponent, T1: AtomCore, T2: AtomCore>(
    system: &[T1],
    vars: &[T2],
) -> Result<Vec<Atom>, String> {
    let system: Vec<_> = system.iter().map(|v| v.as_atom_view()).collect();

    let vars: Vec<_> = vars
        .iter()
        .map(|v| v.as_atom_view().to_owned().into())
        .collect();

    solve_linear_system_impl::<E>(&system, &vars)
}

/// Convert a system of linear equations to a matrix representation, returning the matrix
/// and the right-hand side.
pub fn system_to_matrix<E: PositiveExponent, T1: AtomCore, T2: AtomCore>(
    system: &[T1],
    vars: &[T2],
) -> Result<
    (
        Matrix<RationalPolynomialField<Z, E>>,
        Matrix<RationalPolynomialField<Z, E>>,
    ),
    String,
> {
    let system: Vec<_> = system.iter().map(|v| v.as_atom_view()).collect();

    let vars: Vec<_> = vars
        .iter()
        .map(|v| v.as_atom_view().to_owned().into())
        .collect();

    system_to_matrix_impl::<E>(&system, &vars)
}

fn system_to_matrix_impl<E: PositiveExponent>(
    system: &[AtomView],
    vars: &[Variable],
) -> Result<
    (
        Matrix<RationalPolynomialField<Z, E>>,
        Matrix<RationalPolynomialField<Z, E>>,
    ),
    String,
> {
    let mut mat = Vec::with_capacity(system.len() * vars.len());
    let mut row = vec![RationalPolynomial::<_, E>::new(&Z, Arc::new(vec![])); vars.len()];
    let mut rhs = vec![RationalPolynomial::<_, E>::new(&Z, Arc::new(vec![])); system.len()];

    for (si, a) in system.iter().enumerate() {
        let rat: RationalPolynomial<Z, E> = a.to_rational_polynomial(&Q, &Z, None);

        let poly = rat.to_polynomial(&vars, true).unwrap();

        for e in &mut row {
            *e = RationalPolynomial::<_, E>::new(&Z, poly.variables.clone());
        }

        // get linear coefficients
        'next_monomial: for e in poly.into_iter() {
            if e.exponents.iter().cloned().sum::<E>() > E::one() {
                Err("Not a linear system")?;
            }

            for (rv, p) in row.iter_mut().zip(e.exponents) {
                if !p.is_zero() {
                    *rv = e.coefficient.clone();
                    continue 'next_monomial;
                }
            }

            // constant term
            rhs[si] = e.coefficient.clone().neg();
        }

        mat.extend_from_slice(&row);
    }

    let Some((first, rest)) = mat.split_first_mut() else {
        return Err("Empty system".to_owned());
    };

    for _ in 0..2 {
        for x in &mut *rest {
            first.unify_variables(x);
        }
        for x in &mut rhs {
            first.unify_variables(x);
        }
    }

    let field = RationalPolynomialField::new(Z);

    let m =
        Matrix::from_linear(mat, system.len() as u32, vars.len() as u32, field.clone()).unwrap();
    let b = Matrix::new_vec(rhs, field);

    Ok((m, b))
}

fn solve_linear_system_impl<E: PositiveExponent>(
    system: &[AtomView],
    vars: &[Variable],
) -> Result<Vec<Atom>, String> {
    let (m, b) = system_to_matrix_impl::<E>(system, vars)?;

    let sol = match m.solve_any(&b) {
        Ok(sol) => sol,
        Err(r) => return Err("aaa".to_string()),
    };

    // replace the temporary variables
    let mut result = Vec::with_capacity(vars.len());

    for s in sol.into_vector().into_vec() {
        result.push(s.to_expression());
    }

    Ok(result)
}

impl Topology {
    pub fn map_ext_pq(&self) -> Vec<(Atom, Atom)> {
        let mut map = Vec::new();
        let mut numbering_map = IndexSet::new();
        let extsymb = symb!("p");

        for (e, d) in self.graph.iter_egdes(&self.graph.external_filter()) {
            if let EdgeId::Unpaired { hedge, flow } = e {
                let (a, _) = numbering_map.insert_full(hedge);
                let p = fun!(extsymb, a as i32);

                map.push((
                    p,
                    SignOrZero::from(flow) * d.data.unwrap().propagator.momentum.clone(),
                ));
            } else {
                panic!("ahhhh");
            }
        }
        map
    }

    pub fn map_pq_ext(&self) -> Vec<Replacement> {
        let mut numbering_map = IndexSet::new();
        let extsymb = symb!("p");

        let mut vars = vec![];
        let mut eqs = vec![];
        let pq = vec![
            Atom::new_var(DIS_SYMBOLS.photon_mom),
            Atom::new_var(DIS_SYMBOLS.cut_mom),
        ];

        let mut sol = None;

        for (e, d) in self.graph.iter_egdes(&self.graph.external_filter()) {
            if let EdgeId::Unpaired { hedge, flow } = e {
                let (a, _) = numbering_map.insert_full(hedge);
                let p = SignOrZero::from(flow) * fun!(extsymb, a as i32);

                eqs.push(&d.data.unwrap().propagator.momentum - &p);
                vars.push(p);
            } else {
                panic!("ahhhh");
            }

            if eqs.len() == 2 {
                let (a, b) = Atom::system_to_matrix::<u8, _, _>(&eqs, &pq).unwrap();

                if let Ok(s) = a.solve_any(&b) {
                    sol = Some(s);
                    break;
                } else {
                    eqs.pop();
                    vars.pop();
                }
            }
        }
        sol.unwrap()
            .into_vector()
            .into_vec()
            .into_iter()
            .map(|s| s.to_expression())
            .zip(pq)
            .map(|(a, b)| Replacement::new(a.to_pattern(), b.to_pattern()))
            .collect()
    }

    pub fn prefactor(&self) -> Atom {
        let mut p = self.prefactor.clone();

        for (e, d) in self.graph.iter_egdes(&!self.graph.external_filter()) {
            let d = d.data.unwrap();
            if d.power > 1 {
                p = p / (d.propagator.to_atom().npow((d.power - 1) as i32))
            }
        }

        p
    }
}
pub struct LmbSignature {
    signs: Signature,
    overall_sign: Sign,
    prefactor: Rational,
}

pub struct EdgeSignatures {
    pub edge_signatures: Vec<LmbSignature>,
    pub basis: Vec<Atom>,
}

impl EdgeSignatures {
    pub fn basis_size(&self) -> usize {
        self.basis.len()
    }

    pub fn from_momenta(momenta: &[Atom]) -> Self {
        let mut basis = IndexSet::new();

        let loop_mom_pat = fun!(DIS_SYMBOLS.loop_mom, symb!("x_")).to_pattern();

        for p in momenta {
            let mut matches = p.pattern_match(&loop_mom_pat, None, None);

            while let Some(m) = matches.next_detailed() {
                basis.insert(m.target.to_owned());
            }
        }

        let mut edge_signatures = vec![];

        for (i, p) in momenta.iter().enumerate() {
            let mut coef = None;
            let mut signature = vec![];
            for (j, b) in basis.iter().enumerate() {
                let coef_atom = p.expand().coefficient(b);

                if coef_atom.is_zero() {
                } else if let AtomView::Num(n) = coef_atom.as_view() {
                    let new_coef = Q.element_from_coefficient_view(n.get_coeff_view());

                    if new_coef > Q.zero() {
                        signature.push(1i8);
                    } else {
                        signature.push(-1);
                    }
                    if let Some(c) = &coef {
                        if c != &new_coef {
                            panic!("Inconsistent coefficients");
                        }
                    } else {
                        coef = Some(new_coef.abs())
                    }
                } else {
                    panic!("should be num::{}", coef_atom)
                }
            }

            let overall_sign = signature
                .iter()
                .find(|i| **i != 0)
                .map(|i| {
                    if *i > 0 {
                        Sign::Positive
                    } else {
                        Sign::Negative
                    }
                })
                .unwrap_or(Sign::Positive);

            edge_signatures.push(LmbSignature {
                signs: Signature::from_iter(signature.into_iter().map(|i| overall_sign * i)),
                overall_sign,
                prefactor: coef.unwrap(),
            });
        }

        EdgeSignatures {
            edge_signatures,
            basis: basis.into_iter().collect(),
        }
    }
}

impl Topology {
    pub fn new(mut denom: DenominatorDis) -> Self {
        let momenta = denom
            .props
            .keys()
            .map(|p| p.momentum.clone())
            .collect::<Vec<_>>();
        let signatures = EdgeSignatures::from_momenta(&momenta);

        let mut unique_signatures = IndexMap::new();

        let mut ext_signature = None;

        let mut props = IndexMap::new();

        let mut prefactor = Atom::new_num(1);

        for (i, s) in signatures.edge_signatures.iter().enumerate().rev() {
            if ext_signature.is_none() {
                ext_signature = Some(Signature::from_iter(vec![0i8; s.signs.len()]));
            }

            let (mut p, pow) = denom.props.pop().unwrap();

            // println!("{}", p.to_atom());

            p.rescale(s.overall_sign * s.prefactor.inv());
            // println!("prefactor{}", s.prefactor);

            prefactor = prefactor / s.prefactor.pow(2);
            // println!("rescaled:{}", p.to_atom());
            props.insert(p, pow);

            // println!("signature:{}", s.signs);
            unique_signatures.entry(s.signs.clone()).or_insert(i);
        }

        let ext_signature = ext_signature.unwrap();

        let mut current_edgenum = 0;
        let mut ext_edgenum = 0;

        let mut not_seen = !BitVec::empty(props.len());

        // here we add the basic loops to satify all found lmb signatures.
        // currently we only support one loop
        let (mut skeleton, mut signature_cut) = if unique_signatures.len() == 1 {
            let (s, i) = unique_signatures.iter().next().unwrap();
            not_seen.set(*i, false);

            let (prop, pow) = props.get_index(*i).unwrap();

            // let prefactor = if *pow > 1 {
            //     fun!(DIS_SYMBOLS.internal_mom, 0).npow(1 - *pow as i32)
            // } else {
            //     Atom::new_num(1)
            // };
            let mut graph = HedgeGraphBuilder::new();
            let v = graph.add_node(());

            graph.add_edge(
                v,
                v,
                TopologyEdge {
                    edgeid: 0,
                    signature: s.clone(),
                    propagator: prop.clone(),
                    power: *pow,
                },
                false,
            );

            let graph = graph.build();

            let mut cut_map = AHashMap::new();

            for (i, c) in graph.iter_egdes(&graph.full_filter()) {
                let s = c.data.unwrap().signature.clone();
                if let EdgeId::Paired { source, sink } = i {
                    cut_map.insert(s, sink);
                }
            }

            (graph, cut_map)
        } else {
            unimplemented!()
        };

        // now we add all the internal edges
        for i in not_seen.iter_ones() {
            let signature = &signatures.edge_signatures[i];
            let (prop, pow) = props.get_index(i).unwrap();

            let hedge = signature_cut.get(&signature.signs).unwrap();

            current_edgenum += 1;
            skeleton
                .split_edge(
                    *hedge,
                    EdgeData::new(
                        TopologyEdge {
                            edgeid: current_edgenum,
                            signature: signature.signs.clone(),
                            propagator: prop.clone(),
                            power: *pow,
                        },
                        Orientation::Undirected,
                    ),
                )
                .unwrap();

            // println!("split:\n{}", skeleton.base_dot());
            let mut dot = HedgeGraphBuilder::new();
            let v = dot.add_node(());

            let e = TopologyEdge {
                edgeid: current_edgenum,
                signature: signature.signs.clone(),
                propagator: prop.clone(),
                power: *pow,
            };

            dot.add_external_edge(v, e.clone(), Orientation::Undirected, Flow::Source);

            dot.add_external_edge(v, e.clone(), Orientation::Undirected, Flow::Source);

            let dot = dot.build();

            skeleton = skeleton
                .join(
                    dot,
                    |_, b, _, v| {
                        let b = b.data.unwrap().signature.clone();
                        let v = v.data.unwrap().signature.clone();
                        // println!("join{}{}", b, v);
                        b == v && v != ext_signature
                    },
                    |f, b, _, _| (f, b),
                )
                .unwrap();

            // println!("join:\n{}", skeleton.base_dot());

            let mut new_node_hairs = AHashMap::new();
            let full = skeleton.full_filter();

            for (n, _) in skeleton.iter_node_data(&full) {
                let mut sum = Atom::new_num(0);
                for (i, d) in skeleton.iter_egdes(n) {
                    match i {
                        EdgeId::Split { split, .. } => {
                            sum = sum
                                + SignOrZero::from(split)
                                    * d.as_ref().data.unwrap().propagator.momentum.clone();
                        }
                        EdgeId::Unpaired { flow, .. } => {
                            sum = sum
                                - SignOrZero::from(flow)
                                    * d.as_ref().data.unwrap().propagator.momentum.clone();
                        }
                        _ => {}
                    }
                }

                sum = sum.expand();
                if !sum.is_zero() {
                    // println!("sum{sum}");
                    new_node_hairs.insert(skeleton.id_from_hairs(n).unwrap(), sum);
                }
            }
            for (n, h) in new_node_hairs.drain() {
                if ext_edgenum == 4 {
                    let ext = skeleton
                        .hairs_from_id(n)
                        .hairs
                        .included_iter()
                        .find(|i| skeleton.involution.is_identity(*i));

                    if let Some(e) = ext {
                        if let InvolutiveMapping::Identity { data, underlying } =
                            &mut skeleton.involution[e]
                        {
                            let d = data.take();
                            let mut current_data = d.data.unwrap();
                            let o = d.orientation;

                            let out = &current_data.propagator.momentum + h;
                            current_data.propagator.momentum = out;

                            *data = EdgeData::new(current_data, o);
                        }
                    } else {
                        skeleton = skeleton
                            .add_dangling_edge(
                                n,
                                TopologyEdge {
                                    edgeid: ext_edgenum,
                                    signature: ext_signature.clone(),
                                    propagator: Prop {
                                        mass: None,
                                        momentum: h,
                                    },
                                    power: 1,
                                },
                                Flow::Source,
                            )
                            .unwrap()
                            .1;
                    }
                } else {
                    skeleton = skeleton
                        .add_dangling_edge(
                            n,
                            TopologyEdge {
                                edgeid: ext_edgenum,
                                signature: ext_signature.clone(),
                                propagator: Prop {
                                    mass: None,
                                    momentum: h,
                                },
                                power: 1,
                            },
                            Flow::Source,
                        )
                        .unwrap()
                        .1;
                }
                ext_edgenum += 1;
            }
        }

        return Topology {
            graph: skeleton,
            prefactor,
        };
    }
}

#[derive(Clone, PartialEq, Eq, Debug)]
pub struct DenominatorDis {
    props: IndexMap<Prop, u8>,
    prefactor: Atom,
}

impl DenominatorDis {
    pub fn topology(&self) -> Topology {
        Topology::new(self.clone())
    }

    pub fn partial_fraction(&self) -> Vec<DenominatorDis> {
        let mut props = self.props.clone();

        let mut sum = Atom::new_num(0);
        let mut vars = vec![];

        for (i, (p, _)) in self.props.iter().enumerate() {
            vars.push(fun!(symb!("alpha"), i as i32));
            sum = sum + p.to_expression() * vars.last().unwrap();
        }
        sum = sum.expand();
        let x_ = symb!("x_");
        let y_ = symb!("y_");

        let loop_mom_dot_pat =
            fun!(DIS_SYMBOLS.dot, fun!(DIS_SYMBOLS.loop_mom, x_), y_).to_pattern();

        let mut iter = sum.pattern_match(&loop_mom_dot_pat, None, None);

        let mut matches = AHashSet::new();
        while let Some(m) = iter.next_detailed() {
            matches.insert(m.target.to_owned());
        }
        let mut system = vec![];
        for m in &matches {
            let coef = sum.coefficient(m);
            // println!("coef:{coef}");
            system.push(coef);
        }

        let (m, b) = Atom::system_to_matrix::<u8, _, _>(&system, &vars).unwrap();
        // m.solve_any(b)
        let old_col = m.ncols() as u32;
        let mut aug = m.augment(&b).unwrap();
        aug.row_reduce(old_col) as usize;
        aug.back_substitution(old_col);

        let mut pivot = vec![];
        for r in aug.row_iter() {
            for (j, c) in r.iter().enumerate() {
                if c.is_one() {
                    pivot.push(j);
                    break;
                }
            }
        }
        for (a, &b) in pivot.iter().enumerate() {
            vars.swap(a, b);
            aug.swap_cols(a as u32, b as u32);
            props.swap_indices(a, b);
        }

        let rank = pivot.len() as u32;
        let n = (aug.ncols() - 1) as u32;
        let field = aug.field().clone();
        let mut x_mat = Matrix::new(rank, n - rank, field.clone());

        let mut b_mat = Matrix::new(rank, 1, field.clone());

        for i in 0..rank {
            for j in 0..(n - rank) {
                x_mat[(i, j)] = aug[(i, j + rank)].clone();
            }
        }

        for i in 0..rank {
            b_mat[(i, 0)] = aug[(i, n)].clone();
        }

        let mut var_indep_mat = Matrix::new(n - rank, 1, field.clone());
        if n > rank {
            var_indep_mat[(0, 0)] = field.one();
        }

        let sol = (&b_mat - &(&x_mat * &var_indep_mat))
            .into_vector()
            .into_vec();

        let mut sol_reps = vec![];
        let mut coeffs = vec![];

        let (deps, indeps) = vars.split_at(rank as usize);

        for (i, d) in deps.iter().enumerate() {
            let so = sol[i as usize].to_expression();
            coeffs.push(so.clone());
            sol_reps.push(Replacement::new(d.to_pattern(), so.to_pattern()));
        }

        let mut iter = indeps.iter();

        if let Some(i) = iter.next() {
            let so = Atom::new_num(1);
            coeffs.push(so.clone());
            sol_reps.push(Replacement::new(i.to_pattern(), so.to_pattern()));
        }

        for i in iter {
            let so = Atom::new_num(0);
            coeffs.push(so.clone());
            sol_reps.push(Replacement::new(i.to_pattern(), so.to_pattern()));
        }

        let coef = sum.replace_all_multiple(&sol_reps).expand();

        let mut denoms = vec![];

        let mut all_zero = true;
        for (i, c) in coeffs.iter().enumerate() {
            if !c.is_zero() {
                all_zero = false;
                let prefactor = &self.prefactor * c / &coef;

                let mut propsnew = IndexMap::new();
                for (j, (k, v)) in props.iter().enumerate() {
                    if i != j {
                        propsnew.insert(k.clone(), *v);
                    } else {
                        if *v > 1 {
                            propsnew.insert(k.clone(), v - 1);
                        }
                    }
                }
                denoms.push(DenominatorDis {
                    props: propsnew,
                    prefactor,
                });
            }
        }

        if all_zero {
            return vec![DenominatorDis {
                props: self.props.clone(),
                prefactor: self.prefactor.clone(),
            }];
        }

        let mut sum = self.to_expression();
        for d in &denoms {
            sum = sum - d.to_expression();
        }

        let iszero = sum
            .as_view()
            .to_rational_polynomial::<_, _, u8>(&Q, &Z, None);

        assert!(iszero.is_zero());

        let mut partials = vec![];

        for p in &denoms {
            partials.extend(p.partial_fraction());
        }

        partials
    }

    pub fn is_dotted(&self) -> bool {
        self.props.iter().any(|(_, p)| *p > 1)
    }

    pub fn to_mathematica_integrand(&self) -> Option<MathematicaIntegrand> {
        let topology = self.topology();

        None
    }

    pub fn to_atom(&self) -> Atom {
        let mut atom = self.prefactor.clone();

        for (p, n) in self.props.iter() {
            atom = atom * p.to_atom().pow(Atom::new_num(-(*n as i32)));
        }

        atom
    }

    pub fn to_expression(&self) -> Atom {
        let mut atom = self.prefactor.clone();

        for (p, n) in self.props.iter() {
            atom = atom * p.to_expression().pow(Atom::new_num(-(*n as i32)));
        }

        atom
    }

    pub fn new(prop_iter: impl IntoIterator<Item = Prop>) -> Self {
        let mut props = IndexMap::new();
        for p in prop_iter {
            // println!("p:{}", p.to_atom());
            *props.entry(p).or_insert(0) += 1;
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
    pub fn rescale(&mut self, factor: Rational) {
        self.momentum = (&self.momentum * factor).expand()
    }
    pub fn new(mass: Option<Atom>, momentum: Atom) -> Self {
        Self { mass, momentum }
    }

    pub fn map_all(&self, f: &impl Fn(&Atom) -> Atom) -> Self {
        Self {
            mass: self.mass.as_ref().map(f),
            momentum: f(&self.momentum),
        }
    }

    pub fn to_atom(&self) -> Atom {
        fun!(
            DIS_SYMBOLS.prop,
            self.mass.clone().unwrap_or(Atom::Zero),
            self.momentum.clone()
        )
    }

    pub fn to_expression(&self) -> Atom {
        fun!(
            DIS_SYMBOLS.dot,
            self.momentum.clone(),
            self.momentum.clone()
        ) - (self.mass.clone().unwrap_or(Atom::Zero)).pow(Atom::new_num(2))
    }
}

pub fn dis_cut_layout<'a>(
    cut: OrientedCut,
    graph: &'a DisGraph,
    params: LayoutParams,
    iter_params: LayoutIters,
    settings: Option<&FancySettings>,
    edge_len: f64,
) -> PositionalHedgeGraph<(&'a DisEdge, Orientation, Atom), &'a DisVertex> {
    let c = graph.emr_to_lmb_and_cut(&cut);
    // let layout_graph = graph.graph.map_edges_ref(f)

    // let file = std::fs::File::open("layout_params.json").unwrap();
    // let layout_iters = serde_yaml::from_reader::<_, LayoutIters>(file).unwrap();
    let mut pos = cut.layout(&graph.graph, params, iter_params, edge_len, &|e| {
        e.emr_momentum.replace_all_multiple(&c)
    });

    if let Some(settings) = settings {
        pos.to_fancy(settings);
        pos
    } else {
        pos
    }
}

pub fn write_layout<'a>(
    layouts: &[(
        String,
        String,
        Vec<PositionalHedgeGraph<(&'a DisEdge, Orientation, Atom), &'a DisVertex>>,
    )],
    filename: &str,
) {
    std::fs::write(
        filename,
        PositionalHedgeGraph::cetz_impl_collection(
            &layouts,
            &|(_, o, a)| {
                format!(
                    "{}",
                    (SignOrZero::from(*o) * a.expand())
                        .expand()
                        .printer(symbolica::printer::PrintOptions::mathematica())
                )
            },
            &|(e, _, _)| e.decoration(),
        ),
    )
    .unwrap();
}
