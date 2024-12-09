use std::{
    fs::File,
    io::{BufReader, BufWriter},
};

use _gammaloop::graph::{
    half_edge::layout::{FancySettings, LayoutParams},
    BareGraph,
};
use dis::{dis_cut_layout, load_generic_model, write_layout, DisGraph};
use symbolica::symb;

fn main() {
    let model = load_generic_model("sm");
    let mut symbolica_graph = symbolica::graph::Graph::new();

    let v1 = symbolica_graph.add_node((0, "V_98".into()));
    let v2 = symbolica_graph.add_node((0, "V_98".into()));
    let v3 = symbolica_graph.add_node((0, "V_71".into()));
    let v4 = symbolica_graph.add_node((0, "V_71".into()));
    let v5 = symbolica_graph.add_node((0, "V_74".into()));
    let v6 = symbolica_graph.add_node((0, "V_74".into()));
    let v7 = symbolica_graph.add_node((0, "V_74".into()));
    let v8 = symbolica_graph.add_node((0, "V_74".into()));
    let v9 = symbolica_graph.add_node((0, "V_37".into()));

    symbolica_graph.add_edge(v1, v2, true, "e-").unwrap();
    symbolica_graph.add_edge(v2, v1, true, "e-").unwrap();
    symbolica_graph.add_edge(v2, v4, true, "a").unwrap();
    symbolica_graph.add_edge(v1, v3, true, "a").unwrap();

    symbolica_graph.add_edge(v3, v5, true, "d").unwrap();
    symbolica_graph.add_edge(v5, v6, true, "d").unwrap();
    symbolica_graph.add_edge(v6, v4, true, "d").unwrap();
    symbolica_graph.add_edge(v4, v8, true, "d").unwrap();
    symbolica_graph.add_edge(v8, v7, true, "d").unwrap();
    symbolica_graph.add_edge(v7, v3, true, "d").unwrap();

    symbolica_graph.add_edge(v5, v9, true, "g").unwrap();
    symbolica_graph.add_edge(v6, v9, true, "g").unwrap();
    symbolica_graph.add_edge(v7, v9, true, "g").unwrap();
    symbolica_graph.add_edge(v8, v9, true, "g").unwrap();
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

    let params = serde_json::from_reader::<_, LayoutParams>(reader).unwrap();

    let fancy_settings = FancySettings {
        label_shift: 0.06,
        arrow_angle_percentage: Some(0.7),
        arrow_shift: 0.06,
    };

    // let mut layouts = Vec::new();
    // let mut routings_integrand = Vec::new();

    for (i, (e, cuts)) in ifsplit.cuts.iter().enumerate() {
        println!("Embedding {}:{:?}", i + 1, e.windings);

        let first_initial = &cuts[0][0];

        let denom = dis_graph.denominator(first_initial);
        let num: Vec<_> = dis_graph
            .numerator(first_initial)
            .iter()
            .map(|a| a.expand())
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
