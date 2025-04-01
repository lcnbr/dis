use std::{env, time::SystemTime};

use indexmap::IndexMap;
use log::{info, LevelFilter};

use crate::{
    gen::{chain_dis_generate, dis_cart_prod, dis_options, photon_self_energy_gen},
    load_generic_model, DisCutGraph, DisGraph, Pdg,
};

pub fn setup_logger() -> Result<(), fern::InitError> {
    let log_level = env::var("RUST_LOG").unwrap_or_else(|_| "info".to_string());

    // Parse it into a LevelFilter
    let level_filter = log_level
        .parse::<LevelFilter>()
        .unwrap_or(LevelFilter::Info);

    fern::Dispatch::new()
        .format(|out, message, record| {
            out.finish(format_args!(
                "//[{} {} {}] {}",
                humantime::format_rfc3339_seconds(SystemTime::now()),
                record.level(),
                record.target(),
                message
            ))
        })
        // .filter(|a| a.target() == "dis" || a.target() == "_gammaloop")
        .level(level_filter)
        .chain(std::io::stdout())
        // .chain(fern::log_file("output.log")?)
        .apply()?;
    Ok(())
}

#[test]
fn cut_content() {
    setup_logger().unwrap();

    let model = load_generic_model("sm_dis");
    let options = dis_options(
        &["d", "d~", "e-"],
        &[vec!["d", "e-"], vec!["d~", "e-"], vec!["g", "e-"]],
        1,
        &model,
    );

    let fs_diagrams: Vec<_> = chain_dis_generate(&[options], &model);

    for p in &fs_diagrams {
        let cuto = DisCutGraph::from_bare(p);
        let content = cuto.cut_content();
        println!("{}", cuto.loop_count());
        // println!("{}",);
        assert_eq!(
            content,
            vec![Pdg { pdg: -1 }, Pdg { pdg: 1 }, Pdg { pdg: 11 }]
        );
    }
}

pub struct DisComp {
    pub fsOg: Vec<usize>,
    pub cutsOg: Vec<usize>,
}

impl DisComp {
    pub fn new() -> Self {
        DisComp {
            fsOg: Vec::new(),
            cutsOg: Vec::new(),
        }
    }

    pub fn has_one_of_both(&self) -> bool {
        self.fsOg.len() == 1 && self.cutsOg.len() == 1
    }

    pub fn has_both(&self) -> bool {
        !self.fsOg.is_empty() && !self.cutsOg.is_empty()
    }

    pub fn only_fs(&self) -> bool {
        !self.fsOg.is_empty() && self.cutsOg.is_empty()
    }

    pub fn double_count(&self) -> bool {
        self.double_count_fs() || self.double_count_cuts()
    }

    pub fn double_count_fs(&self) -> bool {
        self.fsOg.len() > 1
    }

    pub fn double_count_cuts(&self) -> bool {
        self.cutsOg.len() > 1
    }

    pub fn only_cuts(&self) -> bool {
        self.fsOg.is_empty() && !self.cutsOg.is_empty()
    }

    pub fn add_fs(&mut self, fs: usize) {
        self.fsOg.push(fs);
    }

    pub fn add_cut(&mut self, cut: usize) {
        self.cutsOg.push(cut);
    }
}

#[test]
fn nnlo_classificaton() {
    setup_logger().unwrap();

    let model = load_generic_model("sm_dis");

    let options = dis_cart_prod(&["d", "d~", "g"], 2, &model);

    info!("Number of options: {}", options.len());

    // info!("Number of options: {}", options.len());
    let fs_diagrams: Vec<_> = chain_dis_generate(&options, &model);

    info!("Number of fs diagrams: {}", fs_diagrams.len());
    let mut fs_can: IndexMap<Vec<Pdg>, IndexMap<DisCutGraph, DisComp>> = IndexMap::new();
    let mut ogfs = Vec::new();
    let mut n_fs = 0;
    for p in &fs_diagrams {
        let cuto = DisCutGraph::from_bare(p);
        let id = ogfs.len();
        ogfs.push(cuto.clone());

        let electron_disconnects = cuto.electron_disconnects();
        if !electron_disconnects {
            n_fs += 1;
            // println!("//original\n{}", cuto);
            let cutc = cuto.clone().canonize();
            let content = cutc.cut_content();

            let entry = fs_can.entry(content);
            entry
                .or_insert_with(|| IndexMap::new())
                .entry(cutc)
                .or_insert_with(|| DisComp::new())
                .add_fs(id);
        }
    }

    println!("Number of fs: {}", n_fs);

    let self_energies = photon_self_energy_gen(3, &model);

    info!("Number of self-energies: {}", self_energies.len());
    info!("{}", self_energies.len());

    // let bar = ProgressBar::new(diagrams.len() as u64);
    let diagrams: Vec<_> = self_energies
        .into_iter()
        // .progress_with(bar)
        .map(|a| DisGraph::from_self_energy_bare(&a, &model))
        .collect::<Vec<_>>()
        .into_iter()
        .enumerate()
        .collect();

    info!("Now comparing");
    let mut n_cuts = 0;
    let mut ogcuts = Vec::new();
    diagrams.iter().for_each(|(_, d)| {
        let ifsplit = d.full_dis_filter_split();

        let all = ifsplit.collect_all_cuts(d);
        n_cuts += all.len();

        for h in all {
            let id = ogcuts.len();
            ogcuts.push(h.clone());
            let cut = h.clone().canonize();
            let content = cut.cut_content();

            let entry = fs_can.entry(content);
            entry
                .or_insert_with(|| IndexMap::new())
                .entry(cut)
                .or_insert_with(|| DisComp::new())
                .add_cut(id);
        }
        // bar.inc(1);
    });

    println!("Number of cuts: {}", n_cuts);

    for (content, diags) in fs_can {
        println!("Content: {:?}", content);
        let len = diags.len();
        println!("len:{len}");
        let n_same = diags
            .iter()
            .filter(|(_, comp)| comp.has_one_of_both())
            .count();
        let n_additional_fs = diags.iter().filter(|(_, comp)| comp.only_fs()).count();
        let n_additional_cut = diags.iter().filter(|(_, comp)| comp.only_cuts()).count();

        println!("Number of same: {}", n_same);
        println!("Number of additional fs: {}", n_additional_fs);
        println!("Number of additional cuts: {}", n_additional_cut);
    }
}

fn filter_match(
    fs: &str,
    cuts: &str,
) -> (
    IndexMap<Vec<Pdg>, IndexMap<DisCutGraph, DisComp>>,
    [Vec<DisCutGraph>; 2],
) {
    let mut fs_can = IndexMap::new();
    let ogfs = DisCutGraph::from_file_multiple(fs).unwrap();
    println!("Number of f: {}", ogfs.len());

    for (id, cuto) in ogfs.iter().enumerate() {
        let electron_disconnects = cuto.electron_disconnects();
        if !electron_disconnects {
            // println!("//original\n{}", cuto);
            let cutc = cuto.clone().canonize();
            let content = cutc.cut_content();

            let entry = fs_can.entry(content);
            entry
                .or_insert_with(|| IndexMap::new())
                .entry(cutc)
                .or_insert_with(|| DisComp::new())
                .add_fs(id);
        }
    }

    info!("Now comparing");
    let ogcuts = DisCutGraph::from_file_multiple(cuts).unwrap();
    println!("Number of cuts: {}", ogcuts.len());

    for (id, h) in ogcuts.iter().enumerate() {
        let cut = h.clone().canonize();
        let content = cut.cut_content();

        let entry = fs_can.entry(content);
        entry
            .or_insert_with(|| IndexMap::new())
            .entry(cut)
            .or_insert_with(|| DisComp::new())
            .add_cut(id);
    }
    // bar.inc(1);
    return (fs_can, [ogfs, ogcuts]);
}

fn assert_fs_can(fs_can: IndexMap<Vec<Pdg>, IndexMap<DisCutGraph, DisComp>>) {
    for (content, diags) in fs_can {
        println!("Content: {:?}", content);
        let len = diags.len();
        println!("len:{len}");
        let n_same = diags
            .iter()
            .filter(|(_, comp)| comp.has_one_of_both())
            .count();
        let n_additional_fs = diags.iter().filter(|(_, comp)| comp.only_fs()).count();
        let n_additional_cut = diags.iter().filter(|(_, comp)| comp.only_cuts()).count();

        println!("Number of same: {}", n_same);
        assert_eq!(n_additional_fs, 0);
        assert_eq!(n_additional_cut, 0);
    }
}

fn fs_generate(loop_count: usize) -> Vec<DisCutGraph> {
    let model = load_generic_model("sm_dis");

    let options = dis_cart_prod(&["d", "d~", "g"], loop_count, &model);

    info!("Number of options: {}", options.len());

    // info!("Number of options: {}", options.len());
    let fs_diagrams: Vec<_> = chain_dis_generate(&options, &model);

    info!("Number of fs diagrams: {}", fs_diagrams.len());

    let mut ogfs = Vec::new();

    for p in &fs_diagrams {
        let cuto = DisCutGraph::from_bare(p);
        ogfs.push(cuto);
    }
    ogfs
}

fn cut_generate(loop_count: usize) -> Vec<DisCutGraph> {
    let model = load_generic_model("sm_dis");

    let self_energies = photon_self_energy_gen(loop_count + 1, &model);

    info!("Number of self-energies: {}", self_energies.len());
    info!("{}", self_energies.len());

    // let bar = ProgressBar::new(diagrams.len() as u64);
    let diagrams: Vec<_> = self_energies
        .into_iter()
        // .progress_with(bar)
        .map(|a| DisGraph::from_self_energy_bare(&a, &model))
        .collect::<Vec<_>>()
        .into_iter()
        .enumerate()
        .collect();

    let mut ogcuts = Vec::new();
    let mut n_cuts = 0;
    diagrams.iter().for_each(|(_, d)| {
        let ifsplit = d.full_dis_filter_split();

        let all = ifsplit.collect_all_cuts(d);
        n_cuts += all.len();

        for h in all {
            ogcuts.push(h.clone());
        }
    });

    ogcuts
}

#[test]
fn save_nlo_fs() {
    setup_logger().unwrap();

    let fs_diagrams = fs_generate(1);

    DisCutGraph::serialize_multiple(&fs_diagrams, "nlo_fs.dot").unwrap();

    println!("Number of fs: {}", fs_diagrams.len());
}

#[test]
fn save_nlo_cut() {
    setup_logger().unwrap();

    let cut_diagrams = cut_generate(1);

    DisCutGraph::serialize_multiple(&cut_diagrams, "nlo_cut.dot").unwrap();

    println!("Number of cuts: {}", cut_diagrams.len());
}

#[test]
fn save_nnlo_fs() {
    setup_logger().unwrap();

    let fs_diagrams = fs_generate(2);

    DisCutGraph::serialize_multiple(&fs_diagrams, "nnlo_fs_1spect.dot").unwrap();

    println!("Number of fs: {}", fs_diagrams.len());
}

#[test]
fn save_nnlo_cut() {
    setup_logger().unwrap();

    let cut_diagrams = cut_generate(2);

    DisCutGraph::serialize_multiple(&cut_diagrams, "nnlo_cut.dot").unwrap();

    println!("Number of cuts: {}", cut_diagrams.len());
}

#[test]
fn onenlo_filtered_match() {
    // setup_logger().unwrap();

    let (fs_can, [ogfs, ogcuts]) = filter_match("nlo_fs.dot", "nlo_cut.dot");

    assert_fs_can(fs_can);
}

#[test]
fn twonlo_filtered_match() {
    setup_logger().unwrap();

    let (fs_can, [ogfs, ogcuts]) = filter_match("nnlo_fs_1spect.dot", "nnlo_cut.dot");
    for (content, diags) in &fs_can {
        println!("Content: {:?}", content);
        let len = diags.len();
        println!("len:{len}");
        let n_same = diags
            .iter()
            .filter(|(_, comp)| comp.has_one_of_both())
            .count();
        let n_additional_fs = diags.iter().filter(|(_, comp)| comp.only_fs()).count();
        let n_additional_cut = diags.iter().filter(|(_, comp)| comp.only_cuts()).count();
        let n_double_count_fs = diags
            .iter()
            .filter(|(_, comp)| comp.double_count_fs())
            .count();
        let n_double_count_cut = diags
            .iter()
            .filter(|(_, comp)| comp.double_count_cuts())
            .count();

        println!("Number of same: {}", n_same);
        println!("Number of additional fs:{}", n_additional_fs);
        println!("Number of additional cuts:{}", n_additional_cut);
        println!("Number of double count cuts:{}", n_double_count_cut);
        println!("Number of double count fs:{}", n_double_count_fs);
    }

    let list = &fs_can[&vec![
        Pdg { pdg: -1 },
        Pdg { pdg: -1 },
        Pdg { pdg: -1 },
        Pdg { pdg: 11 },
    ]];

    for (l, v) in list {
        if !v.has_one_of_both() {
            println!("//canonical\n{}", l);

            println!("//fs");
            for k in &v.fsOg {
                println!("//{k}");
                println!("{}", ogfs[*k]);
            }
            println!("//cuts");
            for k in &v.cutsOg {
                println!("//{k}");
                println!("{}", ogcuts[*k]);
            }
        }
    }
}
