use std::{
    fs::File,
    io::{BufReader, BufWriter},
};

use _gammaloop::graph::{
    half_edge::layout::{FancySettings, LayoutParams},
    BareGraph,
};
use dis::{dis_cut_layout, load_generic_model, write_layout, DisGraph};
use symbolica::{
    atom::Atom,
    domains::{integer::Z, rational::Q},
    symb,
};

fn main() {
    let model = load_generic_model("sm");
    let mut symbolica_graph = symbolica::graph::Graph::new();

    let v1 = symbolica_graph.add_node((0, "V_98".into()));
    let v2 = symbolica_graph.add_node((0, "V_98".into()));
    let v3 = symbolica_graph.add_node((0, "V_71".into()));
    let v4 = symbolica_graph.add_node((0, "V_71".into()));
    let v5 = symbolica_graph.add_node((0, "V_74".into()));
    let v6 = symbolica_graph.add_node((0, "V_74".into()));
    symbolica_graph.add_edge(v1, v2, true, "e-").unwrap();
    symbolica_graph.add_edge(v2, v1, true, "e-").unwrap();
    symbolica_graph.add_edge(v2, v4, true, "a").unwrap();
    symbolica_graph.add_edge(v1, v3, true, "a").unwrap();

    symbolica_graph.add_edge(v3, v5, true, "d").unwrap();
    symbolica_graph.add_edge(v5, v6, true, "d").unwrap();
    symbolica_graph.add_edge(v6, v4, true, "d").unwrap();
    symbolica_graph.add_edge(v4, v3, true, "d").unwrap();

    symbolica_graph.add_edge(v5, v6, true, "g").unwrap();
    let bare_graph = BareGraph::from_symbolica_graph(
        &model,
        "disselfenergy".into(),
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

    let mut layouts = Vec::new();
    let mut routings_integrand = Vec::new();

    ifsplit.to_mathematica_file(&dis_graph, "self_energy");

    for (i, (e, cuts)) in ifsplit.cuts.iter().enumerate() {
        println!("Embedding {}:{:?}", i + 1, e.windings);

        let first_initial = &cuts[0][0];

        let denom = dis_graph.denominator(first_initial);
        let num: Vec<_> = dis_graph
            .numerator(first_initial)
            .iter()
            .map(|a| a.expand())
            .collect();

        let denom = dis_graph.denominator(first_initial);
        let denoms = denom.partial_fraction();
        println!(
            "Denominator:{} ",
            denom
                .to_atom()
                .printer(symbolica::printer::PrintOptions::mathematica())
        );

        let mut sum = Atom::new_num(0);
        for d in &denoms {
            d.to_mathematica_integrand();

            if d.is_dotted() {
                println!("Dotted");
            }
            sum = sum + d.to_atom();
        }
        println!(
            "Partial fractioned denom:\n{}",
            sum.printer(symbolica::printer::PrintOptions {
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
        );

        let mut sum = Atom::new_num(0);

        let iszero = (denom.to_expression() - sum).expand();

        let iszero = iszero
            .as_view()
            .to_rational_polynomial::<_, _, u8>(&Q, &Z, None);

        println!("is_zero{}", iszero);
        // println!(
        //     "W1:{} ",
        //     num[0].printer(symbolica::printer::PrintOptions::mathematica())
        // );

        // println!(
        //     "W2:{} ",
        //     num[1].printer(symbolica::printer::PrintOptions::mathematica())
        // );

        let first_initial_layout =
            dis_cut_layout(&first_initial, &dis_graph, &params, Some(&fancy_settings));

        let layout_emb_i = cuts[0]
            .iter()
            .map(|c| dis_cut_layout(c, &dis_graph, &params, None))
            .collect();

        let layout_emb_f = cuts[1]
            .iter()
            .map(|c| dis_cut_layout(c, &dis_graph, &params, None))
            .collect();

        layouts.push((
            format!("embedding{}i", i + 1),
            format!("= embedding {} {:?} \n == initial", i + 1, e.windings),
            layout_emb_i,
        ));

        layouts.push((
            format!("embedding{}f", i + 1),
            format!("== final"),
            layout_emb_f,
        ));

        routings_integrand.push((
            format!("embedding{}i", i + 1),
            format!(
                "= embedding {} {:?} initial\nDenominator:\n```mathematica\n{}\n```",
                i + 1,
                e.windings,
                denom
                    .to_atom()
                    .printer(symbolica::printer::PrintOptions::mathematica())
            ),
            vec![first_initial_layout],
        ));
    }
    write_layout(&layouts, "self_energy_embeddings.typ");
    write_layout(&routings_integrand, "self_energy_integrands.typ");
}
