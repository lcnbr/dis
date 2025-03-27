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
let node0= (pos:(-0.68, -0.35))
node(node0.pos)
let node1= (pos:(-0.78, 0.21))
node(node1.pos)
let node2= (pos:(0.74, 0.46))
node(node2.pos)
let node3= (pos:(0.83, -0.10))
node(node3.pos)
let node4= (pos:(0.09, -0.31))
node(node4.pos)
let node5= (pos:(-0.03, 0.42))
node(node5.pos)
edge(node1.pos,(-0.64, -0.05),node0.pos,decoration:"arrow",angle:1.74rad)
cetz.draw.content((-0.52, -0.03),angle:1.74rad,[k(0)+k(1)])
cetz.draw.hobby((-0.69, 0.20),(-0.58, -0.04),(-0.60, -0.31),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.94, -0.10),node1.pos,decoration:"arrow",angle:4.88rad)
cetz.draw.content((-1.06, -0.12),angle:4.88rad,[k(0)])
cetz.draw.hobby((-0.78, -0.38),(-1.00, -0.11),(-0.88, 0.22),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.30, -0.42),node4.pos,decoration:"wave",angle:-3.10rad)
cetz.draw.content((-0.29, -0.54),angle:-3.10rad,[k(1)])
cetz.draw.hobby((-0.62, -0.43),(-0.29, -0.48),(0.04, -0.40),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(-0.43, 0.40),node1.pos,decoration:"wave",angle:0.28rad)
cetz.draw.content((-0.46, 0.52),angle:0.28rad,[k(1)])
cetz.draw.hobby((-0.11, 0.49),(-0.44, 0.46),(-0.75, 0.31),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.70, 0.17),node2.pos,decoration:"arrow",angle:4.87rad)
cetz.draw.content((0.58, 0.15),angle:4.87rad,[k(2)])
cetz.draw.hobby((0.74, -0.09),(0.64, 0.16),(0.66, 0.42),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(1.00, 0.22),node3.pos,decoration:"coil",angle:1.74rad)
cetz.draw.content((1.12, 0.24),angle:1.74rad,[k(2)+k(3)])
cetz.draw.hobby((0.83, 0.50),(1.06, 0.23),(0.93, -0.10),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.35, 0.53),node2.pos,decoration:"arrow",angle:3.19rad)
cetz.draw.content((0.35, 0.65),angle:3.19rad,[k(3)])
cetz.draw.hobby((0.02, 0.51),(0.35, 0.59),(0.68, 0.55),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.49, -0.29),node4.pos,decoration:"arrow",angle:0.28rad)
cetz.draw.content((0.52, -0.40),angle:0.28rad,[k(3)])
cetz.draw.hobby((0.80, -0.20),(0.50, -0.35),(0.16, -0.38),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.03, 0.06),node5.pos,decoration:"arrow",angle:4.88rad)
cetz.draw.content((-0.09, 0.04),angle:4.88rad,[k(1)+k(3)])
cetz.draw.hobby((0.02, -0.24),(-0.03, 0.05),(-0.08, 0.34),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(0.37, -1.00))
node(node0.pos)
let node1= (pos:(1.00, -0.41))
node(node1.pos)
let node2= (pos:(-0.13, 0.16))
node(node2.pos)
let node3= (pos:(-0.67, 0.74))
node(node3.pos)
let node4= (pos:(-0.70, -0.47))
node(node4.pos)
let node5= (pos:(0.54, 0.69))
node(node5.pos)
edge(node1.pos,(0.60, -0.61),node0.pos,decoration:"arrow",angle:0.75rad)
cetz.draw.content((0.52, -0.53),angle:0.75rad,[k(0)+k(1)])
cetz.draw.hobby((0.89, -0.37),(0.56, -0.57),(0.34, -0.89),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.89, -0.92),node1.pos,decoration:"arrow",angle:-2.38rad)
cetz.draw.content((0.97, -1.01),angle:-2.38rad,[k(0)])
cetz.draw.hobby((0.46, -1.10),(0.93, -0.97),(1.09, -0.51),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.22, -0.86),node4.pos,decoration:"wave",angle:5.83rad)
cetz.draw.content((-0.27, -0.96),angle:5.83rad,[k(1)])
cetz.draw.hobby((0.24, -1.05),(-0.25, -0.91),(-0.66, -0.60),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.89, 0.19),node1.pos,decoration:"wave",angle:1.97rad)
cetz.draw.content((1.00, 0.23),angle:1.97rad,[k(1)])
cetz.draw.hobby((0.67, 0.65),(0.94, 0.22),(1.06, -0.28),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.42, 0.48),node2.pos,decoration:"coil",angle:2.32rad)
cetz.draw.content((-0.33, 0.56),angle:2.32rad,[k(2)])
cetz.draw.hobby((-0.57, 0.72),(-0.35, 0.49),(-0.14, 0.26),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.39, -0.21),node4.pos,decoration:"arrow",angle:0.83rad)
cetz.draw.content((-0.30, -0.29),angle:0.83rad,[k(2)+k(3)])
cetz.draw.hobby((-0.12, 0.06),(-0.33, -0.23),(-0.59, -0.47),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.25, 0.40),node2.pos,decoration:"arrow",angle:0.68rad)
cetz.draw.content((0.33, 0.31),angle:0.68rad,[k(3)])
cetz.draw.hobby((0.53, 0.59),(0.27, 0.34),(-0.03, 0.15),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(-0.88, 0.14),node3.pos,decoration:"arrow",angle:4.69rad)
cetz.draw.content((-1.00, 0.14),angle:4.69rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((-0.82, -0.39),(-0.94, 0.14),(-0.79, 0.66),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.05, 0.91),node5.pos,decoration:"arrow",angle:3.10rad)
cetz.draw.content((-0.05, 1.03),angle:3.10rad,[k(1)+k(3)])
cetz.draw.hobby((-0.58, 0.85),(-0.05, 0.97),(0.46, 0.82),stroke:stroke,mark: (end: ">"))
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