#set page(width: 35cm, height: auto)
#import "@preview/cetz:0.3.1"
            #{
let cols = (30%,30%,30%)

let node(pos)=cetz.draw.circle(pos,radius:0.02,fill: black)
let stroke = 0.7pt
let amplitude = 0.051
let arrow-scale = 0.8
let segment-length = 0.0521
let edge(..points,decoration:"",angle:0deg)={
    if decoration == "coil"{
    cetz.decorations.coil(cetz.draw.hobby(..points),amplitude:amplitude,stroke:stroke,align:"MID")
    } else if decoration == "wave" {
        cetz.decorations.wave(cetz.draw.hobby(..points),amplitude:amplitude,stroke:stroke)
    }  else if decoration == "arrow"{
        let points = points.pos()
        if points.len()==2{
          let center = (0.5*(points.at(0).at(0)+points.at(1).at(0)),0.5*(points.at(0).at(1)+points.at(1).at(1)))
          cetz.draw.hobby(..points,stroke:stroke)
          cetz.draw.mark(center,angle,symbol: ">", fill: black,anchor: "center",scale:arrow-scale)
        } else {
          let (first,center,..other)=points
          cetz.draw.hobby(first,center,..other,stroke:stroke)
            cetz.draw.mark(center,angle,symbol: ">", fill: black,anchor: "center",scale:arrow-scale)
        }

    }else {
            cetz.draw.hobby(..points,stroke:stroke)
    }
}
let d00=cetz.canvas(length:50%,{
let node0= (pos:(-0.80, -0.19))
node(node0.pos)
let node1= (pos:(-0.78, 0.36))
node(node1.pos)
let node2= (pos:(0.72, 0.32))
node(node2.pos)
let node3= (pos:(0.70, -0.23))
node(node3.pos)
let node4= (pos:(-0.05, -0.30))
node(node4.pos)
let node5= (pos:(-0.03, 0.42))
node(node5.pos)
edge(node1.pos,(-1.00, 0.09),node0.pos,decoration:"arrow",angle:7.82rad)
cetz.draw.content((-1.12, 0.10),angle:7.82rad,[k(0)+k(1)])
cetz.draw.hobby((-0.88, 0.39),(-1.06, 0.09),(-0.90, -0.21),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.70, 0.08),node1.pos,decoration:"arrow",angle:4.68rad)
cetz.draw.content((-0.58, 0.08),angle:4.68rad,[k(0)])
cetz.draw.hobby((-0.71, -0.17),(-0.64, 0.08),(-0.70, 0.34),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.44, -0.33),node4.pos,decoration:"wave",angle:6.13rad)
cetz.draw.content((-0.46, -0.45),angle:6.13rad,[k(1)])
cetz.draw.hobby((-0.76, -0.28),(-0.45, -0.39),(-0.11, -0.38),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(-0.41, 0.48),node1.pos,decoration:"wave",angle:3.22rad)
cetz.draw.content((-0.42, 0.60),angle:3.22rad,[k(1)])
cetz.draw.hobby((-0.09, 0.51),(-0.42, 0.54),(-0.74, 0.45),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.92, 0.04),node2.pos,decoration:"arrow",angle:4.69rad)
cetz.draw.content((1.04, 0.03),angle:4.69rad,[k(2)])
cetz.draw.hobby((0.80, -0.26),(0.98, 0.03),(0.82, 0.34),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.62, 0.05),node3.pos,decoration:"coil",angle:4.68rad)
cetz.draw.content((0.50, 0.05),angle:4.68rad,[k(2)+k(3)])
cetz.draw.hobby((0.63, 0.30),(0.56, 0.05),(0.62, -0.21),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.36, 0.46),node2.pos,decoration:"arrow",angle:-0.14rad)
cetz.draw.content((0.37, 0.58),angle:-0.14rad,[k(3)])
cetz.draw.hobby((0.03, 0.50),(0.36, 0.52),(0.68, 0.41),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.34, -0.35),node4.pos,decoration:"arrow",angle:-3.05rad)
cetz.draw.content((0.35, -0.47),angle:-3.05rad,[k(3)])
cetz.draw.hobby((0.66, -0.33),(0.34, -0.41),(0.01, -0.38),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(-0.04, 0.06),node5.pos,decoration:"arrow",angle:1.54rad)
cetz.draw.content((0.08, 0.06),angle:1.54rad,[k(1)+k(3)])
cetz.draw.hobby((0.01, -0.23),(0.02, 0.06),(0.03, 0.35),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.59, -0.64))
node(node0.pos)
let node1= (pos:(-0.89, 0.11))
node(node1.pos)
let node2= (pos:(0.97, 0.42))
node(node2.pos)
let node3= (pos:(0.29, 0.15))
node(node3.pos)
let node4= (pos:(0.52, -0.61))
node(node4.pos)
let node5= (pos:(-0.07, 0.85))
node(node5.pos)
edge(node1.pos,(-0.64, -0.22),node0.pos,decoration:"arrow",angle:1.96rad)
cetz.draw.content((-0.53, -0.17),angle:1.96rad,[k(0)+k(1)])
cetz.draw.hobby((-0.79, 0.10),(-0.58, -0.20),(-0.52, -0.55),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-1.00, -0.37),node1.pos,decoration:"arrow",angle:5.10rad)
cetz.draw.content((-1.11, -0.41),angle:5.10rad,[k(0)])
cetz.draw.hobby((-0.71, -0.68),(-1.06, -0.39),(-1.01, 0.07),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.04, -0.75),node4.pos,decoration:"wave",angle:0.01rad)
cetz.draw.content((-0.04, -0.87),angle:0.01rad,[k(1)])
cetz.draw.hobby((-0.50, -0.74),(-0.03, -0.81),(0.44, -0.72),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(-0.57, 0.57),node1.pos,decoration:"wave",angle:3.88rad)
cetz.draw.content((-0.65, 0.66),angle:3.88rad,[k(1)])
cetz.draw.hobby((-0.20, 0.87),(-0.60, 0.62),(-0.90, 0.25),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.65, 0.29),node2.pos,decoration:"coil",angle:0.38rad)
cetz.draw.content((0.61, 0.41),angle:0.38rad,[k(2)])
cetz.draw.hobby((0.34, 0.23),(0.61, 0.34),(0.88, 0.45),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.91, -0.17),node4.pos,decoration:"arrow",angle:1.16rad)
cetz.draw.content((1.02, -0.22),angle:1.16rad,[k(2)+k(3)])
cetz.draw.hobby((1.05, 0.30),(0.97, -0.19),(0.66, -0.59),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.52, 0.80),node2.pos,decoration:"arrow",angle:2.74rad)
cetz.draw.content((0.57, 0.91),angle:2.74rad,[k(3)])
cetz.draw.hobby((0.04, 0.93),(0.54, 0.86),(0.95, 0.55),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.36, -0.27),node3.pos,decoration:"arrow",angle:5.02rad)
cetz.draw.content((0.25, -0.31),angle:5.02rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((0.43, -0.58),(0.30, -0.27),(0.24, 0.06),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.05, 0.49),node5.pos,decoration:"arrow",angle:5.17rad)
cetz.draw.content((-0.05, 0.44),angle:5.17rad,[k(1)+k(3)])
cetz.draw.hobby((0.19, 0.17),(0.01, 0.45),(-0.11, 0.76),stroke:stroke,mark: (end: ">"))
})
[
                            = d0
 overall factor: AutG(1)^-1*InternalFermionLoopSign(-1)*NumeratorIndependentSymmetryGrouping(2)*ExternalFermionOrderingSign(1)
                            
 symmetry group: 1]
grid(columns: cols,gutter: 20pt,box[#d00 ],)
pagebreak()
[
                            = d1
 overall factor: AutG(1)^-1*InternalFermionLoopSign(-1)*ExternalFermionOrderingSign(1)
                            
 symmetry group: 2]
grid(columns: cols,gutter: 20pt,box[#d10 ],)
pagebreak()
}