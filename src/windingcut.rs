use super::*;
use std::fmt::Write;

impl NumberedCut {
    pub fn print_embedding(
        &self,
        graph: &DisGraph,
        basis: &[MySignedCycle],
        // flip_sym: bool,
    ) -> String {
        let mut basid = 0;
        let mut output = String::new();

        for b in basis {
            let mut winding = 0;
            let winding_number = self.winding_explicit(&b, graph);
            for n in &winding_number {
                write!(output, "{}:{},", n.0 .0, n.1);
                winding += n.1;
            }

            writeln!(output, "={}", winding);
        }

        output
    }
    pub fn single_winding(&self) -> bool {
        self.numbering.is_empty()
    }

    pub fn iter_edges<'a, E, V, N: NodeStorageOps<NodeData = V>>(
        &'a self,
        graph: &'a HedgeGraph<E, V, N>,
    ) -> impl Iterator<Item = (u8, Orientation, EdgeData<&'a E>)> {
        self.cut.left.included_iter().map(|i| {
            (
                self.hedge_val(i),
                self.cut.orientation(i, graph),
                graph.get_edge_data_full(i),
            )
        })
    }

    pub fn iter_left(&self) -> impl Iterator<Item = (u8, Hedge)> + '_ {
        self.cut.iter_left_hedges().map(|h| (self.hedge_val(h), h))
    }

    pub fn from_cut(cut: OrientedCut, max: u8) -> Vec<NumberedCut> {
        let mut numberings = vec![NumberedCut {
            cut: cut.clone(),
            numbering: AHashMap::new(),
        }];

        for additional in 1..=max {
            for hs in cut
                .iter_left_hedges()
                .combinations_with_replacement(additional as usize)
            {
                let mut numbering = AHashMap::new();

                for h in hs {
                    numbering.entry(h).and_modify(|a| *a += 1).or_insert(2);
                }

                numberings.push(NumberedCut {
                    numbering,
                    cut: cut.clone(),
                })
            }
        }
        numberings
    }

    fn cut_val(&self, hedge: Hedge) -> i32 {
        SignOrZero::from(self.cut.relative_orientation(hedge)) * (self.hedge_val(hedge) as i32)
    }

    fn hedge_val(&self, hedge: Hedge) -> u8 {
        *(self.numbering.get(&hedge).unwrap_or(&1u8))
    }

    pub fn winding(&self, cycle: &MySignedCycle, graph: &DisGraph) -> i32 {
        let mut winding_number = 0;
        // println!("cycle: {:?}", cycle);
        for h in cycle.filter.included_iter() {
            let val = (self.hedge_val(h) * self.hedge_val(graph.graph.inv(h))) as i32;
            let a = SignOrZero::from(self.cut.relative_orientation(h)) * val;
            winding_number += a;
            // let b = SignOrZero::from(self.cut.relative_orientation(graph.graph.inv(h))) * val;
            // println!("a: {}, b: {}", a, b);
            // winding_number += b;
        }
        winding_number
    }

    pub fn winding_explicit(&self, cycle: &MySignedCycle, graph: &DisGraph) -> Vec<(Hedge, i32)> {
        let mut winding_number = vec![];

        // println!("cycle: {:?}", cycle);
        for h in cycle.filter.included_iter() {
            let val = (self.hedge_val(h) * self.hedge_val(graph.graph.inv(h))) as i32;
            let a = SignOrZero::from(self.cut.relative_orientation(h)) * val;
            winding_number.push((h, a));
            // let b = SignOrZero::from(self.cut.relative_orientation(graph.graph.inv(h))) * val;
            // println!("a: {}, b: {}", a, b);
            // winding_number.push((graph.graph.inv(h), b));
        }
        winding_number
    }
}
