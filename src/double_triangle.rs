use _gammaloop::{
    feyngen::diagram_generator::{EdgeColor, NodeColorWithVertexRule},
    graph::BareGraph,
};
use dis::DisGraph;
use linnet::half_edge::layout::{FancySettings, LayoutIters, LayoutParams};

use dis::load_generic_model;

fn main() {
    let model = load_generic_model("sm");
    let mut symbolica_graph = symbolica::graph::Graph::new();

    let epema = NodeColorWithVertexRule {
        external_tag: 0,
        vertex_rule: model.get_vertex_rule("V_98"),
    };

    let dda = NodeColorWithVertexRule {
        external_tag: 0,
        vertex_rule: model.get_vertex_rule("V_71"),
    };
    let ddg = NodeColorWithVertexRule {
        external_tag: 0,
        vertex_rule: model.get_vertex_rule("V_74"),
    };

    let l1 = symbolica_graph.add_node(epema.clone());
    let l2 = symbolica_graph.add_node(epema.clone());
    let l3 = symbolica_graph.add_node(dda.clone());
    let l4 = symbolica_graph.add_node(dda.clone());
    let l5 = symbolica_graph.add_node(ddg.clone());
    let l6 = symbolica_graph.add_node(ddg.clone());

    let eminus = EdgeColor::from_particle(model.get_particle("e-"));
    let a = EdgeColor::from_particle(model.get_particle("a"));
    let d = EdgeColor::from_particle(model.get_particle("d"));
    let g = EdgeColor::from_particle(model.get_particle("g"));
    symbolica_graph.add_edge(l1, l2, true, eminus).unwrap();
    symbolica_graph.add_edge(l2, l1, true, eminus).unwrap();
    symbolica_graph.add_edge(l2, l4, true, a).unwrap();
    symbolica_graph.add_edge(l1, l3, true, a).unwrap();

    symbolica_graph.add_edge(l3, l6, true, d).unwrap();
    symbolica_graph.add_edge(l6, l4, true, d).unwrap();
    symbolica_graph.add_edge(l4, l5, true, d).unwrap();
    symbolica_graph.add_edge(l5, l3, true, d).unwrap();

    symbolica_graph.add_edge(l5, l6, true, g).unwrap();
    let bare_graph = BareGraph::from_symbolica_graph(
        &model,
        "disdoubletriangle".into(),
        &symbolica_graph,
        "1".into(),
        vec![],
        None,
    )
    .unwrap();

    println!("from_bare");
    let dis_graph = DisGraph::from_bare(&bare_graph);

    let ifsplit = dis_graph.full_dis_filter_split();

    let file = std::fs::File::open("fancy_settings.json").unwrap();
    let _fancy_settings = serde_json::from_reader::<_, FancySettings>(file).unwrap();

    let file = std::fs::File::open("layout_params.json").unwrap();
    let _params = serde_json::from_reader::<_, LayoutParams>(file).unwrap();

    let file = std::fs::File::open("layout_iters.json").unwrap();
    let _layout_iters = serde_yaml::from_reader::<_, LayoutIters>(file).unwrap();
    // let mut layouts: Vec<_> = Vec::new();
    // let mut routings_integrand = Vec::new();

    // for (i, (e, cuts)) in ifsplit.cuts.iter().enumerate() {
    //     println!("Embedding {}:{:?}", i + 1, e.windings);

    //     let first_initial = &cuts[0][0];

    //     let denom = dis_graph.denominator(first_initial);
    //     let denoms = denom.partial_fraction();
    //     println!(
    //         "Denominator:{} ",
    //         denom
    //             .to_atom()
    //             .printer(symbolica::printer::PrintOptions::mathematica())
    //     );

    //     let mut sum = Atom::new_num(0);
    //     for d in &denoms {
    //         let topo = d.topology();
    //         print!(
    //             "topology: {}",
    //             topo.graph.dot_impl(
    //                 &topo.graph.full_filter(),
    //                 "".into(),
    //                 &|e| Some(format!("label=\"{}\"", e.propagator.momentum)),
    //                 &|_| None
    //             )
    //         );

    //         topo.map_pq_ext();

    //         print!("topology_math: {}", topo.to_math());
    //         d.to_mathematica_integrand();
    //         sum = sum + d.to_atom();
    //     }
    //     println!(
    //         "Partial fractioned denom:\n{}",
    //         sum.printer(symbolica::printer::PrintOptions {
    //             pretty_matrix: true,
    //             terms_on_new_line: true,
    //             color_top_level_sum: false,
    //             color_builtin_symbols: false,
    //             print_finite_field: true,
    //             symmetric_representation_for_finite_field: false,
    //             explicit_rational_polynomial: false,
    //             number_thousands_separator: None,
    //             multiplication_operator: ' ',
    //             double_star_for_exponentiation: false,
    //             square_brackets_for_function: true,
    //             num_exp_as_superscript: false,
    //             latex: false,
    //             precision: None,
    //         })
    //     );

    //     // let denom = dis_graph.denominator_partial_fraction(first_initial);
    //     let num: Vec<_> = dis_graph
    //         .numerator(first_initial)
    //         .iter()
    //         .map(|a| a.expand())
    //         .collect();
    //     // let denom = denom.iter().fold(Atom::new_num(1), |acc, a| acc * a);

    //     println!(
    //         "W1:{} ",
    //         num[0].printer(symbolica::printer::PrintOptions::mathematica())
    //     );

    //     // println!(
    //     //     "W2:{} ",
    //     //     num[1].printer(symbolica::printer::PrintOptions::mathematica())
    //     // );

    //     let first_initial_layout = dis_cut_layout(
    //         first_initial.clone(),
    //         &dis_graph,
    //         params,
    //         layout_iters,
    //         Some(&fancy_settings),
    //         20.,
    //     );

    //     let layout_emb_i: Vec<_> = cuts[0]
    //         .iter()
    //         .map(|c| {
    //             dis_cut_layout(
    //                 c.clone(),
    //                 &dis_graph,
    //                 params,
    //                 layout_iters,
    //                 Some(&fancy_settings),
    //                 20.,
    //             )
    //         })
    //         .collect();

    //     let layout_emb_f = cuts[1]
    //         .iter()
    //         .map(|c| dis_cut_layout(c.clone(), &dis_graph, params, layout_iters, None, 20.))
    //         .collect();

    //     layouts.push((
    //         format!("embedding{}i", i + 1),
    //         format!(
    //             "= embedding {} {:?} \n == initial\nDenominator:\n```mathematica\n{}\n```Partial Fractioned Denominator:\n```mathematica\n{}\n```",
    //             i + 1,
    //             e.windings,
    //             denom
    //                 .to_atom()
    //                 .printer(symbolica::printer::PrintOptions::mathematica()),
    //             sum.printer(symbolica::printer::PrintOptions {
    //                 pretty_matrix:true,
    //                 terms_on_new_line: true,
    //                 color_top_level_sum: false,
    //                 color_builtin_symbols: false,
    //                 print_finite_field: true,
    //                 symmetric_representation_for_finite_field: false,
    //                 explicit_rational_polynomial: false,
    //                 number_thousands_separator: None,
    //                 multiplication_operator: ' ',
    //                 double_star_for_exponentiation: false,
    //                 square_brackets_for_function: true,
    //                 num_exp_as_superscript: false,
    //                 latex: false,
    //                 precision: None,
    //             })
    //         ),
    //         layout_emb_i,
    //     ));

    //     layouts.push((
    //         format!("embedding{}f", i + 1),
    //         format!("== final"),
    //         layout_emb_f,
    //     ));

    //     routings_integrand.push((
    //         format!("embedding{}i", i + 1),
    //         format!(
    //             "= embedding {} {:?} initial\nDenominator:\n```mathematica\n{}\n```",
    //             i + 1,
    //             e.windings,
    //             denom
    //                 .to_atom()
    //                 .printer(symbolica::printer::PrintOptions::mathematica())
    //         ),
    //         vec![first_initial_layout],
    //     ));
    // }
    // write_layout(&layouts, "double_triangle_embeddings.typ");
    //
    ifsplit
        .to_typst(&dis_graph, "outputs/double_triangle/double_triangle.typ")
        .unwrap();
    // ifsplit
    //     .to_mathematica_file(&dis_graph, "double_triangle.m")
    //     .unwrap();
    ifsplit
        .to_other_mathematica_file(&dis_graph, "outputs/double_triangle/double_triangle_new.m")
        .unwrap();
    // write_layout(&routings_integrand, "double_triangle_integrands.typ");
}

#[cfg(test)]
mod test {
    #[test]
    fn feature() {}
}
