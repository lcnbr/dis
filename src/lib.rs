use std::{
    collections::BTreeMap,
    fmt::{format, Display},
    fs::File,
    io::Write,
    ops::Neg,
    path::Path,
    str::FromStr,
    sync::{Arc, LazyLock},
};

use gamma::Gamma;
// use libc::GS;
use linnet::{
    dot_parser::{DotEdgeData, DotVertexData},
    half_edge::{
        builder::HedgeGraphBuilder,
        drawing::Decoration,
        involution::{EdgeData, EdgeIndex, Flow, Hedge, HedgePair, Orientation},
        layout::{FancySettings, LayoutIters, LayoutParams, LayoutSettings, PositionalHedgeGraph},
        nodestorage::NodeStorageOps,
        subgraph::{cut::PossiblyCutEdge, Inclusion, OrientedCut, SubGraph, SubGraphOps},
        EdgeAccessors, HedgeGraph, NodeIndex,
    },
};

use _gammaloop::{
    graph::{BareGraph, Edge, EdgeType, HedgeGraphExt as GlHedgeGraphExt, Vertex, VertexInfo},
    model::{normalise_complex, Model},
    momentum::{Sign, SignOrZero, Signature},
    numerator::{AppliedFeynmanRule, GlobalPrefactor, Numerator, UnInit},
    utils::GS,
};
use ahash::{AHashMap, AHashSet};
use bitvec::vec::BitVec;
use cgmath::{Angle, Rad};
use indexmap::{IndexMap, IndexSet};
use indicatif::ProgressBar;
use itertools::Itertools;
use linnet::permutation::{HedgeGraphExt, Permutation, PermutationError};
use log::debug;
use smartstring::SmartString;
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
        rational::{Rational, Q},
        rational_polynomial::{RationalPolynomial, RationalPolynomialField},
        Ring, SelfRing,
    },
    function,
    id::Replacement,
    poly::{PositiveExponent, Variable},
    symb,
    tensors::matrix::Matrix,
};

use linnet::permutation::PermutationExt;

pub mod gamma;

#[derive(Clone, Debug, Hash, PartialEq, Eq, PartialOrd, Ord)]
pub struct MySignedCycle {
    pub filter: BitVec,
    pub loop_count: Option<usize>,
}

impl MySignedCycle {
    pub fn from_cycle<N, E>(
        cycle: linnet::half_edge::subgraph::Cycle,
        according_to: Hedge,
        graph: &HedgeGraph<N, E>,
    ) -> Option<Self> {
        if !cycle.is_circuit(graph) {
            return None;
        }

        if !cycle.filter.includes(&according_to) {
            return None;
        }

        let mut filter: BitVec = graph.empty_subgraph();

        let mut current_hedge = according_to;

        loop {
            if filter.includes(&current_hedge) {
                break;
            }
            filter.set(current_hedge.0, true);

            current_hedge = graph.inv(
                graph
                    .hairs_from_id(graph.node_id(current_hedge))
                    .hairs
                    .included_iter()
                    .find(|h| cycle.filter.includes(h) && (*h != current_hedge))?,
            );
        }

        Some(MySignedCycle {
            filter,
            loop_count: cycle.loop_count,
        })
    }
}

#[derive(Debug, Clone, Eq, PartialEq)]
pub struct Embeddings {
    pub cuts: BTreeMap<Embedding, Vec<(OrientedCut, usize)>>,
    pub bases: Vec<Vec<MySignedCycle>>,
}

#[derive(Debug, Clone, Eq, PartialEq, Hash, PartialOrd, Ord)]
pub struct Embedding {
    // pub basid: usize,
    pub windings: Vec<i32>,
}

pub struct IFCuts {
    pub cuts: BTreeMap<Embedding, (usize, [Vec<OrientedCut>; 2])>,
    pub basis: Vec<Vec<MySignedCycle>>,
}

#[derive(Debug, Clone, Eq, PartialEq, Hash, PartialOrd, Ord, Copy)]
pub enum DisCompVertex {
    Internal,
    Left(EdgeIndex),
    Right(EdgeIndex),
}

impl From<DisCompVertex> for DotVertexData {
    fn from(pdg: DisCompVertex) -> Self {
        let mut vertex = DotVertexData::empty();
        match pdg {
            DisCompVertex::Internal => vertex.add_statement("node_type", "i"),
            DisCompVertex::Left(i) => {
                vertex.add_statement("node_type", "left");
                let i: usize = i.into();
                vertex.add_statement("edge_id", i);
            }
            DisCompVertex::Right(i) => {
                vertex.add_statement("node_type", "right");
                let i: usize = i.into();
                vertex.add_statement("edge_id", i);
            }
        };
        vertex
    }
}

impl TryFrom<DotVertexData> for DisCompVertex {
    type Error = String;
    fn try_from(dot_edge_data: DotVertexData) -> Result<Self, Self::Error> {
        let node_type: String = dot_edge_data
            .get("node_type")
            .ok_or("Missing 'node_type' attribute")?
            .unwrap();
        match node_type.as_str() {
            "left" => {
                let edge_id: usize = dot_edge_data
                    .get("edge_id")
                    .ok_or("Missing 'edge_id' attribute for left node_type")?
                    .map_err(|a| "Cannot parse")?;

                Ok(DisCompVertex::Left(edge_id.into()))
            }
            "right" => {
                let edge_id: usize = dot_edge_data
                    .get("edge_id")
                    .ok_or("Missing 'edge_id' attribute for right node_type")?
                    .map_err(|a| "Cannot parse")?;

                Ok(DisCompVertex::Right(edge_id.into()))
            }
            "i" => Ok(DisCompVertex::Internal),
            _ => Err("Invalid 'node_type' value".to_string()),
        }
    }
}

impl DisCompVertex {
    pub fn from_bare(graph: &BareGraph, vertex_id: usize) -> Self {
        match &graph.vertices[vertex_id].vertex_info {
            VertexInfo::ExternalVertexInfo(a) => {
                let ext_id = graph
                    .external_connections
                    .iter()
                    .find_map(|o| {
                        if let (Some(i), Some(f)) = o {
                            if i == &vertex_id || f == &vertex_id {
                                Some(*i)
                            } else {
                                None
                            }
                        } else {
                            None
                        }
                    })
                    .unwrap_or(vertex_id);

                // println!("{}{}{}", a.direction, a.particle.name, a.particle.pdg_code);
                match a.direction {
                    EdgeType::Incoming => DisCompVertex::Left(EdgeIndex::from(ext_id)),
                    EdgeType::Outgoing => DisCompVertex::Right(EdgeIndex::from(ext_id)),
                    _ => panic!("Invalid edgetype"),
                }
            }
            VertexInfo::InteractonVertexInfo(_) => DisCompVertex::Internal,
        }
    }
}

impl Display for DisCompVertex {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            DisCompVertex::Internal => write!(f, "i"),
            DisCompVertex::Left(edgeid) => write!(f, "l{}", edgeid),
            DisCompVertex::Right(edgeid) => write!(f, "r{}", edgeid),
        }
    }
}

#[derive(Debug, Clone, PartialEq, PartialOrd, Ord, Hash, Eq)]
pub struct CutEdge<Data> {
    data: Data,
    cut: Orientation,
}

// impl<Data: Ord> Ord for CutEdge<Data> {
//     fn cmp(&self, other: &Self) -> std::cmp::Ordering {
//         self.data.cmp(&other.data)
//     }
// }

// impl<Data: PartialOrd> PartialOrd for CutEdge<Data> {
//     fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
//         self.data.partial_cmp(&other.data)
//     }
// }

// impl<Data: std::hash::Hash> std::hash::Hash for CutEdge<Data> {
//     fn hash<H: std::hash::Hasher>(&self, state: &mut H) {
//         self.data.hash(state);
//     }
// }

// impl<Data: PartialEq> PartialEq for CutEdge<Data> {
//     fn eq(&self, other: &Self) -> bool {
//         self.data.eq(&other.data)
//     }
// }

impl<Data: Display> Display for CutEdge<Data> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self.cut {
            Orientation::Undirected => write!(f, "-{}", self.data),
            Orientation::Default => write!(f, ">{}", self.data),
            Orientation::Reversed => write!(f, "<{}", self.data),
        }
    }
}

impl<Data> CutEdge<Data> {
    pub fn from_comp_vertex(data: Data, cut: DisCompVertex) -> Self {
        let cut = match cut {
            DisCompVertex::Internal => Orientation::Undirected,
            DisCompVertex::Left(_) => Orientation::Default,
            DisCompVertex::Right(_) => Orientation::Reversed,
        };
        CutEdge { data, cut }
    }
}

#[derive(Debug, Copy, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
pub struct Pdg {
    pub pdg: isize,
}

impl Display for Pdg {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "pdgid:{}", self.pdg)
    }
}

impl From<Pdg> for DotEdgeData {
    fn from(pdg: Pdg) -> Self {
        let mut statements = BTreeMap::new();
        statements.insert("pdg".to_owned(), pdg.pdg.to_string());
        DotEdgeData { statements }
    }
}

impl TryFrom<DotEdgeData> for Pdg {
    type Error = String;
    fn try_from(dot_edge_data: DotEdgeData) -> Result<Self, Self::Error> {
        let pdg = dot_edge_data
            .statements
            .get("pdg")
            .ok_or("Missing 'pdg' attribute")?;
        let pdg = pdg.parse().map_err(|_| "Invalid 'pdg' value".to_string())?;
        Ok(Pdg { pdg })
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct DisCutGraph {
    pub graph: HedgeGraph<PossiblyCutEdge<Pdg>, DisCompVertex>,
    // signature: BTreeSet<(isize, Orientation, EdgeIndex)>,
}

impl Display for DisCutGraph {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let out = self.graph.dot_impl(
            &self.graph.full_filter(),
            "",
            &|d| {
                let serialized_data = DotEdgeData::from(d.clone());
                let label = match d.flow() {
                    None => d.edge_data().pdg.to_string(),
                    Some(Flow::Source) => format!("\"Left:{}:{}\"", d.edge_data().pdg, d.index),
                    Some(Flow::Sink) => format!("\"Right:{}:{}\"", d.edge_data().pdg, d.index),
                };

                Some(format!("{serialized_data}label={label}"))
            },
            &|d| {
                let sd = DotVertexData::from(d.clone());

                Some(format!("{sd}"))
            },
        );

        write!(f, "{}", out)
    }
}

pub struct VacuumGraph {
    pub graph: HedgeGraph<PossiblyCutEdge<Pdg>, DisCompVertex>,
}

impl Display for VacuumGraph {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let out = self.graph.dot_impl(
            &self.graph.full_filter(),
            "",
            &|d| {
                let serialized_data = DotEdgeData::from(d.clone());
                let label = match d.flow() {
                    None => d.edge_data().pdg.to_string(),
                    Some(Flow::Source) => format!("\"Left{}\"", d.edge_data().pdg),
                    Some(Flow::Sink) => format!("\"Right{}\"", d.edge_data().pdg),
                };

                Some(format!("{serialized_data}label={label}"))
            },
            &|d| {
                let sd = DotVertexData::from(d.clone());

                Some(format!("{sd}"))
            },
        );

        write!(f, "{}", out)
    }
}

impl VacuumGraph {
    pub fn cut(mut self) -> DisCutGraph {
        // -> HedgeGraph<isize, DisCompVertex> {
        self.graph.split_copy();
        DisCutGraph { graph: self.graph }
    }

    pub fn canonize(mut self) -> Self {
        let cut = self.graph.cut();

        for l in cut.iter_left_hedges() {
            let orientation = self.graph.orientation(l);
            let flow = self.graph.flow(l);

            match orientation {
                Orientation::Reversed => {
                    match flow {
                        Flow::Source => self.graph.set_flow(l, Flow::Sink),
                        Flow::Sink => self.graph.set_flow(l, Flow::Source),
                    }
                    self.graph[[&l]].reverse_mut()
                }
                Orientation::Undirected => {
                    if let Flow::Sink = flow {
                        self.graph.set_flow(l, Flow::Source);
                        self.graph[[&l]].reverse_mut();
                    }
                    self.graph.set_orientation(l, Orientation::Default);
                }
                _ => {}
            }
        }

        let sym = <HedgeGraph<_, _> as GlHedgeGraphExt<_, _>>::to_sym(&self.graph)
            .unwrap()
            .canonize()
            .graph;

        let h = <HedgeGraph<_, _> as GlHedgeGraphExt<_, _>>::from_sym(sym)
            .map(|_, _, _, v| *v, |_, _, _, v| v.map(|d| d.clone()));

        // println!(
        //     "//MappedSewed graph\n{}",
        //     h.dot_impl(
        //         &h.full_filter(),
        //         "",
        //         &|a| Some(format!("label=\"{}:{:?}\"", a.data, a.cut)),
        //         &|a| { Some(format!("label=\"{a}\"")) }
        //     )
        // );

        Self { graph: h }
    }
}

impl DisCutGraph {
    pub fn electron_disconnects(&self) -> bool {
        let cut = self.graph.cut();
        let mut complement = cut.left.complement(&self.graph);

        for i in self.graph.full_filter().included_iter() {
            if self.graph.get_edge_data(i).edge_data().pdg.abs() == 11 {
                complement.set(i.0, false);
            }
        }
        !self.graph.is_connected(&complement)
    }
    /// Only on cut graphs
    pub fn only_default_orientations(&mut self) {
        let cut = self.graph.cut();

        for l in cut.iter_left_hedges() {
            let orientation = self.graph.orientation(l);
            let flow = self.graph.flow(l);

            match orientation {
                Orientation::Reversed => match flow {
                    Flow::Source => self.graph.set_flow(l, Flow::Sink),
                    Flow::Sink => self.graph.set_flow(l, Flow::Source),
                },
                Orientation::Undirected => {
                    if let Flow::Sink = flow {
                        self.graph.set_flow(l, Flow::Source);
                        self.graph[[&l]].cut(Flow::Source);
                    }
                    self.graph.set_orientation(l, Orientation::Default);
                }
                _ => {}
            }
        }

        for l in cut.iter_right_hedges() {
            let orientation = self.graph.orientation(l);
            let flow = self.graph.flow(l);

            match orientation {
                Orientation::Reversed => match flow {
                    Flow::Source => self.graph.set_flow(l, Flow::Sink),
                    Flow::Sink => self.graph.set_flow(l, Flow::Source),
                },
                Orientation::Undirected => {
                    if let Flow::Sink = flow {
                        self.graph.set_flow(l, Flow::Source);
                        self.graph[[&l]].cut(Flow::Source);
                    }
                    self.graph.set_orientation(l, Orientation::Default);
                }
                _ => {}
            }
        }
    }

    pub fn from_bare(graph: &BareGraph) -> Self {
        let mut pointer_graph = graph.hedge_representation.clone();
        pointer_graph.align_underlying_to_superficial();

        let mut newh = pointer_graph.map_data_ref(
            &|_, v, _| DisCompVertex::from_bare(graph, *v),
            &|g, id, pair, e| {
                let o = e.orientation;
                let p = &graph.edges[*e.data].particle;
                let pdg = Pdg {
                    pdg: p.pdg_code.abs(),
                };
                let newo = if p.spin == 2 {
                    if p.pdg_code < 0 {
                        o.reverse()
                    } else {
                        o
                    }
                } else {
                    Orientation::Undirected
                };
                let edgedata = if let HedgePair::Paired { source, sink } = pair {
                    let src = g.node_id(source);
                    let sk = g.node_id(sink);

                    let source_node = DisCompVertex::from_bare(graph, g[src]);
                    let sink_node = DisCompVertex::from_bare(graph, g[sk]);

                    match (source_node, sink_node) {
                        (DisCompVertex::Left(z), _) => {
                            let mut edge = PossiblyCutEdge::uncut(pdg, z);
                            edge.cut(Flow::Sink);
                            edge
                        }
                        (DisCompVertex::Right(z), _) => {
                            let mut edge = PossiblyCutEdge::uncut(pdg, z);
                            edge.cut(Flow::Source);
                            edge
                        }
                        (_, DisCompVertex::Left(z)) => {
                            let mut edge = PossiblyCutEdge::uncut(pdg, z);
                            edge.cut(Flow::Sink);
                            edge
                        }
                        (_, DisCompVertex::Right(z)) => {
                            let mut edge = PossiblyCutEdge::uncut(pdg, z);
                            edge.cut(Flow::Source);
                            edge
                        }
                        _ => PossiblyCutEdge::uncut(pdg, id),
                    }
                } else {
                    PossiblyCutEdge::uncut(pdg, id)
                };

                EdgeData::new(edgedata, newo)
            },
        );

        // println!(
        //     "//from_map\n{}",
        //     newh.dot_impl(
        //         &newh.full_filter(),
        //         "",
        //         &|d| {
        //             let serialized_data = DotEdgeData::from(d.clone());
        //             let label = match d.flow() {
        //                 None => d.edge_data().pdg.to_string(),
        //                 Some(Flow::Source) => format!("\"Left{}\"", d.edge_data().pdg),
        //                 Some(Flow::Sink) => format!("\"Right{}\"", d.edge_data().pdg),
        //             };

        //             Some(format!("{serialized_data}label={label}"))
        //         },
        //         &|d| {
        //             let sd = DotVertexData::from(d.clone());

        //             Some(format!("{sd}label={}", d))
        //         },
        //     )
        // );

        newh.align_underlying_to_superficial();

        // println!(
        //     "//aligned\n{}",
        //     newh.dot_impl(
        //         &newh.full_filter(),
        //         "",
        //         &|d| {
        //             let serialized_data = DotEdgeData::from(d.clone());
        //             let label = match d.flow() {
        //                 None => d.edge_data().pdg.to_string(),
        //                 Some(Flow::Source) => format!("\"Left{}\"", d.edge_data().pdg),
        //                 Some(Flow::Sink) => format!("\"Right{}\"", d.edge_data().pdg),
        //             };

        //             Some(format!("{serialized_data}label={label}"))
        //         },
        //         &|d| {
        //             let sd = DotVertexData::from(d.clone());

        //             Some(format!("{sd}label={}", d))
        //         },
        //     )
        // );

        let mut excised: BitVec = newh.empty_subgraph();

        for (n, d) in newh.iter_nodes() {
            if !matches!(d, DisCompVertex::Internal) {
                excised.union_with(&n.hairs)
            }
        }

        excised = excised.complement(&newh);

        // Turn the subgraph into an actual graph
        let mut excised = newh
            .concretize(&excised)
            .map(|_, _, _, d| *d, |_, b, d, e| e.map(|d| d.clone()));

        // println!(
        //     "//excised\n{}",
        //     excised.dot_impl(
        //         &excised.full_filter(),
        //         "",
        //         &|d| {
        //             let serialized_data = DotEdgeData::from(d.clone());
        //             let label = match d.flow() {
        //                 None => d.edge_data().pdg.to_string(),
        //                 Some(Flow::Source) => format!("\"Left{}\"", d.edge_data().pdg),
        //                 Some(Flow::Sink) => format!("\"Right{}\"", d.edge_data().pdg),
        //             };

        //             Some(format!("{serialized_data}label={label}"))
        //         },
        //         &|d| {
        //             let sd = DotVertexData::from(d.clone());

        //             Some(format!("{sd}label={}", d))
        //         },
        //     )
        // );

        excised.align_underlying_to_superficial();

        Self { graph: excised }
    }

    pub fn canonize(self) -> Self {
        let i = self.canonize_impl();
        let j = i.clone().canonize_impl();
        similar_asserts::assert_eq!(i, j, "{}\n//not equal to {}", i, j);
        i
    }

    fn canonize_impl(mut self) -> Self {
        let nodes = self.graph.nodes(&self.graph.full_filter());

        // Iterate over external nodes, and if they are undirected (e.g. gluons), orient them,
        // outgoing for left vertices
        // incoming for right vertices
        // for n in nodes {
        //     match self.graph[n] {
        //         DisCompVertex::Left(_) => {
        //             let hair = self.graph[&n].hairs.included_iter().next().unwrap();
        //             let o = self.graph.orientation(hair);
        //             let flow = self.graph.flow(hair);
        //             if matches!(o, Orientation::Undirected) {
        //                 // println!("Hiiiii");
        //                 let newo = match flow {
        //                     Flow::Source => Orientation::Default,
        //                     Flow::Sink => Orientation::Reversed,
        //                 };

        //                 self.graph.set_orientation(hair, newo)
        //             }
        //         }
        //         DisCompVertex::Right(_) => {
        //             let hair = self.graph[&n].hairs.included_iter().next().unwrap();
        //             let o = self.graph.orientation(hair);
        //             let flow = self.graph.flow(hair);
        //             if matches!(o, Orientation::Undirected) {
        //                 // println!("Helloww");
        //                 let newo = match flow {
        //                     Flow::Source => Orientation::Reversed,
        //                     Flow::Sink => Orientation::Default,
        //                 };

        //                 self.graph.set_orientation(hair, newo)
        //             }
        //         }
        //         _ => {}
        //     }
        // }

        // println!("//arrows on non-fermions\n{self}");
        // Now all external edges on non fermions should be all outgoing for left vertices
        // and incoming for right vertices
        self.graph.align_underlying_to_superficial();

        // println!("//aligned to arrows\n{self}");
        let vac = self.to_marked_vacuum().canonize();

        // Now cut again:
        vac.cut()
    }

    pub fn to_marked_vacuum(mut self) -> VacuumGraph {
        self.graph.glue_back();
        VacuumGraph { graph: self.graph }
    }
}

impl IFCuts {
    // pub fn vertex_rule_

    pub fn collect_all_cuts<'a>(&'a self, dis_graph: &'a DisGraph) -> Vec<DisCutGraph> {
        self.cuts
            .iter()
            .flat_map(|(_, c)| {
                c.1[0]
                    .iter()
                    .map(|c| {
                        let mut graph = c.clone().to_owned_graph_ref(&dis_graph.graph).map(
                            |_, _, _, _| DisCompVertex::Internal,
                            |_, _, _, e| {
                                e.map(|(e)| {
                                    e.map(|e| {
                                        (Pdg {
                                            pdg: e.bare_edge.particle.pdg_code,
                                        })
                                    })
                                })
                            },
                        );

                        graph.align_underlying_to_superficial();

                        DisCutGraph { graph }
                    })
                    .chain(c.1[1].iter().map(|c| {
                        let mut graph = c.clone().to_owned_graph_ref(&dis_graph.graph).map(
                            |_, _, _, _| DisCompVertex::Internal,
                            |_, _, _, e| {
                                e.map(|(e)| {
                                    e.map(|e| {
                                        (Pdg {
                                            pdg: e.bare_edge.particle.pdg_code,
                                        })
                                    })
                                })
                            },
                        );

                        graph.align_underlying_to_superficial();

                        DisCutGraph { graph }
                    }))
                    .collect_vec()
            })
            .collect()
    }

    pub fn to_typst(&self, dis_graph: &DisGraph, filename: &str) -> std::io::Result<()> {
        let file = std::fs::File::open("fancy_settings.json").unwrap();
        let fancy_settings = serde_json::from_reader::<_, FancySettings>(file).unwrap();

        let file = std::fs::File::open("layout_params.json").unwrap();
        let params = serde_json::from_reader::<_, LayoutParams>(file).unwrap();

        let file = std::fs::File::open("layout_iters.json").unwrap();
        let layout_iters = serde_yaml::from_reader::<_, LayoutIters>(file).unwrap();
        let mut layouts: Vec<_> = Vec::new();

        let number_of_layouts = self
            .cuts
            .iter()
            .map(|a| a.1 .1[0].len() + a.1 .1[1].len())
            .fold(0, |acc, a| acc + a as u64);

        let bar = ProgressBar::new(number_of_layouts);

        for (i, (e, cuts)) in self.cuts.iter().enumerate() {
            let first_initial = cuts.1[0].get(0);
            let first_final = cuts.1[1].get(0);
            let denom_init = first_initial.map(|cut| dis_graph.denominator(cut));
            let denom_final = first_final.map(|cut| dis_graph.denominator(cut));
            let denoms = denom_init.as_ref().map(DenominatorDis::partial_fraction);

            let mut sum = Atom::new_num(0);
            if let Some(ds) = &denoms {
                for d in ds {
                    sum = sum + d.to_atom();
                }
            }

            let layout_emb_i: Vec<_> = cuts.1[0]
                .iter()
                .map(|c| {
                    let l = dis_cut_layout(
                        c.clone(),
                        &dis_graph,
                        params,
                        layout_iters,
                        Some(&fancy_settings),
                        20.,
                    );
                    bar.inc(1);
                    (format!("{}", c.to_string()), l)
                })
                .collect();

            let layout_emb_f = cuts.1[1]
                .iter()
                .map(|c| {
                    let l = dis_cut_layout(c.clone(), &dis_graph, params, layout_iters, None, 20.);
                    bar.inc(1);
                    (format!("{}", c.to_string()), l)
                })
                .collect();

            layouts.push((
                format!("embedding{}i", i + 1),
                format!(
                    "= embedding {} {:?} with multiplicity {}\n == initial\nDenominator:\n```mathematica\n{}\n```Partial Fractioned Denominator:\n```mathematica\n{}\n```",
                    i + 1,
                    e.windings,
                    cuts.0,
                    denom_init.as_ref().map(DenominatorDis::to_atom).unwrap_or(Atom::new_num(0))
                        .printer(symbolica::printer::PrintOptions::mathematica()),
                    sum.printer(symbolica::printer::PrintOptions {
                        pretty_matrix:true,
                        terms_on_new_line: true,
                        color_top_level_sum: false,
                        color_builtin_symbols: false,
                        print_finite_field: true,
                        symmetric_representation_for_finite_field: false,
                        explicit_rational_polynomial: false,
                        number_thousands_separator: None,
                        multiplication_operator: ' ',
                        double_star_for_exponentiation: false,
                        square_brackets_for_function: true,
                        num_exp_as_superscript: false,
                        latex: false,
                        precision: None,
                    })
                ),
                layout_emb_i,
            ));

            layouts.push((
                format!("embedding{}f", i + 1),
                format!(
                    "== final\nDenominator: \n```mathematica\n{}\n```",
                    denom_final
                        .as_ref()
                        .map(DenominatorDis::to_atom)
                        .unwrap_or(Atom::new_num(0))
                        .printer(symbolica::printer::PrintOptions::mathematica()),
                ),
                layout_emb_f,
            ));
        }
        bar.finish();
        write_layout(&layouts, filename)
    }

    pub fn remove_empty(&mut self) {
        self.cuts
            .retain(|_, v| !v.1[0].is_empty() & !v.1[1].is_empty());
    }

    pub fn to_other_mathematica_file(
        &self,
        graph: &DisGraph,
        filename: &str,
    ) -> std::io::Result<()> {
        let mut embeddings = vec![];

        for (e, cuts) in self.cuts.iter() {
            let mut map = AHashMap::new();
            let first_initial = &cuts.1[0].first().unwrap_or_else(|| {
                cuts.1[1].first().expect(&format!(
                    "No initial or final for {:?}: {:?}",
                    e.windings, cuts
                ))
            });
            map.insert("embedding".to_string(), e.windings.to_math_with_indent(4));
            let denom = graph.denominator(&first_initial);

            let numers: AHashMap<_, _> = graph.numerator(&first_initial);
            // for n in &numers {
            //     println!(":{n}");
            // }

            map.insert(
                "Cut content".to_string(),
                graph.cut_content(&first_initial).to_string(),
            );
            map.insert(
                "Denominator".to_string(),
                denom.to_atom().to_math_with_indent(4),
            );

            let denoms = denom
                .partial_fraction()
                .into_iter()
                .map(|a| a.to_atom())
                .collect_vec();

            map.insert(
                "Partial_fraction".to_string(),
                denoms.to_math_with_indent(4),
            );
            map.insert("Numerator".to_string(), numers.to_math_with_indent(4));

            embeddings.push(map);
        }

        let path = std::path::Path::new(filename);
        let prefix = path.parent().unwrap();
        std::fs::create_dir_all(prefix).unwrap();
        let mut f = File::create(path)?;
        // println!(
        //     "writing mathematica to {:?}",
        //     path.canonicalize()?.into_os_string()
        // );
        write!(f, "{}", embeddings.to_math_with_indent(0))?;
        Ok(())
    }

    pub fn to_mathematica_file(&self, graph: &DisGraph, filename: &str) -> std::io::Result<()> {
        let mut embeddings = vec![];

        for (e, cuts) in self.cuts.iter() {
            let mut map = AHashMap::new();
            let first_initial = &cuts.1[0][0];
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
                let mut ids = AHashSet::new();
                for (cut, i) in v {
                    ids.insert(i);
                    if i == 0 {
                        let mut is_in = false;
                        for (_, e) in cut.iter_edges(graph) {
                            if filter(e.as_ref().data) {
                                is_in = true;
                            }
                        }

                        if is_in {
                            split[0].push(cut);
                        } else {
                            split[1].push(cut);
                        }
                    }
                }

                (k, (ids.len(), split))
            })
            .collect();

        IFCuts {
            cuts,
            basis: self.bases,
        }
    }

    pub fn winding(cut: &OrientedCut, cycle: &MySignedCycle, graph: &DisGraph) -> i32 {
        let mut winding_number = 0;
        // println!("cycle: {:?}", cycle);
        for h in cycle.filter.included_iter() {
            let a = SignOrZero::from(cut.relative_orientation(h)) * 1;
            winding_number -= a;
            let b = SignOrZero::from(cut.relative_orientation(graph.graph.inv(h))) * 1;
            // println!("a: {}, b: {}", a, b);
            winding_number += b;
        }
        winding_number
    }

    pub fn classify(
        graph: &DisGraph,
        iter: impl IntoIterator<Item = OrientedCut>,
        bases: Vec<Vec<MySignedCycle>>,
        filter: impl Fn(&OrientedCut) -> bool,
        flip_sym: bool,
    ) -> Embeddings {
        let mut cuts = BTreeMap::new();
        let mut len = 0;

        for cut in iter {
            let mut windings = Vec::new();
            let mut basid = 0;
            if !filter(&cut) {
                continue;
            }
            len += 1;
            for (i, bs) in bases.iter().enumerate() {
                let mut first_non_zero = None;
                let mut new_windings = Vec::with_capacity(windings.len());

                for b in bs {
                    let mut winding_number = Self::winding(&cut, b, graph);
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
                    new_windings.push(winding_number);
                }

                if new_windings <= windings || windings.is_empty() {
                    windings = new_windings;
                    basid = i;
                }
            }
            cuts.entry(Embedding { windings })
                .or_insert_with(Vec::new)
                .push((cut, basid));
        }

        println!("{} embeddings from {} cuts", cuts.keys().len(), len);
        Embeddings { cuts, bases }
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
    dim: symb!("d"),
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
                // println!("colorless vertex {}: {}", v.bare_vertex_id, a[0]);
                // println!("colored vertex {}:{}", v.bare_vertex_id, a[1]);
                vatoms.push(a);
            }
        }

        let mut eatoms: Vec<_> = vec![];
        let i = Atom::new_var(Atom::I);
        for (j, p, e) in graph.iter_edges(subgraph) {
            // println!("emr:")
            let edge = &e.data.bare_edge;
            // println!("Edgeid :{edge_id}");
            // println!("EMR Id:{}", e.data.unwrap().emr_idx);
            let in_slots = edge.in_slot(bare);
            let out_slots = edge.out_slot(bare);
            eatoms.push(match j {
                HedgePair::Paired { .. } => {
                    let [n, c] = edge.color_separated_numerator(bare, e.data.emr_idx);
                    [&n * &i, c]
                }
                HedgePair::Split { split, .. } => match split {
                    Flow::Source => {
                        let [lorentz, spin, color] = in_slots.dual().kroneker(&out_slots);
                        // println!("Slit source{lorentz}{spin}{color}");

                        [lorentz * spin, color]
                    }
                    Flow::Sink => {
                        let [lorentz, spin, color] = out_slots.dual().kroneker(&in_slots);
                        // println!("Spit sink {lorentz}{spin}{color}");
                        [lorentz * spin, color]
                    }
                },
                HedgePair::Unpaired { .. } => {
                    let [n, c] = edge.color_separated_numerator(bare, e.data.emr_idx);
                    [&n * &i, c]
                }
            });
            // if matches!(j, EdgeId::Paired { .. }) {
            //     println!("n:{n}");
            //     println!("c:{c}");
            //     // eatoms.push([&n * &i, c]);
            // };
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
        // println!("from dis success");
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
            function!(ETS.metric, a_, b_).pow(Atom::new_num(2)),
            Atom::new_var(dim),
        ),
        (
            function!(emrmom, b_, a_) * function!(emrmom, c_, a_),
            function!(dot, function!(emrmom, b_), function!(emrmom, c_)),
        ),
        (
            function!(p, a_) * function!(emrmom, c_, a_),
            function!(dot, p, function!(emrmom, c_)),
        ),
        (
            function!(q, a_) * function!(emrmom, c_, a_),
            function!(dot, q, function!(emrmom, c_)),
        ),
        (function!(p, a_) * function!(p, a_), function!(dot, p, p)),
        (function!(p, a_) * function!(q, a_), function!(dot, p, q)),
        (function!(q, a_) * function!(q, a_), function!(dot, q, q)),
        (
            function!(ETS.metric, a_, b_) * function!(emrmom, c_, a_),
            function!(emrmom, c_, b_),
        ),
        (
            function!(ETS.metric, a_, b_) * function!(p, a_),
            function!(p, b_),
        ),
        (
            function!(ETS.metric, a_, b_) * function!(q, a_),
            function!(q, b_),
        ),
        (Atom::parse("ee").unwrap(), Atom::parse("eq*3").unwrap()),
        (Atom::new_var(Atom::I), Atom::parse("I").unwrap()),
        (Atom::parse("TR").unwrap(), Atom::parse("TF").unwrap()),
        // (Atom::parse("Nc^2").unwrap(), Atom::parse("TF-1").unwrap()),
    ];

    let replacements: Vec<Replacement> = reps
        .into_iter()
        .map(|(a, b)| Replacement::new(a.to_pattern(), b.to_pattern()))
        .collect();

    num.replace_all_multiple_repeat_mut(&replacements)
}
#[allow(dead_code)]
pub struct DisGraph {
    pub graph: HedgeGraph<DisEdge, DisVertex>,
    marked_electron_edge: (HedgePair, usize),
    symmetry_group: Integer,
    lmb_photon: (HedgePair, usize),
    orbit_generators: Vec<Permutation>,
    numerator: AHashMap<String, Atom>,
    denominator: DenominatorDis,
    overall_prefactor: Atom,
    bases: Vec<Vec<MySignedCycle>>,
}

impl DisGraph {
    pub fn to_typst(set: &[(usize, Self)], radius: f64, filename: &str) -> std::io::Result<()> {
        let bar = ProgressBar::new(set.len() as u64);

        let col: Vec<_> = set
            .iter()
            .map(|(i, g)| {
                let o = (
                    format!("d{i}"),
                    format!(
                        "
                            = d{i}\n overall factor: {}
                            \n symmetry group: {}",
                        g.overall_prefactor, g.symmetry_group
                    ),
                    vec![("".into(), g.draw_graph(radius, true))],
                );
                bar.inc(1);
                o
            })
            .collect();
        std::fs::write(
            filename,
            String::from_str("#set page(width: 35cm, height: auto)\n").unwrap()
                + PositionalHedgeGraph::cetz_impl_collection(
                    &col,
                    &|a| a.lmb_momentum.to_string(),
                    &|e| e.decoration(),
                    true,
                )
                .as_str(),
        )
    }

    pub fn draw_graph(&self, radius: f64, fancy: bool) -> PositionalHedgeGraph<DisEdge, DisVertex> {
        let file = std::fs::File::open("layout_params.json").unwrap();
        let params = serde_json::from_reader::<_, LayoutParams>(file).unwrap();

        let file = std::fs::File::open("layout_iters.json").unwrap();
        let layout_iters = serde_yaml::from_reader::<_, LayoutIters>(file).unwrap();

        let file = std::fs::File::open("fancy_settings.json").unwrap();
        let fancy_settings = serde_json::from_reader::<_, FancySettings>(file).unwrap();

        let settings = LayoutSettings::circle_ext(
            &self.graph,
            params,
            layout_iters,
            vec![1, 1],
            1,
            Rad::turn_div_2(),
            radius,
        );

        let mut a = self.graph.clone().layout(settings);
        if fancy {
            a.to_fancy(&fancy_settings);
        }
        a
    }

    pub fn full_dis_filter_split(&self) -> IFCuts {
        let mut i = Embeddings::classify(
            self,
            OrientedCut::all_initial_state_cuts(&self.graph),
            self.bases.clone(),
            |c| {
                let contains_electron = self
                    .graph
                    .iter_edges(c)
                    .filter(|(_, _, d)| d.data.bare_edge.particle.pdg_code.abs() == 11)
                    .count();

                let mut qcd_mult = 0;

                let alligned_electron = c.iter_edges(&self.graph).all(|(o, d)| {
                    let pdg = d.data.bare_edge.particle.pdg_code.abs();

                    match pdg {
                        21 | 1 => qcd_mult += 1,
                        _ => {}
                    }

                    if d.data.bare_edge.particle.pdg_code.abs() == 11 {
                        match (o, d.orientation) {
                            (Orientation::Default, Orientation::Default) => true,
                            (Orientation::Reversed, Orientation::Reversed) => true,
                            _ => false,
                        }
                    } else {
                        true
                    }
                });

                // println!("aligned_electron:{}", alligned_electron);
                let contains_photon = self
                    .graph
                    .iter_edges(c)
                    .any(|(_, _, d)| d.data.bare_edge.particle.pdg_code.abs() == 22);

                let mut complement = c.left.complement(&self.graph);

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
                    && 0 < qcd_mult
                    && qcd_mult < 3
                // && !electron_disconnects
            },
            true,
        )
        .if_split(&self.graph, &|e| e.marked);
        i.remove_empty();
        i
    }

    pub fn from_self_energy_bare(bare: &BareGraph, model: &Model) -> DisGraph {
        let mut builder = HedgeGraphBuilder::new();
        let mut map = AHashMap::new();

        for (i, v) in bare.vertices.iter().enumerate() {
            if matches!(v.vertex_info, VertexInfo::InteractonVertexInfo(_)) {
                map.insert(i, builder.add_node((i, v.clone())));
            }
        }

        for (i, edge) in bare.edges.iter().enumerate() {
            match edge.edge_type {
                EdgeType::Virtual => {
                    let source = map[&edge.vertices[0]];
                    let oriented = edge.particle.spin == 2;
                    let sink = map[&edge.vertices[1]];
                    builder.add_edge(source, sink, (i, edge.clone()), oriented);
                }
                EdgeType::Incoming => {
                    // let source = map[&edge.vertices[0]];
                    let sink = map[&edge.vertices[1]];
                    builder.add_external_edge(
                        sink,
                        (i, edge.clone()),
                        edge.particle.spin == 2,
                        Flow::Sink,
                    );
                }
                EdgeType::Outgoing => {
                    let source = map[&edge.vertices[0]];
                    // let sink = map[&edge.vertices[1]];
                    builder.add_external_edge(
                        source,
                        (i, edge.clone()),
                        edge.particle.spin == 2,
                        Flow::Source,
                    );
                }
            }
        }

        let h = builder.build();

        let mut outer_ring_builder = HedgeGraphBuilder::new();

        let epemavertex = model.get_vertex_rule("V_98");

        let o1 = outer_ring_builder.add_node((
            10000,
            Vertex {
                name: "or1".into(),
                vertex_info: VertexInfo::InteractonVertexInfo(
                    _gammaloop::graph::InteractionVertexInfo {
                        vertex_rule: epemavertex.clone(),
                    },
                ),
                edges: vec![],
            },
        ));
        let o2 = outer_ring_builder.add_node((
            10000,
            Vertex {
                name: "or2".into(),
                vertex_info: VertexInfo::InteractonVertexInfo(
                    _gammaloop::graph::InteractionVertexInfo {
                        vertex_rule: epemavertex.clone(),
                    },
                ),
                edges: vec![],
            },
        ));

        let e = model.get_particle_from_pdg(11);
        let prop = model.get_propagator_for_particle(&e.name);

        outer_ring_builder.add_edge(
            o1,
            o2,
            (
                10000,
                Edge {
                    name: "eo1".into(),
                    edge_type: EdgeType::Virtual,
                    propagator: prop.clone(),
                    particle: e.clone(),
                    vertices: [0, 0],
                    internal_index: vec![],
                },
            ),
            true,
        );

        outer_ring_builder.add_edge(
            o2,
            o1,
            (
                10000,
                Edge {
                    name: "eo2".into(),
                    edge_type: EdgeType::Virtual,
                    propagator: prop.clone(),
                    particle: e.clone(),
                    vertices: [0, 0],
                    internal_index: vec![],
                },
            ),
            true,
        );

        let a = model.get_particle_from_pdg(22);
        let propa = model.get_propagator_for_particle(&a.name);

        outer_ring_builder.add_external_edge(
            o1,
            (
                10000,
                Edge {
                    name: "eo3".into(),
                    edge_type: EdgeType::Virtual,
                    propagator: propa.clone(),
                    particle: a.clone(),
                    vertices: [0, 0],
                    internal_index: vec![],
                },
            ),
            false,
            Flow::Sink,
        );

        outer_ring_builder.add_external_edge(
            o2,
            (
                10000,
                Edge {
                    name: "eo4".into(),
                    edge_type: EdgeType::Virtual,
                    propagator: propa.clone(),
                    particle: a.clone(),
                    vertices: [0, 0],
                    internal_index: vec![],
                },
            ),
            false,
            Flow::Source,
        );

        let g = outer_ring_builder.build();

        let mut elec_node = None;

        if let Some((elec, _, _)) = g
            .iter_edges(&g.full_filter())
            .find(|(_, _, n)| n.data.1.particle.pdg_code.abs() == 11)
        {
            if let HedgePair::Paired { source, .. } = elec {
                elec_node = Some(g.node_id(source));
            }
        }

        let mut hedge_in_basis = None;
        let basis_start = if let Some(s) = elec_node {
            for i in g.hairs_from_id(s).hairs.included_iter() {
                if g.get_edge_data(i).1.particle.pdg_code.abs() == 11 {
                    hedge_in_basis = Some(i);
                    break;
                }
            }
            s
        } else {
            NodeIndex(0)
        };

        // println!(
        //     "{}",
        //     h.dot_impl(
        //         &h.full_filter(),
        //         "".into(),
        //         &|e| Some(format!("label=\"{}\"", e.name)),
        //         &|_| None
        //     )
        // );
        // println!(
        //     "{}",
        //     g.dot_impl(
        //         &g.full_filter(),
        //         "".into(),
        //         &|e| Some(format!("label=\"{}\"", e.name)),
        //         &|_| None
        //     )
        // );
        let h = g
            .join(
                h,
                |hf, _, gf, _| hf == -gf,
                |_, _, gf, gd| {
                    // (*hd.data.as_mut().unwrap()).edgetype = EdgeType::Virtual;
                    (gf, gd)
                },
            )
            .unwrap();

        println!("{}", h.base_dot());

        DisGraph::from_hedge(h, bare, basis_start, hedge_in_basis)
    }

    pub fn from_hedge(
        mut h: HedgeGraph<(usize, Edge), (usize, Vertex)>,
        bare: &BareGraph,
        basis_start: NodeIndex,
        hedge_in_basis: Option<Hedge>,
    ) -> DisGraph {
        // println!("finding basis");

        let (basis, tree) = h
            .paton_cycle_basis(&h.full_graph(), &basis_start, hedge_in_basis)
            .unwrap();

        // println!("aligning tree");
        h.align_underlying_to_tree(&tree);

        let signed_basis: Vec<_> = basis
            .iter()
            .map(|c| {
                let according_to = tree
                    .tree_subgraph
                    .intersection(&c.filter)
                    .included_iter()
                    .find(|i| h.underlying_hedge_orientation(*i) == Flow::Sink)
                    .unwrap();
                MySignedCycle::from_cycle(c.clone(), according_to, &h).unwrap()
            })
            .collect();

        // println!("{}", h.base_dot());
        // println!("{}", h.dot(&tree.tree));

        let mut seen_pdg22 = None;
        let mut seen_pdg11 = None;
        let lmbsymb = symb!("k");

        // let mut vertex_n = 0;

        let mut edge_n = 0;
        let graph = h.map(
            |_, _, _, (bare_vertex_id, bare_vertex)| {
                let v = DisVertex {
                    bare_vertex_id,
                    bare_vertex,
                };
                v
            },
            |_, _, e, d| {
                let mut mom_e = Atom::new_num(0);

                let mut first_cycle = None;
                let mut only_cycle = true;

                for (i, c) in basis.iter().enumerate() {
                    if let HedgePair::Paired { source, .. } = e {
                        if c.filter.includes(&source) {
                            if first_cycle.is_none() {
                                first_cycle = Some(i);
                            } else {
                                only_cycle = false;
                            }
                            mom_e = mom_e + function!(lmbsymb, i as i32)
                        }
                    }
                }
                d.map(|bare_edge| {
                    let marked = if only_cycle {
                        if let Some(i) = first_cycle {
                            match bare_edge.1.particle.pdg_code.abs() {
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

                    let emr_mom = function!(DIS_SYMBOLS.emr_mom, edge_n as i32);

                    let a = DisEdge {
                        bare_edge: bare_edge.1,
                        bare_edge_id: bare_edge.0,
                        marked,
                        lmb_momentum: mom_e,
                        emr_idx: edge_n,
                        emr_momentum: emr_mom,
                    };
                    edge_n += 1;
                    a
                })
            },
        );

        let mut outer_graph: BitVec = graph.empty_subgraph();

        for (i, _, e) in graph.iter_edges(&graph.full_filter()) {
            if let HedgePair::Paired { source, sink } = i {
                if e.data.bare_edge.particle.pdg_code.abs() == 11 {
                    outer_graph.set(source.0, true);
                    for i in graph.node_hairs(sink).included_iter() {
                        outer_graph.set(i.0, true);
                    }
                    outer_graph.set(sink.0, true);
                }
            }
        }

        let inner_graph = outer_graph.complement(&graph);

        println!(
            "//innergraph :\n{}",
            graph.dot_impl(
                &inner_graph,
                "",
                &|e| Some(format!(
                    "label=\"{}:{}\"",
                    e.bare_edge.particle.name, e.bare_edge_id
                )),
                &|v| Some(format!("label=\"{}\"", v.bare_vertex_id))
            )
        );

        let mink = Rep::new_self_dual("mink").unwrap();
        let mu = mink.new_slot(4, 0).to_atom();
        let nu = mink.new_slot(4, 1).to_atom();
        let metric = function!(ETS.metric, mu, nu);
        let p = symb!("p");
        let q = symb!("q");

        // Atom::new_var(symb!("phat")).pow(Atom::new_num(2));
        let pdq = function!(DIS_SYMBOLS.dot, p, q);
        let q2 = function!(DIS_SYMBOLS.dot, q, q);
        let phat2 = function!(DIS_SYMBOLS.dot, p, p) - &pdq * &pdq / &q2;
        let pp = (function!(p, mu) - &pdq / &q2 * function!(q, mu))
            * (function!(p, nu) - &pdq / &q2 * function!(q, nu)); // function!(p, nu);

        let diminv = Atom::new_num(1) / (Atom::new_var(GS.dim) - 2);

        // Atom::parse("1/(2-dim)").unwrap();

        let w1_proj = GlobalPrefactor {
            color: Atom::new_num(1),
            colorless: &diminv * (&metric - &pp / &phat2),
        };
        let w2_proj = GlobalPrefactor {
            color: Atom::new_num(1),
            colorless: (&pp / &phat2 - &w1_proj.colorless) / &phat2,
        };

        let F2proj = GlobalPrefactor {
            color: Atom::new_num(1),
            colorless: &pdq * &w2_proj.colorless,
        };

        let FLproj = GlobalPrefactor {
            color: Atom::new_num(1),
            colorless: &F2proj.colorless - &w1_proj.colorless * &q2 / &pdq,
        };

        let zero_proj = GlobalPrefactor {
            colorless: function!(q, mu) * function!(q, nu),
            ..GlobalPrefactor::default()
        };

        let f2 = _gammaloop::numerator::Numerator::default()
            .from_dis_graph(bare, &graph, &inner_graph, Some(&F2proj))
            .color_simplify();
        // println!("color simplified: {}", w1.get_single_atom().unwrap().0);
        // assert!(w1.validate_against_branches(1112));
        let mut f2 = f2.gamma_simplify_ddim().get_single_atom().unwrap().0;
        // println!("gamma simplified {}", w1);
        let fl = _gammaloop::numerator::Numerator::default()
            .from_dis_graph(bare, &graph, &inner_graph, Some(&FLproj))
            .color_simplify();

        // assert!(w2.validate_against_branches(1313));
        // println!("color simplified:{}", w2.state.colorless);

        let fl = fl.gamma_simplify_ddim();

        // println!("gamma simplified: {}", w2.state.colorless);

        let mut fl = fl.get_single_atom().unwrap().0;

        let zero = _gammaloop::numerator::Numerator::default()
            .from_dis_graph(bare, &graph, &inner_graph, Some(&zero_proj))
            .color_simplify();

        // assert!(zero.validate_against_branches(3234));

        let mut zero = zero.gamma_simplify_ddim().get_single_atom().unwrap().0;

        numerator_dis_apply(&mut fl);
        numerator_dis_apply(&mut f2);
        numerator_dis_apply(&mut zero);

        // for a in [&w1, &w2, &zero] {
        //     println!("before_emr_to_lmb:{}", a);
        // }

        let mut props = vec![];
        for (j, _, e) in graph.iter_edges(&inner_graph) {
            let edge = &e.data.bare_edge;
            let i = e.data.emr_idx;
            if matches!(j, HedgePair::Paired { .. }) {
                let mass = edge.particle.mass.expression.clone();
                let emr_mom = function!(DIS_SYMBOLS.emr_mom, i as i32);
                props.push(Prop::new(mass, emr_mom));
                // denominator = denominator * function!(denomsymb, mass, emr_mom);
            };
        }

        let rulepdg_graph = graph.map_data_ref(
            &|_, v, _| {
                match &v.bare_vertex.vertex_info {
                    VertexInfo::ExternalVertexInfo(e) => {
                        // match e. {

                        //     }//needs direction

                        SmartString::from(e.particle.pdg_code.to_string())
                    }
                    VertexInfo::InteractonVertexInfo(i) => {
                        // match i. {

                        //     }//needs direction
                        i.vertex_rule.name.clone()
                    }
                }
            },
            &|_, _, _, d| d.map(|d| d.bare_edge.particle.pdg_code),
        );
        let symbolica_graph: symbolica::graph::Graph<_, _> =
            <HedgeGraph<_, _> as GlHedgeGraphExt<_, _>>::to_sym(&rulepdg_graph).unwrap();

        println!("//Symbolica Graph: \n{}", symbolica_graph.to_dot());

        let canonized_graph = symbolica_graph.canonize();

        let orbit_generators = canonized_graph
            .orbit_generators
            .iter()
            .map(|a| Permutation::from_cycles(a))
            .collect::<Vec<_>>();

        println!(
            "//Orbit Generators: group of size {}\n//graph:\n{}",
            canonized_graph.automorphism_group_size,
            canonized_graph.graph.to_dot(),
        );

        let mut bases = vec![];

        let all_maps = match Permutation::generate_all(&orbit_generators) {
            Ok(a) => a,
            Err(PermutationError::EmptyGenerators) => {
                vec![Permutation::id(graph.n_nodes())]
            }
            Err(e) => panic!("Failed to generate all permutations: {}", e),
        };

        for map in &all_maps {
            let hedge_maps = graph.permute_vertices(map, &|a| a.bare_edge.particle.pdg_code);
            for hedge_map in hedge_maps {
                bases.push(Vec::from_iter(signed_basis.iter().map(|c| MySignedCycle {
                    filter: (graph.permute_subgraph(&c.filter, &hedge_map)),
                    loop_count: Some(1),
                })));
            }
        }

        println!("number of bases: {}", bases.len());
        assert_eq!(
            bases.len(),
            canonized_graph.automorphism_group_size.to_i64().unwrap() as usize
        );

        let sym_group = canonized_graph.automorphism_group_size;
        let mut numerator = AHashMap::new();
        numerator.insert("F2".into(), f2);
        numerator.insert("FL".into(), fl);
        numerator.insert("zero".into(), zero);

        DisGraph {
            graph,
            numerator,
            denominator: DenominatorDis::new(props),
            lmb_photon: seen_pdg22.unwrap(),
            marked_electron_edge: seen_pdg11.unwrap(),
            bases,
            orbit_generators,
            symmetry_group: sym_group,
            overall_prefactor: Atom::parse(&bare.overall_factor).unwrap(),
        }
    }

    // pub fn from_bare(bare: &BareGraph) -> DisGraph {
    //     let mut h = bare.hedge_representation.clone();

    //     let mut elec_node = None;

    //     if let Some((elec, _)) = h.iter_egdes(&h.full_filter()).find(|(_, n)| {
    //         bare.edges[**n.as_ref().data.unwrap()]
    //             .particle
    //             .pdg_code
    //             .abs()
    //             == 11
    //     }) {
    //         if let EdgeId::Paired { source, .. } = elec {
    //             elec_node = Some(h.node_hairs(source).clone());
    //         }
    //     }

    //     let mut included_hedge = None;
    //     let node = if let Some(s) = elec_node {
    //         for i in s.hairs.included_iter() {
    //             if bare.edges[*h.get_edge_data(i)].particle.pdg_code.abs() == 11 {
    //                 included_hedge = Some(i);
    //                 break;
    //             }
    //         }
    //         s
    //     } else {
    //         h.node_hairs(Hedge(0)).clone()
    //     };

    //     println!("finding basis");

    //     let (basis, tree) = h
    //         .paton_cycle_basis(&h.full_graph(), &node, included_hedge)
    //         .unwrap();

    //     println!("aligning tree");
    //     h.align_to_tree_underlying(&tree);

    //     println!("{}", h.base_dot());
    //     println!("{}", h.dot(&tree.tree));

    //     let mut seen_pdg22 = None;
    //     let mut seen_pdg11 = None;
    //     let lmbsymb = symb!("k");
    //     let graph = h.map(
    //         |bare_vertex_id| DisVertex {
    //             bare_vertex_id,
    //             bare_vertex: bare.vertices[bare_vertex_id].clone(),
    //         },
    //         |e, d| {
    //             let mut mom_e = Atom::new_num(0);

    //             let mut first_cycle = None;
    //             let mut only_cycle = true;

    //             for (i, c) in basis.iter().enumerate() {
    //                 if let EdgeId::Paired { source, .. } = e {
    //                     if c.filter.includes(&source) {
    //                         if first_cycle.is_none() {
    //                             first_cycle = Some(i);
    //                         } else {
    //                             only_cycle = false;
    //                         }
    //                         mom_e = mom_e + function!(lmbsymb, i as i32)
    //                     }
    //                 }
    //             }
    //             d.and_then(|bare_edge_id| {
    //                 let bare_edge = bare.edges[bare_edge_id].clone();

    //                 let marked = if only_cycle {
    //                     if let Some(i) = first_cycle {
    //                         match bare_edge.particle.pdg_code.abs() {
    //                             11 => {
    //                                 if seen_pdg11.is_some() {
    //                                     false
    //                                 } else {
    //                                     seen_pdg11 = Some((e, i));
    //                                     true
    //                                 }
    //                             }
    //                             22 => {
    //                                 if seen_pdg22.is_some() {
    //                                     false
    //                                 } else {
    //                                     seen_pdg22 = Some((e, i));
    //                                     true
    //                                 }
    //                             }
    //                             _ => false,
    //                         }
    //                     } else {
    //                         false
    //                     }
    //                 } else {
    //                     false
    //                 };

    //                 let emr_mom = function!(DIS_SYMBOLS.emr_mom, bare_edge_id as i32);

    //                 Some(DisEdge {
    //                     bare_edge,
    //                     bare_edge_id,
    //                     marked,
    //                     lmb_momentum: mom_e,
    //                     emr_momentum: emr_mom,
    //                 })
    //             })
    //         },
    //     );

    //     let mut outer_graph = graph.empty_filter();

    //     for (i, e) in graph.iter_egdes(&graph.full_filter()) {
    //         if let EdgeId::Paired { source, sink } = i {
    //             if e.data.as_ref().unwrap().bare_edge.particle.pdg_code.abs() == 11 {
    //                 outer_graph.set(source.0, true);
    //                 for i in graph.node_hairs(sink).included_iter() {
    //                     outer_graph.set(i.0, true);
    //                 }
    //                 outer_graph.set(sink.0, true);
    //             }
    //         }
    //     }

    //     let inner_graph = outer_graph.complement(&graph);

    //     let mink = Rep::new_self_dual("mink").unwrap();
    //     let mu = mink.new_slot(4, 3).to_atom();
    //     let nu = mink.new_slot(4, 2).to_atom();
    //     let metric = function!(ETS.metric, mu, nu);
    //     let p = symb!("p");
    //     let phat2 = Atom::new_var(symb!("phat")).pow(Atom::new_num(2));
    //     let pp = function!(p, mu) * function!(p, nu);
    //     let diminv = Atom::parse("1/(2-dim)").unwrap();

    //     let w1_proj = GlobalPrefactor {
    //         color: Atom::new_num(1),
    //         colorless: &diminv * (&metric - &pp / &phat2),
    //     };

    //     let w2_proj = GlobalPrefactor {
    //         color: Atom::new_num(1),
    //         colorless: (diminv * (metric - &pp / &phat2) + &pp / &phat2) / &phat2,
    //     };

    //     let mut w1 = _gammaloop::numerator::Numerator::default()
    //         .from_dis_graph(bare, &graph, &inner_graph, Some(&w1_proj))
    //         .color_simplify()
    //         .gamma_simplify()
    //         .get_single_atom()
    //         .unwrap()
    //         .0;

    //     let w2 = _gammaloop::numerator::Numerator::default()
    //         .from_dis_graph(bare, &graph, &inner_graph, Some(&w2_proj))
    //         .color_simplify();

    //     // println!("color simplified:{}", w2.state.colorless);

    //     let w2 = w2.gamma_simplify();

    //     // println!("gamma simplified: {}", w2.state.colorless);

    //     let mut w2 = w2.get_single_atom().unwrap().0;

    //     numerator_dis_apply(&mut w1);
    //     numerator_dis_apply(&mut w2);

    //     let mut props = vec![];
    //     for (j, e) in graph.iter_egdes(&inner_graph) {
    //         let edge = &e.data.as_ref().unwrap().bare_edge;
    //         let i = e.data.as_ref().unwrap().bare_edge_id;
    //         if matches!(j, EdgeId::Paired { .. }) {
    //             let mass = edge.particle.mass.expression.clone();
    //             let emr_mom = function!(DIS_SYMBOLS.emr_mom, i as i32);
    //             props.push(Prop::new(mass, emr_mom));
    //             // denominator = denominator * function!(denomsymb, mass, emr_mom);
    //         };
    //     }

    //     DisGraph {
    //         graph,
    //         numerator: vec![w1.expand(), w2.expand()],
    //         denominator: DenominatorDis::new(props),
    //         lmb_photon: seen_pdg22.unwrap(),
    //         marked_electron_edge: seen_pdg11.unwrap(),
    //         basis,
    //     }
    // }

    pub fn from_bare(bare: &BareGraph) -> DisGraph {
        let h = bare.hedge_representation.clone();

        let mut elec_node = None;

        if let Some((elec, _, _)) = h
            .iter_edges(&h.full_filter())
            .find(|(_, _, n)| bare.edges[*n.data].particle.pdg_code.abs() == 11)
        {
            if let HedgePair::Paired { source, .. } = elec {
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

        let basis_start = h.id_from_hairs(&node).unwrap();

        DisGraph::from_hedge(
            h.map(
                |_, _, _, v| (v, bare.vertices[v].clone()),
                |_, _, _, d| d.map(|data| (data, bare.edges[data].clone())),
            ),
            bare,
            basis_start,
            included_hedge,
        )
    }

    pub fn cut_content(&self, cut: &OrientedCut) -> isize {
        let mut cut_content = 0;
        // println!("looking at cut {}", cut);
        cut.iter_edges(&self.graph).for_each(|(a, p)| {
            let particle = &p.data.bare_edge.particle;
            if particle.color.abs() == 3 && particle.spin == 2 {
                match a.relative_to(p.orientation.try_into().unwrap()) {
                    Orientation::Default => {
                        // println!("looking at particle: {}", particle.name);
                        cut_content += 1
                    }
                    Orientation::Reversed => {
                        // println!("looking at anti particle: {}", particle.name);
                        cut_content -= 1
                    }
                    Orientation::Undirected => panic!("undirected fermion!"),
                }
            }
        });

        cut_content
    }

    fn color_and_spin_average(&self, cut: &OrientedCut) -> Atom {
        let nc = Atom::new_var(symb!("Nc"));
        let cut_content = self.cut_content(cut);

        match cut_content {
            0 => Atom::new_num(1) / ((&nc * &nc - 1) * (Atom::new_var(GS.dim) - 2)),
            _ => Atom::new_num(1) / (nc * 2).pow(Atom::new_num(cut_content.abs() as i32)),
            // -1 => Atom::new_num(1) / (nc * 2),
            // _ => {
            // warn!("invalid cut content");
            // Atom::new_num(1)
            // }
        }
    }
    pub fn numerator(&self, cut: &OrientedCut) -> AHashMap<String, Atom> {
        let emr_to_lmb_cut = self.emr_to_lmb_and_cut(cut);

        // for a in &emr_to_lmb_cut {
        //     println!("{}", a);
        // }

        self.numerator
            .iter()
            .map(|(k, v)| {
                (
                    k.clone(),
                    (v.replace_all_multiple_repeat(&emr_to_lmb_cut)
                        * self.color_and_spin_average(cut))
                    .expand()
                    .factor(),
                )
            })
            .collect()
    }

    pub fn denominator(&self, cut: &OrientedCut) -> DenominatorDis {
        let emr_to_lmb_cut = self.emr_to_lmb_and_cut(cut);
        self.denominator
            .map_all(&|a| a.replace_all_multiple(&emr_to_lmb_cut).expand())
    }

    pub fn emr_to_lmb_and_cut(&self, cut: &OrientedCut) -> Vec<Replacement> {
        let photon_momenta = function!(DIS_SYMBOLS.loop_mom, self.lmb_photon.1 as i32);
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
        for (_, _, d) in self.graph.iter_edges(&self.graph.full_graph()) {
            let data = d.data;

            // println!(
            //     "{}->{}",
            //     function!(DIS_SYMBOLS.emr_mom, data.bare_edge_id as i32),
            //     data.lmb_momentum.replace_all_multiple(&reps)
            // );
            emr_to_lmb_cut.insert(
                function!(DIS_SYMBOLS.emr_mom, data.emr_idx as i32),
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
        // let electron_momenta = function!(DIS_SYMBOLS.loop_mom, self.marked_electron_edge.1 as i32);
        let photon_momenta = function!(DIS_SYMBOLS.loop_mom, self.lmb_photon.1 as i32);

        for cut_edge in cut.iter_left_hedges() {
            if self.graph[[&cut_edge]].bare_edge.particle.pdg_code.abs() != 11 {
                sum = sum
                    + SignOrZero::from(self.graph.flow(cut_edge))
                        * self.graph[[&cut_edge]].lmb_momentum.clone();
            }
        }
        sum = sum - Atom::new_var(DIS_SYMBOLS.cut_mom);
        sum = sum
            .replace_all_multiple(&[Replacement::new(
                photon_momenta.to_pattern(),
                Atom::new_var(DIS_SYMBOLS.photon_mom).to_pattern(),
            )])
            .expand();

        let loop_mom_pat = function!(DIS_SYMBOLS.loop_mom, symb!("x_")).to_pattern();

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
    emr_idx: usize,
    emr_momentum: Atom,
}

// impl PartialEq for DisEdge {
//     fn eq(&self, other: &Self) -> bool {

//     }
// }

// impl PartialOrd for DisEdge {
//     fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
//         self.bare_edge.particle.pdg_code.partial_cmp(&other.bare_edge.particle.pdg_code.)
//     }
// }

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
    _pq_to_ext: Vec<Replacement>,
    ext_to_pq: Vec<(Atom, Atom)>,
    prefactor: Atom,
    topology: Topology,
    numerators: AHashMap<String, Atom>,
}

impl MathematicaIntegrand {
    pub fn new(topology: Topology, numerators: &AHashMap<String, Atom>) -> Self {
        let _pq_to_ext = topology.map_pq_ext();
        let ext_to_pq = topology.map_ext_pq();

        let prefactor = topology.prefactor().replace_all_multiple(&_pq_to_ext);

        let numerators = numerators
            .iter()
            .map(|(k, v)| (k.clone(), v.replace_all_multiple_repeat(&_pq_to_ext)))
            .collect();

        Self {
            _pq_to_ext,
            prefactor,
            ext_to_pq,
            topology,
            numerators,
        }
    }
}

impl ToMathematica for MathematicaIntegrand {
    fn to_math_with_indent(&self, indent: usize) -> String {
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

        // for n in &self.numerators {
        //     println!("num:{n}");
        // }

        // map.insert(
        //     "numerators".to_string(),
        //     self.numerators
        //         .iter()
        //         .map(|a| a * &self.prefactor)
        //         .collect_vec()
        //         .to_math(),
        // );

        map.to_math_with_indent(indent)
    }
}

pub trait ToMathematica {
    fn to_math(&self) -> String {
        self.to_math_with_indent(0)
    }

    fn to_math_with_indent(&self, indent: usize) -> String;
}

fn indent_string(indent: usize) -> String {
    " ".repeat(indent)
}

impl<K: ToMathematica, V: ToMathematica> ToMathematica for AHashMap<K, V> {
    fn to_math_with_indent(&self, indent: usize) -> String {
        let mut out = String::new();
        let base_indent = indent_string(indent);
        let inner_indent = indent + 2;
        let inner_indent_str = indent_string(inner_indent);

        // Open the Association with the beginning syntax.
        // out.push_str(&base_indent);
        out.push_str("<|");
        if !self.is_empty() {
            out.push('\n');
        }
        let mut first = true;
        for (k, v) in self {
            if !first {
                out.push_str(",\n");
            } else {
                first = false;
            }
            // Print the key. We add quotes around the key.
            out.push_str(&inner_indent_str);
            out.push('"');
            out.push_str(&k.to_math_with_indent(0));
            out.push('"');
            out.push_str(" -> ");
            // For the value, we also call the indented printing.
            out.push_str(&v.to_math_with_indent(inner_indent));
        }
        if !self.is_empty() {
            out.push('\n');
            out.push_str(&base_indent);
        }
        out.push_str("|>");
        out
    }
}

impl ToMathematica for String {
    fn to_math_with_indent(&self, _indent: usize) -> String {
        self.clone()
    }
}

impl ToMathematica for i32 {
    fn to_math_with_indent(&self, _indent: usize) -> String {
        self.to_string()
    }
}

impl ToMathematica for Atom {
    fn to_math_with_indent(&self, _indent: usize) -> String {
        self.printer(symbolica::printer::PrintOptions::mathematica())
            .to_string()
    }
}

impl ToMathematica for &Atom {
    fn to_math_with_indent(&self, _indent: usize) -> String {
        self.printer(symbolica::printer::PrintOptions::mathematica())
            .to_string()
    }
}

impl<E: ToMathematica> ToMathematica for Vec<E> {
    fn to_math_with_indent(&self, indent: usize) -> String {
        let mut out = String::new();
        let base_indent = indent_string(indent);
        let inner_indent = indent + 2;
        let inner_indent_str = indent_string(inner_indent);
        // out.push_str(&base_indent);
        out.push('{');
        if !self.is_empty() {
            out.push('\n');
        }
        let mut first = true;
        for element in self {
            if !first {
                out.push_str(",\n");
            } else {
                first = false;
            }
            out.push_str(&inner_indent_str);
            out.push_str(&element.to_math_with_indent(inner_indent));
        }
        if !self.is_empty() {
            out.push('\n');
            out.push_str(&base_indent);
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
    fn to_math_with_indent(&self, indent: usize) -> String {
        let mut map = AHashMap::new();

        let mut numbering_map = IndexSet::new();
        let mut nodelist = Vec::new();

        for (e, _, _) in self.graph.iter_edges(&self.graph.external_filter()) {
            if let HedgePair::Unpaired { hedge, flow } = e {
                let (a, _) = numbering_map.insert_full(hedge);
                nodelist.push(vec![format!("{}p[{}]", -SignOrZero::from(flow), a)]);
            } else {
                panic!("ahhhh");
            }
        }
        let ext_shift = numbering_map.len();

        for (n, _) in self.graph.iter_nodes() {
            let mut list = vec![];

            for (e, _, _) in self.graph.iter_edges(&n.hairs) {
                match e {
                    HedgePair::Split { source, split, .. } => {
                        let (a, _) = numbering_map.insert_full(source);
                        list.push(format!("{}l[{}]", SignOrZero::from(split), a - ext_shift));
                    }
                    HedgePair::Unpaired { hedge, flow } => {
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

        for (e, _, d) in self.graph.iter_edges(&self.graph.full_filter()) {
            match e {
                HedgePair::Paired { source, .. } => {
                    let (a, _) = numbering_map.insert_full(source);
                    let k = format!("l[{}]", a - ext_shift);
                    massmap.insert(k, "0".to_string());
                }
                HedgePair::Unpaired { hedge, .. } => {
                    let (a, _) = numbering_map.insert_full(hedge);
                    let k = format!("p[{a}]");
                    massmap.insert(
                        k,
                        d.data
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

        map.to_math_with_indent(indent)
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

        let poly = rat.to_polynomial(vars, true).unwrap();

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
        Err(_) => return Err("aaa".to_string()),
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

        for (e, _, d) in self.graph.iter_edges(&self.graph.external_filter()) {
            if let HedgePair::Unpaired { hedge, flow } = e {
                let (a, _) = numbering_map.insert_full(hedge);
                let p = function!(extsymb, a as i32);

                map.push((
                    p,
                    SignOrZero::from(flow) * d.data.propagator.momentum.clone(),
                ));
            } else {
                panic!("ahhhh");
            }
        }
        map
    }

    pub fn dot(&self) -> String {
        self.graph.dot_impl(
            &self.graph.full_filter(),
            "",
            &|e| Some(format!("label=\"{}\"", e.propagator.momentum)),
            &|_| None,
        )
    }

    pub fn complete_externals(&mut self) {
        let mut seen_nodes = AHashSet::new();
        if self.graph.n_externals() < 4 {
            let mut signatures = vec![];

            for (e, _, d) in self.graph.iter_edges(&self.graph.external_filter()) {
                if let HedgePair::Unpaired { .. } = e {
                    let momentum = &d.data.propagator.momentum;

                    let p = momentum
                        .pattern_match(&Atom::new_var(DIS_SYMBOLS.cut_mom).to_pattern(), None, None)
                        .next()
                        .is_some();
                    let q = momentum
                        .pattern_match(
                            &Atom::new_var(DIS_SYMBOLS.photon_mom).to_pattern(),
                            None,
                            None,
                        )
                        .next()
                        .is_some();

                    signatures.push([p, q]);
                } else {
                    panic!("ahhhh");
                }
            }

            let mut has_single_p = false;
            let mut _has_single_q = false;
            let mut _has_combined_p_q = false;

            for s in signatures {
                match s {
                    [true, true] => _has_combined_p_q = true,
                    [false, true] => _has_single_q = true,
                    [true, false] => has_single_p = true,
                    _ => {}
                }
            }

            let additional_momenta = if has_single_p {
                Atom::new_var(DIS_SYMBOLS.photon_mom)
            } else {
                Atom::new_var(DIS_SYMBOLS.cut_mom)
            };

            // println!("new_mom:{additional_momenta}");

            let new_edge = TopologyEdge {
                edgeid: self.graph.n_externals(),
                signature: Signature::from_iter(vec![
                    0i8;
                    self.graph.cyclotomatic_number(
                        &self.graph.full_graph()
                    )
                ]),
                power: 1,
                propagator: Prop {
                    mass: None,
                    momentum: additional_momenta.clone(),
                },
            };

            let mut first = true;

            while self.graph.n_externals() < 4 {
                let mut e = None;
                let node = self
                    .graph
                    .id_from_hairs(
                        self.graph
                            .iter_nodes()
                            .find(|(n, _)| {
                                let nid = self.graph.id_from_hairs(n).unwrap();
                                if seen_nodes.insert(nid) {
                                    self.graph.iter_edges(*n).any(|(eid, _, _)| {
                                        if let HedgePair::Unpaired { hedge, .. } = eid {
                                            e = Some(hedge);
                                            true
                                        } else {
                                            false
                                        }
                                    })
                                } else {
                                    false
                                }
                            })
                            .unwrap()
                            .0,
                    )
                    .unwrap();

                let mut flow = None;

                {
                    if self.graph.hedge_pair(e.unwrap()).is_unpaired() {
                        let a = self.graph[&e.unwrap()];
                        let o = self.graph.orientation(a);
                        let d = &mut self.graph[a];

                        if first {
                            flow = Some(o.try_into().unwrap());
                        } else {
                            flow = Some(o.reverse().try_into().unwrap());
                        }

                        if first {
                            d.propagator.momentum = &d.propagator.momentum - &additional_momenta;
                        } else {
                            d.propagator.momentum = &d.propagator.momentum + &additional_momenta;
                        }
                    }
                }

                self.graph = self
                    .graph
                    .clone()
                    .add_dangling_edge(node, new_edge.clone(), flow.unwrap(), false)
                    .unwrap()
                    .1;
                if first {
                    first = false;
                }
            }
        }
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

        // println!("{}", self.dot());

        for (e, _, d) in self.graph.iter_edges(&self.graph.external_filter()) {
            // println!("loop");

            if let HedgePair::Unpaired { hedge, flow } = e {
                let (a, _) = numbering_map.insert_full(hedge);
                let p = SignOrZero::from(flow) * function!(extsymb, a as i32);

                eqs.push(&d.data.propagator.momentum - &p);
                vars.push(p);
            } else {
                panic!("ahhhh");
            }

            if eqs.len() == 2 {
                // for e in &eqs {
                //     println!("eq:{}", e);
                // }

                let (a, b) = Atom::system_to_matrix::<u8, _, _>(&eqs, &pq).unwrap();

                if let Ok(s) = a.solve_any(&b) {
                    sol = Some(s);
                    break;
                } else {
                    // println!("retrying");
                    eqs.pop();
                    vars.pop();
                }
            }
        }
        let mut reps: Vec<_> = sol
            .unwrap()
            .into_vector()
            .into_vec()
            .into_iter()
            .map(|s| s.to_expression())
            .zip(pq)
            .map(|(a, b)| Replacement::new(b.to_pattern(), a.to_pattern()))
            .collect();

        let mut lmb_map = AHashMap::new();

        let mut numbering_map = IndexSet::new();
        for (n, _) in self.graph.iter_nodes() {
            for (e, _, d) in self.graph.iter_edges(&n.hairs) {
                if let HedgePair::Split { source, .. } = e {
                    let (a, new) = numbering_map.insert_full(source);
                    if new {
                        let mut lmbs = AHashSet::new();
                        for i in d.data.propagator.momentum.pattern_match(
                            &function!(DIS_SYMBOLS.loop_mom, symb!("x_")).to_pattern(),
                            None,
                            None,
                        ) {
                            lmbs.insert(function!(DIS_SYMBOLS.loop_mom, i[&symb!("x_")]));
                        }

                        if lmbs.len() == 1 {
                            lmb_map.insert(
                                lmbs.drain().next().unwrap(),
                                function!(DIS_SYMBOLS.internal_mom, a as i32),
                            );
                        }
                    }
                }
            }
        }

        for (k, v) in lmb_map {
            reps.push(Replacement::new(k.to_pattern(), v.to_pattern()));
        }
        reps
    }

    pub fn prefactor(&self) -> Atom {
        let mut p = self.prefactor.clone();

        for (_, _, d) in self.graph.iter_edges(&!self.graph.external_filter()) {
            let d = d.data;
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

        let loop_mom_pat = function!(DIS_SYMBOLS.loop_mom, symb!("x_")).to_pattern();

        for p in momenta {
            let mut matches = p.pattern_match(&loop_mom_pat, None, None);

            while let Some(m) = matches.next_detailed() {
                basis.insert(m.target.to_owned());
            }
        }

        let mut edge_signatures = vec![];

        for (_i, p) in momenta.iter().enumerate() {
            let mut coef = None;
            let mut signature = vec![];
            for (_j, b) in basis.iter().enumerate() {
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
        let (mut skeleton, signature_cut) = if unique_signatures.len() == 1 {
            let (s, i) = unique_signatures.iter().next().unwrap();
            not_seen.set(*i, false);

            let (prop, pow) = props.get_index(*i).unwrap();

            // let prefactor = if *pow > 1 {
            //     function!(DIS_SYMBOLS.internal_mom, 0).npow(1 - *pow as i32)
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

            for (i, _, c) in graph.iter_edges(&graph.full_filter()) {
                let s = c.data.signature.clone();
                if let HedgePair::Paired { sink, .. } = i {
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
                        let b = b.data.signature.clone();
                        let v = v.data.signature.clone();
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
                for (i, _, d) in skeleton.iter_edges(n) {
                    match i {
                        HedgePair::Split { split, .. } => {
                            sum =
                                sum + SignOrZero::from(split) * d.data.propagator.momentum.clone();
                        }
                        HedgePair::Unpaired { flow, .. } => {
                            sum = sum - SignOrZero::from(flow) * d.data.propagator.momentum.clone();
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
                        .find(|i| skeleton.hedge_pair(*i).is_unpaired());

                    if let Some(e) = ext {
                        if skeleton.hedge_pair(e).is_unpaired() {
                            let did = skeleton[&e];
                            let d = &mut skeleton[did];

                            let out = &d.propagator.momentum + h;
                            d.propagator.momentum = out;
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
                                false,
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
                            false,
                        )
                        .unwrap()
                        .1;
                }
                ext_edgenum += 1;
            }
        }

        let mut topo = Topology {
            graph: skeleton,
            prefactor,
        };

        topo.complete_externals();

        topo
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
            vars.push(function!(symb!("alpha"), i as i32));
            sum = sum + p.to_expression() * vars.last().unwrap();
        }
        sum = sum.expand();
        let x_ = symb!("x_");
        let y_ = symb!("y_");

        let loop_mom_dot_pat =
            function!(DIS_SYMBOLS.dot, function!(DIS_SYMBOLS.loop_mom, x_), y_).to_pattern();

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

        if system.is_empty() {
            return vec![self.clone()];
        }

        let (m, b) = Atom::system_to_matrix::<u8, _, _>(&system, &vars).unwrap();
        // m.solve_any(b)
        let old_col = m.ncols() as u32;
        let mut aug = m.augment(&b).unwrap();
        aug.row_reduce(old_col);
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
            let so = sol[i].to_expression();
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
                    } else if *v > 1 {
                        propsnew.insert(k.clone(), v - 1);
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

    // pub fn to_mathematica_integrand(&self) -> Option<MathematicaIntegrand> {
    //     let topology = self.topology();

    //     None
    // }

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
        let mut props = IndexMap::new();

        for (k, v) in self.props.iter() {
            let p = k.map_all(f);
            *props.entry(p).or_insert(0) += *v;
        }
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
        function!(
            DIS_SYMBOLS.prop,
            self.mass.clone().unwrap_or(Atom::Zero),
            self.momentum.clone()
        )
    }

    pub fn to_expression(&self) -> Atom {
        function!(
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
) -> PositionalHedgeGraph<(&'a DisEdge, Option<Flow>, Atom), &'a DisVertex> {
    let c = graph.emr_to_lmb_and_cut(&cut);
    // let layout_graph = graph.graph.map_edges_ref(f)

    // let file = std::fs::File::open("layout_params.json").unwrap();
    // let layout_iters = serde_yaml::from_reader::<_, LayoutIters>(file).unwrap();
    let pos = cut.layout(&graph.graph, params, iter_params, edge_len);

    let mut pos = pos.map(
        |_, _, _, a| a,
        |_, _, _, a| {
            a.map(|l| {
                l.map(|d| {
                    (
                        d.edge_data().clone(),
                        d.flow(),
                        d.edge_data().emr_momentum.replace_all_multiple(&c),
                    )
                })
            })
        },
    );

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
        Vec<(
            String,
            PositionalHedgeGraph<(&'a DisEdge, Option<Flow>, Atom), &'a DisVertex>,
        )>,
    )],
    filename: &str,
) -> std::io::Result<()> {
    std::fs::write(
        filename,
        String::from_str("#set page(width: 35cm, height: auto)\n").unwrap()
            + PositionalHedgeGraph::cetz_impl_collection(
                layouts,
                &|(_, o, a)| {
                    format!(
                        "{}",
                        (SignOrZero::from(
                            o.map_or_else(|| Orientation::Undirected, |a| Orientation::from(a))
                        ) * a.expand())
                        .expand()
                        .printer(symbolica::printer::PrintOptions::mathematica())
                    )
                },
                &|(e, _, _)| e.decoration(),
                true,
            )
            .as_str(),
    )
}
pub mod gen;

#[cfg(test)]
pub mod tests;
