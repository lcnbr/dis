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
let node0= (pos:(-0.47, -0.84))
node(node0.pos)
let node1= (pos:(-0.86, -0.30))
node(node1.pos)
let node2= (pos:(0.60, 0.77))
node(node2.pos)
let node3= (pos:(0.99, 0.23))
node(node3.pos)
let node4= (pos:(0.32, -0.39))
node(node4.pos)
let node5= (pos:(-0.20, 0.32))
node(node5.pos)
edge(node1.pos,(-0.87, -0.72),node0.pos,decoration:"arrow",angle:8.48rad)
cetz.draw.content((-0.97, -0.79),angle:8.48rad,[k(0)+k(1)])
cetz.draw.hobby((-0.96, -0.35),(-0.92, -0.76),(-0.55, -0.92),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.58, -0.51),node1.pos,decoration:"arrow",angle:5.34rad)
cetz.draw.content((-0.48, -0.44),angle:5.34rad,[k(0)])
cetz.draw.hobby((-0.41, -0.76),(-0.53, -0.47),(-0.77, -0.27),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.02, -0.71),node4.pos,decoration:"wave",angle:0.52rad)
cetz.draw.content((0.04, -0.81),angle:0.52rad,[k(1)])
cetz.draw.hobby((-0.36, -0.89),(0.01, -0.76),(0.31, -0.50),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(-0.60, 0.08),node1.pos,decoration:"wave",angle:3.90rad)
cetz.draw.content((-0.68, 0.17),angle:3.90rad,[k(1)])
cetz.draw.hobby((-0.31, 0.34),(-0.64, 0.13),(-0.88, -0.19),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.71, 0.44),node2.pos,decoration:"arrow",angle:5.34rad)
cetz.draw.content((0.61, 0.37),angle:5.34rad,[k(2)])
cetz.draw.hobby((0.90, 0.20),(0.66, 0.40),(0.54, 0.69),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(1.00, 0.65),node3.pos,decoration:"coil",angle:-0.94rad)
cetz.draw.content((1.10, 0.72),angle:-0.94rad,[k(2)+k(3)])
cetz.draw.hobby((0.68, 0.85),(1.05, 0.68),(1.09, 0.28),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.15, 0.64),node2.pos,decoration:"arrow",angle:0.51rad)
cetz.draw.content((0.09, 0.74),angle:0.51rad,[k(3)])
cetz.draw.hobby((-0.18, 0.43),(0.12, 0.69),(0.49, 0.82),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.73, -0.16),node4.pos,decoration:"arrow",angle:-2.39rad)
cetz.draw.content((0.81, -0.24),angle:-2.39rad,[k(3)])
cetz.draw.hobby((1.01, 0.12),(0.77, -0.20),(0.43, -0.41),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.07, -0.04),node5.pos,decoration:"arrow",angle:2.20rad)
cetz.draw.content((0.16, 0.04),angle:2.20rad,[k(1)+k(3)])
cetz.draw.hobby((0.32, -0.28),(0.11, 0.00),(-0.09, 0.28),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.67, -0.59))
node(node0.pos)
let node1= (pos:(-0.85, 0.10))
node(node1.pos)
let node2= (pos:(0.80, 0.16))
node(node2.pos)
let node3= (pos:(0.18, -0.00))
node(node3.pos)
let node4= (pos:(0.30, -0.69))
node(node4.pos)
let node5= (pos:(-0.05, 0.65))
node(node5.pos)
edge(node1.pos,(-1.00, -0.31),node0.pos,decoration:"arrow",angle:8.11rad)
cetz.draw.content((-1.12, -0.34),angle:8.11rad,[k(0)+k(1)])
cetz.draw.hobby((-0.96, 0.08),(-1.06, -0.32),(-0.78, -0.62),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.67, -0.22),node1.pos,decoration:"arrow",angle:4.97rad)
cetz.draw.content((-0.55, -0.19),angle:4.97rad,[k(0)])
cetz.draw.hobby((-0.60, -0.53),(-0.61, -0.20),(-0.75, 0.08),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.20, -0.75),node4.pos,decoration:"wave",angle:6.18rad)
cetz.draw.content((-0.22, -0.86),angle:6.18rad,[k(1)])
cetz.draw.hobby((-0.61, -0.69),(-0.21, -0.81),(0.22, -0.77),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(-0.52, 0.46),node1.pos,decoration:"wave",angle:3.75rad)
cetz.draw.content((-0.59, 0.56),angle:3.75rad,[k(1)])
cetz.draw.hobby((-0.16, 0.69),(-0.55, 0.51),(-0.85, 0.22),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.51, 0.08),node2.pos,decoration:"coil",angle:0.26rad)
cetz.draw.content((0.54, -0.03),angle:0.26rad,[k(2)])
cetz.draw.hobby((0.26, -0.04),(0.51, 0.02),(0.75, 0.08),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.68, -0.35),node4.pos,decoration:"arrow",angle:1.03rad)
cetz.draw.content((0.79, -0.41),angle:1.03rad,[k(2)+k(3)])
cetz.draw.hobby((0.86, 0.05),(0.74, -0.37),(0.42, -0.69),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.45, 0.54),node2.pos,decoration:"arrow",angle:2.62rad)
cetz.draw.content((0.51, 0.65),angle:2.62rad,[k(3)])
cetz.draw.hobby((0.05, 0.72),(0.48, 0.60),(0.80, 0.28),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.19, -0.37),node3.pos,decoration:"arrow",angle:4.90rad)
cetz.draw.content((0.08, -0.39),angle:4.90rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((0.21, -0.65),(0.13, -0.36),(0.12, -0.07),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.01, 0.33),node5.pos,decoration:"arrow",angle:5.04rad)
cetz.draw.content((-0.10, 0.29),angle:5.04rad,[k(1)+k(3)])
cetz.draw.hobby((0.09, 0.02),(-0.04, 0.29),(-0.10, 0.57),stroke:stroke,mark: (end: ">"))
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