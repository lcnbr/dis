use std::fmt::format;

use dis::{CutGraph, DisCompVertex};
use libc::EDOM;
use linnet::{
    dot,
    dot_parser::{DotEdgeData, DotVertexData},
    half_edge::{
        involution::{EdgeIndex, Orientation},
        HedgeGraph,
    },
};
#[test]
pub fn works() {
    // HedgeGraph<(isize, Orientation, EdgeIndex), DisCompVertex>;
    let cut: HedgeGraph<DotEdgeData, DotVertexData> = dot!(
        digraph{
                  node [shape=circle,height=0.1,label=""];  overlap="scale"; layout="neato";

                  0 [nodetype = "i"];
                  1 [nodetype = "i"];
                  5 [nodetype = "i"];
                  4 [nodetype = "i"];
                  2 [nodetype = "i"];
                  3 [nodetype = "i"];
                ext0 [shape=none, label="",flow=source];
                ext1 [shape=none, label="",flow=sink];
                ext10 [shape=none, label="",flow=sink];
                ext11 [shape=none, label="",flow=source];
                ext14 [shape=none, label="",flow=sink];
                ext15 [shape=none, label="",flow=source];
                 ext15 -> 4[dir=back color="blue",pdg = 1, orient="Reversed",edgeid=4];
                 ext0 -> 0[dir=back color="blue",pdg = 11, orient="Reversed", edgeid=0];
                 ext1 -> 1[dir=forward color="red",pdg=11,orient="Reversed",edgeid=0];
                 ext10 -> 2[dir=none color="red",pdg = 21, orient="Default", edgeid=7];
                 ext11 -> 3[dir=none color="blue",pdg = 21, orient="Default", edgeid=7];
                 ext14 -> 3[ color="red",pdg = 1, orient="Reversed",edgeid=4];
                0 -> 1[ dir=back color="red:blue;0.5",pdg = 11,orient="Undirected", edgeid=0];
                0 -> 4[ dir=none color="red:blue;0.5",pdg = 22,orient="Undirected", edgeid=0];
                5 -> 1[ dir=none color="red:blue;0.5",pdg = 22,orient="Undirected", edgeid=0];
                3 -> 2[  color="red:blue;0.5",pdg = 1,orient="Undirected", edgeid=0];
                5 -> 2[ dir=back color="red:blue;0.5",pdg = 1,orient="Undirected", edgeid=0];
                4 -> 5[ dir=back color="red:blue;0.5",pdg = 1,orient="Undirected", edgeid=0];
                }
    )
    .unwrap();

    println!("{}", cut.dot_display(&cut.full_filter()));
    let cut = cut.map(
        |_, _, _, a| {
            let nodetype = &a.statements["nodetype"];
            if nodetype == "\"i\"" {
                DisCompVertex::Internal
            } else {
                panic!("Invalid node type {}", nodetype)
            }
        },
        |_, _, _, e| {
            e.map(|d| {
                let pdg: isize = d.statements["pdg"].parse().unwrap();
                let orient = match d.statements["orient"].as_str() {
                    "\"Default\"" => Orientation::Default,
                    "\"Reversed\"" => Orientation::Reversed,
                    "\"Undirected\"" => Orientation::Undirected,
                    a => panic!("Invalid orientation {}", a),
                };
                let edgeid: usize = d.statements["edgeid"].parse().unwrap();

                (pdg, orient, EdgeIndex::from(edgeid))
            })
        },
    );
    println!(
        "//OriginalCut:\n{}",
        cut.dot_impl(
            &cut.full_filter(),
            "",
            &|a| {
                let label = match a.1 {
                    Orientation::Default => format!("Default:{}", a.2),
                    Orientation::Reversed => format!("Reversed:{}", a.2),
                    Orientation::Undirected => "".to_string(),
                };
                Some(format!(
                    "pdg ={},orient={:?},edgeid={},label=\"{}\"",
                    a.0, a.1, a.2, label
                ))
            },
            &|b| { Some(format!("label = \"{}\"", b)) }
        )
    );

    let fs: HedgeGraph<DotEdgeData, DotVertexData> = dot!(
        digraph {
          node [shape=circle,height=0.1,label=""];  overlap="scale"; layout="neato";
         start=31;
          2 [nodetype="left", matchid=2];
          9 [nodetype="i"];
          1 [nodetype="left", matchid=1];
          10 [nodetype="i"];
          0 [nodetype="left",matchid=0];
          11 [nodetype="i"];
          7 [nodetype="i"];
          5 [nodetype="right",matchid =2];
          8 [nodetype="i"];
          4 [nodetype="right",matchid =1];
          3 [nodetype="right",matchid =0];
          6 [nodetype="i"];
        2 -> 9[ dir=forward color="red:blue;0.5",pdg=11];
        1 -> 10[ dir=forward color="red:blue;0.5",pdg=1];
        0 -> 11[ dir=none color="red:blue;0.5",pdg=21];
        7 -> 5[ dir=forward color="red:blue;0.5",pdg=11];
        8 -> 4[ dir=forward color="red:blue;0.5",pdg=1];
        10 -> 3[ dir=none color="red:blue;0.5",pdg=21];
        6 -> 8[ dir=forward color="red:blue;0.5",pdg=1];
        6 -> 9[ dir=none color="red:blue;0.5",pdg=22];
        11 -> 6[ dir=forward color="red:blue;0.5",pdg=1];
        7 -> 8[ dir=none color="red:blue;0.5",pdg=22];
        9 -> 7[ dir=forward color="red:blue;0.5",pdg=11];
        10 -> 11[ dir=forward color="red:blue;0.5",pdg=1];
        }
    )
    .unwrap();

    // println!("{}", fs.dot_display(&fs.full_filter()));
    let fs = CutGraph {
        graph: fs.map(
            |_, _, _, a| match a.statements["nodetype"].as_str() {
                "\"i\"" => DisCompVertex::Internal,
                "\"left\"" => {
                    let id: usize = a.statements["matchid"].parse().unwrap();
                    DisCompVertex::Left(EdgeIndex::from(id))
                }
                "\"right\"" => {
                    let id: usize = a.statements["matchid"].parse().unwrap();
                    DisCompVertex::Right(EdgeIndex::from(id))
                }
                a => panic!("Invalid node type {}", a),
            },
            |_, _, _, e| {
                e.map(|d| {
                    let pdg: isize = d.statements["pdg"].parse().unwrap();

                    pdg
                })
            },
        ),
    };
    println!("//OriginalFS: \n{}", fs);
    let cancut = CutGraph::from_hairy(cut.clone(), false).canonize();
    let canfs = fs.canonize();

    if cancut == canfs {
        println!("Are equal");
    } else {
        panic!("aaa");
        println!("Are not equal");

        println!("//CutGraph: \n{}", cancut);
        println!("//FS: \n{}", canfs);
    }
}

//works
pub fn main() {
    // HedgeGraph<(isize, Orientation, EdgeIndex), DisCompVertex>;
    let cut: HedgeGraph<DotEdgeData, DotVertexData> = dot!(
        digraph{
                         node [shape=circle,height=0.1,label=""];  overlap="scale"; layout="neato";

                         0 [nodetype = "i"];
                         1 [nodetype = "i"];
                         5 [nodetype = "i"];
                         4 [nodetype = "i"];
                         2 [nodetype = "i"];
                         3 [nodetype = "i"];
                       ext0 [shape=none, label="",flow=source];
                       ext1 [shape=none, label="",flow=sink];
                       ext10 [shape=none, label="",flow=sink];
                       ext11 [shape=none, label="",flow=source];
                       ext14 [shape=none, label="",flow=sink];
                       ext15 [shape=none, label="",flow=source];
                        ext15 -> 4[dir=back color="blue",pdg = 1, orient="Reversed",edgeid=4];
                        ext0 -> 0[ color="blue",pdg = 11, orient="Reversed", edgeid=0];
                        ext1 -> 1[dir=back color="red",pdg=11,orient="Reversed",edgeid=0];
                        ext10 -> 2[dir=none color="red",pdg = 21, orient="Default", edgeid=7];
                        ext11 -> 3[dir=none color="blue",pdg = 21, orient="Default", edgeid=7];
                        ext14 -> 3[ color="red",pdg = 1, orient="Reversed",edgeid=4];
                       0 -> 1[ color="red:blue;0.5",pdg = 11,orient="Undirected", edgeid=0];
                       0 -> 4[ dir=none color="red:blue;0.5",pdg = 22,orient="Undirected", edgeid=0];
                       5 -> 1[ dir=none color="red:blue;0.5",pdg = 22,orient="Undirected", edgeid=0];
                       3 -> 2[  color="red:blue;0.5",pdg = 1,orient="Undirected", edgeid=0];
                       5 -> 2[ dir=back color="red:blue;0.5",pdg = 1,orient="Undirected", edgeid=0];
                       4 -> 5[ dir=back color="red:blue;0.5",pdg = 1,orient="Undirected", edgeid=0];
                       }
    )
    .unwrap();

    println!("{}", cut.dot_display(&cut.full_filter()));
    let cut = cut.map(
        |_, _, _, a| {
            let nodetype = &a.statements["nodetype"];
            if nodetype == "\"i\"" {
                DisCompVertex::Internal
            } else {
                panic!("Invalid node type {}", nodetype)
            }
        },
        |_, _, _, e| {
            e.map(|d| {
                let pdg: isize = d.statements["pdg"].parse().unwrap();
                let orient = match d.statements["orient"].as_str() {
                    "\"Default\"" => Orientation::Default,
                    "\"Reversed\"" => Orientation::Reversed,
                    "\"Undirected\"" => Orientation::Undirected,
                    a => panic!("Invalid orientation {}", a),
                };
                let edgeid: usize = d.statements["edgeid"].parse().unwrap();

                (pdg, orient, EdgeIndex::from(edgeid))
            })
        },
    );
    println!(
        "//OriginalCut:\n{}",
        cut.dot_impl(
            &cut.full_filter(),
            "",
            &|a| {
                let label = match a.1 {
                    Orientation::Default => format!("Default:{}:{}", a.2, a.0),
                    Orientation::Reversed => format!("Reversed:{}:{}", a.2, a.0),
                    Orientation::Undirected => format!("{}", a.0),
                };
                Some(format!(
                    "pdg ={},orient={:?},edgeid={},label=\"{}\"",
                    a.0, a.1, a.2, label
                ))
            },
            &|b| { Some(format!("label = \"{}\"", b)) }
        )
    );

    let fs: HedgeGraph<DotEdgeData, DotVertexData> = dot!(
        digraph {
                  node [shape=circle,height=0.1,label=""];  overlap="scale"; layout="neato";
                 start=31;
                  2 [nodetype="left", matchid=2];
                  9 [nodetype="i"];
                  1 [nodetype="left", matchid=1];
                  10 [nodetype="i"];
                  0 [nodetype="left",matchid=0];
                  11 [nodetype="i"];
                  7 [nodetype="i"];
                  5 [nodetype="right",matchid =2];
                  8 [nodetype="i"];
                  4 [nodetype="right",matchid =1];
                  3 [nodetype="right",matchid =0];
                  6 [nodetype="i"];
                2 -> 9[ dir=back color="red:blue;0.5",pdg=11];
                1 -> 10[ dir=forward color="red:blue;0.5",pdg=1];
                0 -> 11[ dir=none color="red:blue;0.5",pdg=21];
                7 -> 5[ dir=back color="red:blue;0.5",pdg=11];
                8 -> 4[ dir=forward color="red:blue;0.5",pdg=1];
                10 -> 3[ dir=none color="red:blue;0.5",pdg=21];
                6 -> 8[ dir=forward color="red:blue;0.5",pdg=1];
                6 -> 9[ dir=none color="red:blue;0.5",pdg=22];
                11 -> 6[ dir=forward color="red:blue;0.5",pdg=1];
                7 -> 8[ dir=none color="red:blue;0.5",pdg=22];
                9 -> 7[ dir=back color="red:blue;0.5",pdg=11];
                10 -> 11[ dir=forward color="red:blue;0.5",pdg=1];
                }
    )
    .unwrap();

    // println!("{}", fs.dot_display(&fs.full_filter()));
    let fs = CutGraph {
        graph: fs.map(
            |_, _, _, a| match a.statements["nodetype"].as_str() {
                "\"i\"" => DisCompVertex::Internal,
                "\"left\"" => {
                    let id: usize = a.statements["matchid"].parse().unwrap();
                    DisCompVertex::Left(EdgeIndex::from(id))
                }
                "\"right\"" => {
                    let id: usize = a.statements["matchid"].parse().unwrap();
                    DisCompVertex::Right(EdgeIndex::from(id))
                }
                a => panic!("Invalid node type {}", a),
            },
            |_, _, _, e| {
                e.map(|d| {
                    let pdg: isize = d.statements["pdg"].parse().unwrap();

                    pdg
                })
            },
        ),
    };

    let cutcut = CutGraph::from_hairy(cut.clone(), false);
    println!("//Processed cut\n{}", cutcut);
    let cancut = cutcut.canonize();
    println!("//OriginalFS: \n{}", fs);
    let canfs = fs.canonize();

    if cancut == canfs {
        println!("Are equal");
    } else {
        println!("Are not equal");

        println!("//CutGraph: \n{}", cancut);
        println!("//FS: \n{}", canfs);
    }
}
