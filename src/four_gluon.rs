use std::{fs::File, io::BufReader};

use _gammaloop::{
    feyngen::diagram_generator::{EdgeColor, NodeColorWithVertexRule},
    graph::BareGraph,
};
use dis::{load_generic_model, DisGraph};
use linnet::half_edge::layout::{FancySettings, LayoutParams};
use symbolica::atom::AtomCore;

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

    let gggg = NodeColorWithVertexRule {
        external_tag: 0,
        vertex_rule: model.get_vertex_rule("V_37"),
    };

    let v1 = symbolica_graph.add_node(epema.clone());
    let v2 = symbolica_graph.add_node(epema.clone());
    let v3 = symbolica_graph.add_node(dda.clone());
    let v4 = symbolica_graph.add_node(dda.clone());
    let v5 = symbolica_graph.add_node(ddg.clone());
    let v6 = symbolica_graph.add_node(ddg.clone());
    let v7 = symbolica_graph.add_node(ddg.clone());
    let v8 = symbolica_graph.add_node(ddg.clone());
    let v9 = symbolica_graph.add_node(gggg.clone());

    let eminus = EdgeColor::from_particle(model.get_particle("e-"));
    let a = EdgeColor::from_particle(model.get_particle("a"));
    let d = EdgeColor::from_particle(model.get_particle("d"));
    let g = EdgeColor::from_particle(model.get_particle("g"));

    symbolica_graph.add_edge(v1, v2, true, eminus).unwrap();
    symbolica_graph.add_edge(v2, v1, true, eminus).unwrap();
    symbolica_graph.add_edge(v2, v4, true, a).unwrap();
    symbolica_graph.add_edge(v1, v3, true, a).unwrap();

    symbolica_graph.add_edge(v3, v5, true, d).unwrap();
    symbolica_graph.add_edge(v5, v6, true, d).unwrap();
    symbolica_graph.add_edge(v6, v4, true, d).unwrap();
    symbolica_graph.add_edge(v4, v8, true, d).unwrap();
    symbolica_graph.add_edge(v8, v7, true, d).unwrap();
    symbolica_graph.add_edge(v7, v3, true, d).unwrap();

    symbolica_graph.add_edge(v5, v9, true, g).unwrap();
    symbolica_graph.add_edge(v6, v9, true, g).unwrap();
    symbolica_graph.add_edge(v7, v9, true, g).unwrap();
    symbolica_graph.add_edge(v8, v9, true, g).unwrap();
    let bare_graph = BareGraph::from_symbolica_graph(
        &model,
        "four_gluon".into(),
        &symbolica_graph,
        "1".into(),
        vec![],
        None,
    )
    .unwrap();

    let dis_graph = DisGraph::from_bare(&bare_graph);

    let ifsplit = dis_graph.full_dis_filter_split();

    let file = File::open("layout_params.json").unwrap();
    let reader = BufReader::new(file);

    let _params = serde_json::from_reader::<_, LayoutParams>(reader).unwrap();

    let _fancy_settings = FancySettings {
        label_shift: 0.06,
        arrow_angle_percentage: Some(0.7),
        arrow_shift: 0.06,
    };

    // let mut layouts = Vec::new();
    // let mut routings_integrand = Vec::new();

    for (i, (e, cuts)) in ifsplit.cuts.iter().enumerate() {
        println!("Embedding {}:{:?}", i + 1, e.windings);

        let first_initial = &cuts.1[0][0];

        let denom = dis_graph.denominator(first_initial);
        let _num: Vec<_> = dis_graph
            .numerator(first_initial)
            .iter()
            .map(|a| a.1.expand())
            .collect();

        println!("Denominator:");

        println!(
            "{}",
            denom
                .to_atom()
                .printer(symbolica::printer::PrintOptions::mathematica())
        );

        // println!(
        //     "W1:{} ",
        //     num[0].printer(symbolica::printer::PrintOptions::mathematica())
        // );

        // println!(
        //     "W2:{} ",
        //     num[1].printer(symbolica::printer::PrintOptions::mathematica())
        // );

        // let first_initial_layout =
        //     dis_cut_layout(&first_initial, &dis_graph, &params, Some(&fancy_settings));

        // let layout_emb_i = cuts[0]
        //     .iter()
        //     .map(|c| dis_cut_layout(c, &dis_graph, &params, None))
        //     .collect();

        // let layout_emb_f = cuts[1]
        //     .iter()
        //     .map(|c| dis_cut_layout(c, &dis_graph, &params, None))
        //     .collect();

        // layouts.push((
        //     format!("embedding{}i", i + 1),
        //     format!("= embedding {} {:?} \n == initial", i + 1, e.windings),
        //     layout_emb_i,
        // ));

        // layouts.push((
        //     format!("embedding{}f", i + 1),
        //     format!("== final"),
        //     layout_emb_f,
        // ));

        // routings_integrand.push((
        //     format!("embedding{}i", i + 1),
        //     format!(
        //         "= embedding {} {:?} initial\nDenominator:\n```mathematica\n{}\n```",
        //         i + 1,
        //         e.windings,
        //         denom.printer(symbolica::printer::PrintOptions::mathematica())
        //     ),
        //     vec![first_initial_layout],
        // ));
    }
    // write_layout(&layouts, "four_gluon_embeddings.typ");
    // write_layout(&routings_integrand, "four_gluon_integrands.typ");
}
