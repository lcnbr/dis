use _gammaloop::{
    numerator::{ufo::UFO, ColorSimplified, GammaSimplified, Numerator},
    utils::GS,
};
use spenso::{
    data::StorageTensor,
    parametric::atomcore::PatternReplacement,
    shadowing::ETS,
    structure::representation::{BaseRepName, Minkowski},
    symbolica_utils::SerializableAtom,
};
use symbolica::{
    atom::{Atom, AtomCore, AtomView, FunctionBuilder, Symbol},
    function,
    id::{Context, Match, Pattern, Replacement},
    symb,
};

pub fn gamma_simplify_impl(mut expr: SerializableAtom) -> SerializableAtom {
    // let mink = Minkowski::rep(4);
    fn mink(wildcard: Symbol) -> Atom {
        Minkowski::rep(4).pattern(Atom::new_var(wildcard))
    }
    expr.0 = expr.0.expand();
    let pats = [
        Replacement::new(
            Pattern::parse("id(a_,b_)*t_(d___,b_,c___)").unwrap(),
            Pattern::parse("t_(d___,a_,c___)").unwrap(),
        ),
        Replacement::new(
            Pattern::parse("Metric(mink(a_),mink(b_))*t_(d___,mink(b_),c___)").unwrap(),
            Pattern::parse("t_(d___,mink(a_),c___)").unwrap(),
        ),
    ];

    expr = expr.replace_all_multiple_repeat(&pats);
    let pats = vec![
        (
            Pattern::parse("ProjP(a_,b_)").unwrap(),
            Pattern::parse("1/2*id(a_,b_)-1/2*gamma5(a_,b_)").unwrap(),
        ),
        (
            Pattern::parse("ProjM(a_,b_)").unwrap(),
            Pattern::parse("1/2*id(a_,b_)+1/2*gamma5(a_,b_)").unwrap(),
        ),
        (
            Pattern::parse("id(a_,b_)*f_(d___,b_,e___)").unwrap(),
            Pattern::parse("f_(c___,a_,e___)").unwrap(),
        ),
        // (
        //     Pattern::parse("id(aind(a_,b_))*f_(c___,aind(d___,a_,e___))").unwrap(),
        //     Pattern::parse("f_(c___,aind(d___,b_,e___))")
        //         .unwrap()
        //         ,
        // ),
        (
            Pattern::parse("γ(a_,b_,c_)*γ(d_,c_,e_)").unwrap(),
            Pattern::parse("gamma_chain(a_,d_,b_,e_)").unwrap(),
        ),
        (
            Pattern::parse("gamma_chain(a__,b_,c_)*gamma_chain(d__,c_,e_)").unwrap(),
            Pattern::parse("gamma_chain(a__,d__,b_,e_)").unwrap(),
        ),
        (
            Pattern::parse("γ(a_,b_,c_)*gamma_chain(d__,c_,e_)").unwrap(),
            Pattern::parse("gamma_chain(a_,d__,b_,e_)").unwrap(),
        ),
        (
            Pattern::parse("gamma_chain(a__,b_,c_)*γ(d_,c_,e_)").unwrap(),
            Pattern::parse("gamma_chain(a__,d_,b_,e_)").unwrap(),
        ),
        (
            Pattern::parse("gamma_chain(a__,b_,b_)").unwrap(),
            Pattern::parse("gamma_trace(a__)").unwrap(),
        ),
    ];
    let reps: Vec<Replacement> = pats
        .into_iter()
        .map(|(lhs, rhs)| Replacement::new(lhs, rhs))
        .collect();
    expr.0 = expr.0.expand();
    expr.replace_all_multiple_repeat_mut(&reps);
    expr.0 = expr.0.expand();
    expr.replace_all_multiple_repeat_mut(&reps);

    let pat = Pattern::parse("gamma_trace(a__)").unwrap();

    let mut it = expr.0.pattern_match(&pat, None, None);

    let mut max_nargs = 0;

    while let Some(p) = it.next_detailed() {
        for (_, v) in p.match_stack {
            match v {
                Match::Single(_) => {
                    if max_nargs < 1 {
                        max_nargs = 1;
                    }
                }
                Match::Multiple(_, v) => {
                    if max_nargs < v.len() {
                        max_nargs = v.len();
                    }
                }
                _ => panic!("should be a single match"),
            }
        }
    }

    expr.0 = expr.0.expand();
    // let pats: Vec<_> = [
    //     (
    //         function!(ETS.id, GS.a_, GS.b_) * function!(GS.f_, GS.d___, GS.b_, GS.c___),
    //         function!(GS.f_, GS.d___, GS.a_, GS.c___),
    //     ),
    //     (
    //         function!(ETS.metric, mink(GS.a_), mink(GS.b_))
    //             * function!(GS.f_, GS.d___, mink(GS.b_), GS.c___),
    //         function!(GS.f_, GS.d___, mink(GS.a_), GS.c___),
    //     ),
    // ]
    // .iter()
    // .map(|(a, b)| Replacement::new(a.to_pattern(), b.to_pattern()))
    // .collect();

    // expr = expr.replace_all_multiple_repeat(&pats);

    let gamma_chain = symb!("gamma_chain");
    let gamma_trace = symb!("gamma_trace");
    let reps: Vec<_> = [
        (
            function!(ETS.id, GS.a_, GS.b_) * function!(GS.f_, GS.d___, GS.b_, GS.c___),
            function!(GS.f_, GS.d___, GS.a_, GS.c___),
        ),
        (
            function!(ETS.metric, mink(GS.a_), mink(GS.b_))
                * function!(GS.f_, GS.d___, mink(GS.b_), GS.c___),
            function!(GS.f_, GS.d___, mink(GS.a_), GS.c___),
        ),
        (
            function!(UFO.projp, GS.a_, GS.b_),
            (function!(ETS.id, GS.a_, GS.b_) - function!(ETS.gamma5, GS.a_, GS.b_)) / 2,
        ),
        (
            function!(UFO.projm, GS.a_, GS.b_),
            (function!(ETS.id, GS.a_, GS.b_) + function!(ETS.gamma5, GS.a_, GS.b_)) / 2,
        ),
        (
            function!(ETS.gamma, GS.a_, GS.b_, GS.c_) * function!(ETS.gamma, GS.d_, GS.c_, GS.e_),
            function!(gamma_chain, GS.a_, GS.d_, GS.b_, GS.e_),
        ),
        (function!(ETS.gamma, GS.a_, GS.b_, GS.b_), Atom::Zero),
        (
            function!(gamma_chain, GS.a__, GS.a_, GS.b_)
                * function!(gamma_chain, GS.b__, GS.b_, GS.c_),
            function!(gamma_chain, GS.a__, GS.b__, GS.a_, GS.c_),
        ),
        (
            function!(gamma_chain, GS.a__, GS.a_, GS.b_)
                * function!(ETS.gamma, GS.y_, GS.b_, GS.c_),
            function!(gamma_chain, GS.a__, GS.y_, GS.a_, GS.c_),
        ),
        (
            function!(ETS.gamma, GS.a_, GS.a_, GS.b_)
                * function!(gamma_chain, GS.y__, GS.b_, GS.c_),
            function!(gamma_chain, GS.a_, GS.y__, GS.a_, GS.c_),
        ),
    ]
    .iter()
    .map(|(a, b)| Replacement::new(a.to_pattern(), b.to_pattern()))
    .collect();

    expr.0 = expr.0.expand();
    expr.replace_all_multiple_repeat_mut(&reps);
    expr.0 = expr.0.expand();
    expr.replace_all_multiple_repeat_mut(&reps);

    let _pat = function!(gamma_chain, GS.a_, GS.a___, GS.b_, GS.a_).to_pattern();
    // let patodd = (-2 * function!(gamma_chain, GS.a___, GS.b_)).to_pattern();
    // let pateven = (2 * (function!(gamma_chain, GS.b_, GS.a___))).to_pattern();

    // let rhs = PatternOrMap::Map(Box::new(move |m| m.));
    //
    fn gamma_chain_perm(arg: AtomView, _context: &Context, out: &mut Atom) -> bool {
        let gamma_chain = symb!("gamma_chain");
        let mut found = false;
        if let AtomView::Fun(f) = arg {
            if f.get_symbol() == gamma_chain {
                found = true;
                let args = f.iter().collect::<Vec<_>>();
                let len = args.len();
                if len <= 3 {
                    return false;
                }

                if args[len - 3] == args[0] {
                    if len == 4 {
                        *out = function!(ETS.id, args[len - 2], args[len - 1]) * 4;
                        return true;
                    } else if len % 2 == 0 {
                        let mut gcn = FunctionBuilder::new(gamma_chain);
                        let mut gcnp = FunctionBuilder::new(gamma_chain);
                        gcn = gcn.add_arg(args[len - 4]);
                        gcn = gcn.add_args(&args[1..(len - 4)]);
                        for a in &args[1..(len - 4)] {
                            gcnp = gcnp.add_arg(*a);
                        }
                        gcnp = gcnp.add_arg(args[len - 4]);
                        gcnp = gcnp.add_args(&args[(len - 2)..len]);
                        gcn = gcn.add_args(&args[(len - 2)..len]);
                        *out = (gcn.finish() + gcnp.finish()) * 2;
                    } else {
                        let mut gcn = FunctionBuilder::new(gamma_chain);
                        gcn = gcn.add_args(&args[1..(len - 4)]);
                        gcn = gcn.add_args(&args[(len - 2)..len]);
                        *out = gcn.finish() * -2;
                    }

                    // println!("{}->{}", arg, out);
                } else {
                    return false;
                }
            }
        }
        found
    }

    loop {
        let new = expr.0.replace_map(&gamma_chain_perm);
        if new == expr.0 {
            break;
        } else {
            expr.0 = new;
        }
    }

    expr.replace_all_repeat_mut(
        &(function!(gamma_chain, GS.a__, GS.x_, GS.x_).to_pattern()),
        function!(gamma_trace, GS.a__).to_pattern(),
        None,
        None,
    );

    // //Chisholm identity:
    // expr.replace_all_repeat_mut(
    //     &(function!(ETS.gamma, GS.a_, GS.x_, GS.y_) * function!(gamma_trace, GS.a_, GS.a__)).to_pattern(),
    //     (function!(gamma_chain, GS.a__)).to_pattern(),
    //     None,
    //     None,
    // );
    //
    fn gamma_tracer(arg: AtomView, _context: &Context, out: &mut Atom) -> bool {
        let gamma_trace = symb!("gamma_trace");

        let mut found = false;
        if let AtomView::Fun(f) = arg {
            if f.get_symbol() == gamma_trace {
                found = true;
                let mut sum = Atom::Zero;

                if f.get_nargs() == 1 {
                    *out = Atom::Zero;
                }
                let args = f.iter().collect::<Vec<_>>();

                for i in 1..args.len() {
                    let sign = if i % 2 == 0 { -1 } else { 1 };

                    let mut gcn = FunctionBuilder::new(gamma_trace);
                    #[allow(clippy::needless_range_loop)]
                    for j in 1..args.len() {
                        if i != j {
                            gcn = gcn.add_arg(args[j]);
                        }
                    }

                    let metric = if args[0] == args[i] {
                        // Atom::new_num(4)
                        Atom::new_var(GS.dim)
                    } else {
                        function!(ETS.metric, args[0], args[i])
                    };
                    if args.len() == 2 {
                        sum = sum + metric * sign * Atom::new_var(GS.dim);
                    } else {
                        sum = sum + metric * gcn.finish() * sign;
                    }
                }
                *out = sum;

                // println!("{}->{}", arg, out);
            }
        }

        found
    }

    loop {
        let new = expr.0.replace_map(&gamma_tracer);
        if new == expr.0 {
            break;
        } else {
            expr.0 = new;
        }
    }

    let reps: Vec<_> = [
        (
            function!(ETS.metric, mink(GS.a_), mink(GS.b_))
                * function!(GS.f_, GS.d___, mink(GS.b_), GS.c___),
            function!(GS.f_, GS.d___, mink(GS.a_), GS.c___),
        ),
        (
            function!(ETS.metric, mink(GS.a_), mink(GS.b_)).pow(Atom::new_num(2)),
            Atom::new_var(GS.dim),
        ),
        (
            function!(ETS.gamma, GS.a__).pow(Atom::new_num(2)),
            Atom::new_var(GS.dim) * 4,
        ),
    ]
    .iter()
    .map(|(a, b)| Replacement::new(a.to_pattern(), b.to_pattern()))
    .collect();

    expr.replace_all_multiple_repeat_mut(&reps);
    expr.0 = expr.0.expand();
    expr.replace_all_multiple_repeat_mut(&reps);
    expr
}

pub trait Gamma {
    fn gamma_simplify_ddim(self) -> Numerator<GammaSimplified>;
}

impl Gamma for Numerator<ColorSimplified> {
    fn gamma_simplify_ddim(self) -> Numerator<GammaSimplified> {
        let gamma_simplified = self.state.colorless.map_data(gamma_simplify_impl);

        Numerator {
            state: GammaSimplified {
                colorless: gamma_simplified,
                color: self.state.color,
                state: Default::default(),
            },
        }
    }
}
