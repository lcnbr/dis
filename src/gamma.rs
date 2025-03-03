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
    printer::PrintOptions,
    symb,
};

use crate::DIS_SYMBOLS;

pub fn gamma_simplify_impl(mut expr: SerializableAtom) -> SerializableAtom {
    // println!("expr:{expr}");
    // let mink = Minkowski::rep(4);
    fn mink(wildcard: Symbol) -> Atom {
        Minkowski::rep(4).pattern(Atom::new_var(wildcard))
    }
    expr.0 = expr.0.expand();

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

    // println!(
    //     "after simpl:{}",
    //     expr.0.expand().printer(PrintOptions {
    //         terms_on_new_line: true,
    //         ..Default::default()
    //     })
    // );
    let reps: Vec<_> = [
        (
            function!(gamma_chain, GS.a___, GS.a_, GS.a_, GS.b__),
            function!(gamma_chain, GS.a___, GS.b__) * GS.dim,
        ),
        (
            function!(gamma_chain, GS.a_, GS.b_),
            function!(ETS.id, GS.a_, GS.b_),
        ),
        (
            function!(gamma_chain, GS.a___, GS.a_, GS.b___, GS.b_, GS.a_, GS.a__),
            function!(gamma_chain, GS.a___, GS.b_, GS.b___, GS.a__) * 2
                - function!(gamma_chain, GS.a___, GS.a_, GS.b___, GS.a_, GS.b_, GS.a__),
        ),
    ]
    .iter()
    .map(|(a, b)| {
        Replacement::new(a.to_pattern(), b.to_pattern())
        // .with_conditions(symbolica::id::Condition::Yield(()))
    })
    .collect();

    loop {
        let new = expr.0.replace_all_multiple(&reps);
        // println!(
        //     "during simpl:{}",
        //     expr.0.expand().printer(PrintOptions {
        //         terms_on_new_line: true,
        //         ..Default::default()
        //     })
        // );
        if new == expr.0 {
            break;
        } else {
            expr.0 = new;
        }
    }

    loop {
        let new = expr
            .0
            .replace_map(&|a, b, c| {
                let gamma_chain = symb!("gamma_chain");
                let mut found = false;
                if let AtomView::Fun(f) = a {
                    if f.get_symbol() == gamma_chain {
                        let mut args = f.iter().collect::<Vec<_>>();
                        if args.len() >= 4 {
                            for i in 0..args.len().saturating_sub(3) {
                                // println!("{}", args[i]);
                                // println!("{}?{}", args[i], args[i + 1]);
                                if args[i] > args[i + 1] {
                                    // println!("{}>{}", args[i], args[i + 1]);
                                    args.swap(i, i + 1);
                                    let swapped =
                                        FunctionBuilder::new(gamma_chain).add_args(&args).finish();
                                    let mu = args.remove(i);
                                    let nu = args.remove(i);
                                    let metric = function!(ETS.metric, mu, nu)
                                        * 2
                                        * FunctionBuilder::new(gamma_chain)
                                            .add_args(&args)
                                            .finish();
                                    *c = metric - swapped;
                                    // println!("{}->{}", a, c);
                                    return true;
                                }
                            }
                        } else {
                            return false;
                        }
                    }
                }
                found
            })
            .replace_all_multiple(&reps);
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
                // println!("{arg}");
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
                        sum = sum + metric * sign * Atom::new_num(4);
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
        (function!(ETS.id, GS.a_, GS.a_), Atom::new_num(4)),
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

pub fn to_dots(atom: &Atom) -> Atom {
    fn mink(wildcard: Symbol, dim: Symbol) -> Atom {
        Minkowski::rep(dim).pattern(Atom::new_var(wildcard))
    }

    let reps = vec![
        (
            function!(ETS.metric, GS.a_, GS.b_).pow(Atom::new_num(2)),
            Atom::new_var(GS.dim),
        ),
        (
            function!(GS.f_, GS.a___, mink(GS.a_, GS.d_))
                * function!(GS.g_, GS.b___, mink(GS.a_, GS.d_)),
            function!(
                DIS_SYMBOLS.dot,
                function!(GS.f_, GS.a___),
                function!(GS.g_, GS.b___)
            ),
        ),
        (
            function!(GS.f_, GS.a___, mink(GS.a_, GS.d_)).pow(Atom::new_num(2)),
            function!(
                DIS_SYMBOLS.dot,
                function!(GS.f_, GS.a___),
                function!(GS.f_, GS.a___)
            ),
        ),
        // (FunctionBuilder::new(GS.f_).finish(), Atom::new_var(GS.f_)),//cannot pattern match empty function like this
        // (Atom::parse("f_()").unwrap(), Atom::new_var(GS.f_)),//Or like this
    ]
    .into_iter()
    .map(|(a, b)| Replacement::new(a.to_pattern(), b.to_pattern()))
    .collect::<Vec<_>>();

    atom.replace_all_multiple_repeat(&reps)
}

#[cfg(test)]
mod test {
    use std::sync::Arc;

    use libc::GS;
    use spenso::{shadowing::ETS, symbolica_utils::SerializableAtom};
    use symbolica::{
        atom::{Atom, AtomCore},
        domains::{integer::Z, rational::Q, SelfRing},
        id::Replacement,
        poly::Variable,
        printer::{PrintOptions, PrintState},
        symb,
    };

    use crate::DIS_SYMBOLS;

    use super::gamma_simplify_impl;

    #[test]
    fn gamma_alg() {
        let g = ETS.gamma;

        let expr: SerializableAtom = gamma_simplify_impl(SerializableAtom::from(
            Atom::parse("gamma_chain(mink(4,0),mink(4,0),b(1),b(2))").unwrap(),
        ));
        assert_eq!(
            expr.0,
            Atom::parse("dim*id(b(1),b(2))").unwrap(),
            "got {}",
            expr.0
        );

        let expr: SerializableAtom = gamma_simplify_impl(SerializableAtom::from(
            Atom::parse("p(mink(4,nu1))*(p(mink(4,nu3))+q(mink(4,nu3)))*gamma_chain(mink(4,nu1),mink(4,mu),mink(4,nu3),mink(4,nu),b(1),b(1))")
                .unwrap(),
        ));
        assert_eq!(
            expr.0,
            Atom::parse("-4*Metric(mink(4,mu),mink(4,nu))*p(mink(4,nu1))^2+8*p(mink(4,mu))*p(mink(4,nu))+4*p(mink(4,mu))*q(mink(4,nu))+4*p(mink(4,nu))*q(mink(4,mu))-4*Metric(mink(4,mu),mink(4,nu))*p(mink(4,nu1))*q(mink(4,nu1))").unwrap(),
            "got {}",
            expr.0
        );

        let expr: SerializableAtom = gamma_simplify_impl(SerializableAtom::from(
            Atom::parse("(Metric(mink(4,1), mink(4,2)) Metric(mink(4,3), mink(4,4)) Metric(mink(4,5), mink(4,6)) -
                Metric(mink(4,1), mink(4,3)) Metric(mink(4,2), mink(4,6)) Metric(mink(4,5), mink(4,4))) (Metric(mink(4,1), mink(4,2)) Metric(mink(4,3), mink(4,4)) -
                Metric(mink(4,1), mink(4,3)) Metric(mink(4,2), mink(4,4))) Metric(mink(4,5), mink(4,6))")
                .unwrap(),
        ));
        assert_eq!(expr.0, Atom::parse("-dim+dim^3").unwrap(), "got {}", expr.0);

        let expr: SerializableAtom = gamma_simplify_impl(SerializableAtom::from(
            Atom::parse("p(mink(4,nu1))*(p(mink(4,nu3))+q(mink(4,nu3)))*gamma_chain(mink(4,nu1),mink(4,mu),mink(4,nu),mink(4,nu3),b(1),b(1))")
                .unwrap(),
        ));
        assert_eq!(expr.0, Atom::parse("4*Metric(mink(4,mu),mink(4,nu))*p(mink(4,nu1))^2+4*p(mink(4,mu))*q(mink(4,nu))-4*q(mink(4,mu))*p(mink(4,nu))+4*Metric(mink(4,mu),mink(4,nu))*p(mink(4,nu1))*q(mink(4,nu1))").unwrap(), "got {}", expr.0);

        let expr: SerializableAtom = gamma_simplify_impl(SerializableAtom::from(
            Atom::parse("p(mink(4,nu1))*(p(mink(4,nu3))+q(mink(4,nu3)))*gamma_chain(mink(4,nu1),mink(4,nu),mink(4,nu),mink(4,nu3),b(1),b(1))")
                .unwrap(),
        ));
        assert_eq!(
            expr.0,
            Atom::parse("4*dim*p(mink(4,nu1))^2+4*dim*p(mink(4,nu1))*q(mink(4,nu1))").unwrap(),
            "got {}",
            expr.0
        );

        let expr: SerializableAtom = gamma_simplify_impl(SerializableAtom::from(
            Atom::parse("p(mink(4,nu1))*(p(mink(4,nu3))+q(mink(4,nu3)))*gamma_chain(mink(4,nu1),mink(4,nu),mink(4,nu3),mink(4,nu),b(1),b(1))")
                .unwrap(),
        ));
        assert_eq!(
            expr.0,
            Atom::parse("8*p(mink(4,nu1))^2-4*dim*p(mink(4,nu1))^2+8*p(mink(4,nu1))*q(mink(4,nu1))-4*dim*p(mink(4,nu1))*q(mink(4,nu1))").unwrap(),
            "got {}",
            expr.0
        );

        let expr = crate::gamma::to_dots(& gamma_simplify_impl(SerializableAtom::from(
            Atom::parse("p(mink(4,nu1))*q(mink(4,nu2))*(p(mink(4,nu3))+q(mink(4,nu3)))*q(mink(4,nu4))*gamma_chain(mink(4,nu1),mink(4,nu4),mink(4,nu3),mink(4,nu2),b(1),b(1))")
                .unwrap(),
        )).0);
        assert_eq!(
            expr,
            Atom::parse("8*dot(p(),q())^2-4*dot(p(),p())*dot(q(),q())+4*dot(p(),q())*dot(q(),q())")
                .unwrap(),
            "got {}",
            expr
        );

        let expr = crate::gamma::to_dots(
            &gamma_simplify_impl(SerializableAtom::from(
                Atom::parse("gamma_chain(mink(4,mu),mink(4,nu),mink(4,mu),mink(4,nu),b(1),b(2))")
                    .unwrap(),
            ))
            .0,
        );
        assert_eq!(
            expr,
            Atom::parse("2*dim*id(b(1),b(2))-dim^2*id(b(1),b(2))").unwrap(),
            "got {}",
            expr
        );
    }

    #[test]
    fn num() {
        let g = ETS.gamma;
        let expr = symbolica::atom::Atom::parse(
            // "id(mink(4,0),mink(4,5))*id(mink(4,1),mink(4,4))*γ(mink(4,2),bis(4,3),bis(4,2))*γ(mink(4,3),bis(4,5),bis(4,4))*γ(mink(4,4),bis(4,7),bis(4,6))*γ(mink(4,5),bis(4,9),bis(4,8))*γ(mink(4,21),bis(4,6),bis(4,3))*γ(mink(4,22),bis(4,2),bis(4,9))*γ(mink(4,23),bis(4,4),bis(4,7))*γ(mink(4,24),bis(4,8),bis(4,5))*Metric(mink(4,2),mink(4,3))*p(mink(4,0))*p(mink(4,1))*Q(5,mink(4,21))*Q(6,mink(4,22))*Q(7,mink(4,23))*Q(8,mink(4,24))",
        "id(mink(4,0),mink(4,5))*id(mink(4,1),mink(4,4))*γ(mink(4,2),bis(4,3),bis(4,2))*γ(mink(4,3),bis(4,5),bis(4,4))*γ(mink(4,4),bis(4,7),bis(4,6))*γ(mink(4,5),bis(4,9),bis(4,8))*γ(mink(4,21),bis(4,6),bis(4,3))*γ(mink(4,22),bis(4,2),bis(4,9))*γ(mink(4,23),bis(4,4),bis(4,7))*γ(mink(4,24),bis(4,8),bis(4,5))*Metric(mink(4,0),mink(4,1))*Metric(mink(4,2),mink(4,3))*Q(5,mink(4,21))*Q(6,mink(4,22))*Q(7,mink(4,23))*Q(8,mink(4,24))"
        )
        .unwrap();

        // -1/9*𝑖*ee^2*G^2*phat^-4*id(mink(4,0),mink(4,5))*id(mink(4,1),mink(4,4))*γ(mink(4,2),bis(4,3),bis(4,2))*γ(mink(4,3),bis(4,5),bis(4,4))*γ(mink(4,4),bis(4,7),bis(4,6))*γ(mink(4,5),bis(4,9),bis(4,8))*γ(mink(4,21),bis(4,6),bis(4,3))*γ(mink(4,22),bis(4,2),bis(4,9))*γ(mink(4,23),bis(4,4),bis(4,7))*γ(mink(4,24),bis(4,8),bis(4,5))*Metric(mink(4,2),mink(4,3))*p(mink(4,0))*p(mink(4,1))*Q(5,mink(4,21))*Q(6,mink(4,22))*Q(7,mink(4,23))*Q(8,mink(4,24))*dot(p,q)
        // -1/9*𝑖*ee^2*G^2*phat^-2*(dim-2)^-1*id(mink(4,0),mink(4,5))*id(mink(4,1),mink(4,4))*γ(mink(4,2),bis(4,3),bis(4,2))*γ(mink(4,3),bis(4,5),bis(4,4))*γ(mink(4,4),bis(4,7),bis(4,6))*γ(mink(4,5),bis(4,9),bis(4,8))*γ(mink(4,21),bis(4,6),bis(4,3))*γ(mink(4,22),bis(4,2),bis(4,9))*γ(mink(4,23),bis(4,4),bis(4,7))*γ(mink(4,24),bis(4,8),bis(4,5))*Metric(mink(4,0),mink(4,1))*Metric(mink(4,2),mink(4,3))*Q(5,mink(4,21))*Q(6,mink(4,22))*Q(7,mink(4,23))*Q(8,mink(4,24))*dot(p,q)
        // +1/9*𝑖*ee^2*G^2*phat^-4*(dim-2)^-1*id(mink(4,0),mink(4,5))*id(mink(4,1),mink(4,4))*γ(mink(4,2),bis(4,3),bis(4,2))*γ(mink(4,3),bis(4,5),bis(4,4))*γ(mink(4,4),bis(4,7),bis(4,6))*γ(mink(4,5),bis(4,9),bis(4,8))*γ(mink(4,21),bis(4,6),bis(4,3))*γ(mink(4,22),bis(4,2),bis(4,9))*γ(mink(4,23),bis(4,4),bis(4,7))*γ(mink(4,24),bis(4,8),bis(4,5))*Metric(mink(4,2),mink(4,3))*p(mink(4,0))*p(mink(4,1))*Q(5,mink(4,21))*Q(6,mink(4,22))*Q(7,mink(4,23))*Q(8,mink(4,24))*dot(p,q)
        println!(
            "{}",
            expr.expand().printer(PrintOptions {
                terms_on_new_line: true,
                ..Default::default()
            })
        );

        let expr: SerializableAtom = gamma_simplify_impl(SerializableAtom::from(expr));
        println!(
            "{}",
            expr.0.expand().factor().printer(PrintOptions {
                terms_on_new_line: true,
                ..Default::default()
            })
        );
    }

    #[test]
    fn se2f2() {
        let dot = DIS_SYMBOLS.dot;
        let expr = Atom::parse(" G^-2*eq^-2
        /I 1/2  (-TF+Nc^2 TF)*phat^2*dot[q,q] (16 G^2 phat^-4 eq^2 I *(dot[p,p]-2 dot[p,k[3]]) (dot[p,q]+dot[p,k[3]]) dot[p,q] dot[k[3],k[3]]-32 G^2 phat^-4 eq^2 I *(dot[p,q]+dot[p,k[3]]) (dot[p,k[3]]-2 dot[k[3],k[3]]) dot[p,q] dot[p,k[3]]+16 G^2 phat^-4 eq^2 I *(dot[p,k[3]]-2 dot[k[3],k[3]]) (dot[q,k[3]]+dot[k[3],k[3]]) dot[p,p] dot[p,q]-8 G^2 phat^-4 eq^2 I *(dot[p,q]+dot[p,k[3]]-2 dot[q,k[3]]-2 dot[k[3],k[3]]) dot[p,p] dot[p,q] dot[k[3],k[3]]-32 G^2 phat^-2 eq^2 I *(dim-2)^-1 (dot[p,k[3]]-2 dot[k[3],k[3]]) (dot[q,k[3]]+dot[k[3],k[3]]) dot[p,q]+16 G^2 phat^-2 eq^2 I *(dim-2)^-1 (dot[p,q]+dot[p,k[3]]-2 dot[q,k[3]]-2 dot[k[3],k[3]]) dot[p,q] dot[k[3],k[3]]-8 G^2 dim phat^-4 eq^2 I *(dot[p,p]-2 dot[p,k[3]]) (dot[p,q]+dot[p,k[3]]) dot[p,q] dot[k[3],k[3]]+16 G^2 dim phat^-4 eq^2 I *(dot[p,q]+dot[p,k[3]]) (dot[p,k[3]]-2 dot[k[3],k[3]]) dot[p,q] dot[p,k[3]]-8 G^2 dim phat^-4 eq^2 I *(dot[p,k[3]]-2 dot[k[3],k[3]]) (dot[q,k[3]]+dot[k[3],k[3]]) dot[p,p] dot[p,q]+4 G^2 dim phat^-4 eq^2 I *(dot[p,q]+dot[p,k[3]]-2 dot[q,k[3]]-2 dot[k[3],k[3]]) dot[p,p] dot[p,q] dot[k[3],k[3]]+32 G^2 dim phat^-2 eq^2 I *(dim-2)^-1 (dot[p,k[3]]-2 dot[k[3],k[3]]) (dot[q,k[3]]+dot[k[3],k[3]]) dot[p,q]-16 G^2 dim phat^-2 eq^2 I *(dim-2)^-1 (dot[p,q]+dot[p,k[3]]-2 dot[q,k[3]]-2 dot[k[3],k[3]]) dot[p,q] dot[k[3],k[3]]-8 G^2 dim^2 phat^-2 eq^2 I *(dim-2)^-1 (dot[p,k[3]]-2 dot[k[3],k[3]]) (dot[q,k[3]]+dot[k[3],k[3]]) dot[p,q]+4 G^2 dim^2 phat^-2 eq^2 I *(dim-2)^-1 (dot[p,q]+dot[p,k[3]]-2 dot[q,k[3]]-2 dot[k[3],k[3]]) dot[p,q] dot[k[3],k[3]]-16 G^2 phat^-4 eq^2 I *(dim-2)^-1 (dot[p,p]-2 dot[p,k[3]]) (dot[p,q]+dot[p,k[3]]) dot[p,q] dot[k[3],k[3]]+32 G^2 phat^-4 eq^2 I *(dim-2)^-1 (dot[p,q]+dot[p,k[3]]) (dot[p,k[3]]-2 dot[k[3],k[3]]) dot[p,q] dot[p,k[3]]-16 G^2 phat^-4 eq^2 I *(dim-2)^-1 (dot[p,k[3]]-2 dot[k[3],k[3]]) (dot[q,k[3]]+dot[k[3],k[3]]) dot[p,p] dot[p,q]+8 G^2 phat^-4 eq^2 I *(dim-2)^-1 (dot[p,q]+dot[p,k[3]]-2 dot[q,k[3]]-2 dot[k[3],k[3]]) dot[p,p] dot[p,q] dot[k[3],k[3]]+8 G^2 dim phat^-4 eq^2 I *(dim-2)^-1 (dot[p,p]-2 dot[p,k[3]]) (dot[p,q]+dot[p,k[3]]) dot[p,q] dot[k[3],k[3]]-16 G^2 dim phat^-4 eq^2 I *(dim-2)^-1 (dot[p,q]+dot[p,k[3]]) (dot[p,k[3]]-2 dot[k[3],k[3]]) dot[p,q] dot[p,k[3]]+8 G^2 dim phat^-4 eq^2 I *(dim-2)^-1 (dot[p,k[3]]-2 dot[k[3],k[3]]) (dot[q,k[3]]+dot[k[3],k[3]]) dot[p,p] dot[p,q]-4 G^2 dim phat^-4 eq^2 I *(dim-2)^-1 (dot[p,q]+dot[p,k[3]]-2 dot[q,k[3]]-2 dot[k[3],k[3]]) dot[p,p] dot[p,q] dot[k[3],k[3]])").unwrap();

        println!(
            "{}",
            expr.expand().printer(PrintOptions {
                terms_on_new_line: true,
                ..Default::default()
            })
        );

        let exprzeno = Atom::parse("I*(-4*eq^2*g^2*TF*dot[p, q]*(dot[k, k]^2*dot[q, q]*(dot[p, q]^2 - dot[p, p]*dot[q, q]) + 2*dot[k, p]*(-2*(-1 + d)*dot[k, q]^2*dot[p, q]^2 - 2*(-1 + d)*dot[k, p]^2*dot[q, q]^2 + dot[k, q]*dot[q, q]*(4*(-1 + d)*dot[k, p]*dot[p, q] - dot[p, q]^2 + dot[p, p]*dot[q, q])) + dot[k, k]*(2*(-1 + d)*dot[k, q]^2*dot[p, q]^2 + dot[k, q]*(2*(-1 + d)*dot[p, q]^3 - 2*(-1 + d)*(2*dot[k, p] + dot[p, p])*dot[p, q]*dot[q, q] + dot[p, q]^2*dot[q, q] - dot[p, p]*dot[q, q]^2) + dot[q, q]*(dot[p, q]^3 + 2*(-1 + d)*dot[k, p]^2*dot[q, q] - dot[p, p]*dot[p, q]*dot[q, q] - (-1 + 2*d)*dot[k, p]*(dot[p, q]^2 - dot[p, p]*dot[q, q])))))/((-2 + d))").unwrap();

        let reps = [
            ("d", "dim"),
            ("g", "G"),
            ("TF", "Nc^2-1"),
            // ("dot[p,q]", "(phat^2-dot[p,p])*dot[q,q]"),
        ]
        .iter()
        .map(|(a, b)| {
            Replacement::new(
                Atom::parse(a).unwrap().to_pattern(),
                Atom::parse(b).unwrap().to_pattern(),
            )
        })
        .collect::<Vec<_>>();
        println!(
            "zeno {}",
            exprzeno
                .replace_all_multiple(&reps)
                .expand()
                .printer(PrintOptions {
                    terms_on_new_line: true,
                    ..Default::default()
                })
        );

        let repsmine = [
            // ("dot[p,q]", "(phat^2-dot[p,p])*dot[q,q]"),
            //
            ("phat^-2", "dot[q,q]/(dot[p,p]-dot[p,q]*dot[p,q])"),
            // ("phat^-4", "(dot[p,p]-dot[p,q]*dot[p,q]/dot[q,q])^-2"),
            ("k(3)", "k"),
            ("TF", "Nc^2-1"),
        ]
        .iter()
        .map(|(a, b)| {
            Replacement::new(
                Atom::parse(a).unwrap().to_pattern(),
                Atom::parse(b).unwrap().to_pattern(),
            )
        })
        .collect::<Vec<_>>();

        let varmap = Arc::new(vec![
            Atom::parse("dot[p,p]").unwrap().into(),
            Atom::parse("dot[p,q]").unwrap().into(),
            Atom::parse("dot[q,q]").unwrap().into(),
            Atom::parse("dot[k,p]").unwrap().into(),
            Atom::parse("dot[k,q]").unwrap().into(),
            Atom::parse("dot[k,k]").unwrap().into(),
        ]);

        let a = expr
            .expand()
            .replace_all_multiple(&repsmine)
            .expand()
            .to_rational_polynomial::<_, _, u8>(&Q, &Z, Some(varmap.clone()))
            .apart(1);

        for i in a {
            // let mut buf = String::new();
            // i.format(
            //     &PrintOptions {
            //         terms_on_new_line: true,
            //         ..Default::default()
            //     },
            //     PrintState::default(),
            //     &mut buf,
            // );

            let n = i
                .to_expression()
                .expand()
                .to_rational_polynomial::<_, _, u8>(&Q, &Z, Some(varmap.clone()))
                .apart(0);
            for j in n {
                println!("part:{}", j);
            }
        }

        // println!(
        //     "mine {}",
        //     expr.expand()
        //         .replace_all_multiple(&repsmine)
        //         .expand()
        //         .to_rational_polynomial::<_, _, u8>(&Q, &Z, Some(varmap))
        //         .apart() // .to_expression()
        //                  // .printer(PrintOptions {
        //                  //     terms_on_new_line: true,
        //                  //     ..Default::default()
        //                  // })
        // );

        // println!(
        //     "{:#}",
        //     (expr.replace_all_multiple(&repsmine) - exprzeno.replace_all_multiple(&reps))
        //         .to_rational_polynomial::<_, _, u8>(&Q, &Z, None)
        // );
    }
}
