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
let node0= (pos:(-0.74, -0.43))
node(node0.pos)
let node1= (pos:(-0.82, 0.14))
node(node1.pos)
let node2= (pos:(0.71, 0.36))
node(node2.pos)
let node3= (pos:(0.80, -0.21))
node(node3.pos)
let node4= (pos:(0.04, -0.41))
node(node4.pos)
let node5= (pos:(-0.07, 0.34))
node(node5.pos)
edge(node1.pos,(-1.00, -0.18),node0.pos,decoration:"arrow",angle:8.00rad)
cetz.draw.content((-1.12, -0.19),angle:8.00rad,[k(0)+k(1)])
cetz.draw.hobby((-0.93, 0.15),(-1.06, -0.18),(-0.84, -0.46),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.69, -0.13),node1.pos,decoration:"arrow",angle:4.86rad)
cetz.draw.content((-0.57, -0.11),angle:4.86rad,[k(0)])
cetz.draw.hobby((-0.66, -0.39),(-0.63, -0.12),(-0.74, 0.13),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.35, -0.51),node4.pos,decoration:"wave",angle:0.02rad)
cetz.draw.content((-0.35, -0.63),angle:0.02rad,[k(1)])
cetz.draw.hobby((-0.69, -0.51),(-0.35, -0.57),(-0.01, -0.50),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(-0.47, 0.33),node1.pos,decoration:"wave",angle:3.40rad)
cetz.draw.content((-0.50, 0.44),angle:3.40rad,[k(1)])
cetz.draw.hobby((-0.14, 0.41),(-0.48, 0.38),(-0.79, 0.24),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.97, 0.11),node2.pos,decoration:"arrow",angle:4.86rad)
cetz.draw.content((1.09, 0.13),angle:4.86rad,[k(2)])
cetz.draw.hobby((0.90, -0.22),(1.03, 0.12),(0.81, 0.40),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.67, 0.06),node3.pos,decoration:"coil",angle:4.86rad)
cetz.draw.content((0.55, 0.04),angle:4.86rad,[k(2)+k(3)])
cetz.draw.hobby((0.63, 0.32),(0.61, 0.05),(0.71, -0.20),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.32, 0.44),node2.pos,decoration:"arrow",angle:0.02rad)
cetz.draw.content((0.32, 0.56),angle:0.02rad,[k(3)])
cetz.draw.hobby((-0.02, 0.43),(0.32, 0.50),(0.66, 0.45),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.45, -0.39),node4.pos,decoration:"arrow",angle:-2.88rad)
cetz.draw.content((0.48, -0.51),angle:-2.88rad,[k(3)])
cetz.draw.hobby((0.77, -0.31),(0.46, -0.45),(0.11, -0.48),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(-0.01, -0.03),node5.pos,decoration:"arrow",angle:1.71rad)
cetz.draw.content((0.11, -0.02),angle:1.71rad,[k(1)+k(3)])
cetz.draw.hobby((0.09, -0.32),(0.05, -0.03),(0.00, 0.27),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.48, -0.84))
node(node0.pos)
let node1= (pos:(-0.94, -0.11))
node(node1.pos)
let node2= (pos:(0.94, 0.58))
node(node2.pos)
let node3= (pos:(0.29, 0.17))
node(node3.pos)
let node4= (pos:(0.68, -0.58))
node(node4.pos)
let node5= (pos:(-0.23, 0.83))
node(node5.pos)
edge(node1.pos,(-0.61, -0.41),node0.pos,decoration:"arrow",angle:2.14rad)
cetz.draw.content((-0.51, -0.34),angle:2.14rad,[k(0)+k(1)])
cetz.draw.hobby((-0.83, -0.11),(-0.56, -0.38),(-0.43, -0.74),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.96, -0.64),node1.pos,decoration:"arrow",angle:5.29rad)
cetz.draw.content((-1.06, -0.70),angle:5.29rad,[k(0)])
cetz.draw.hobby((-0.59, -0.91),(-1.01, -0.67),(-1.05, -0.19),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.12, -0.84),node4.pos,decoration:"wave",angle:0.21rad)
cetz.draw.content((0.15, -0.96),angle:0.21rad,[k(1)])
cetz.draw.hobby((-0.37, -0.92),(0.14, -0.90),(0.61, -0.71),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(-0.70, 0.44),node1.pos,decoration:"wave",angle:4.07rad)
cetz.draw.content((-0.79, 0.51),angle:4.07rad,[k(1)])
cetz.draw.hobby((-0.37, 0.82),(-0.74, 0.48),(-0.97, 0.02),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.64, 0.39),node2.pos,decoration:"coil",angle:0.56rad)
cetz.draw.content((0.58, 0.49),angle:0.56rad,[k(2)])
cetz.draw.hobby((0.32, 0.26),(0.59, 0.43),(0.85, 0.59),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(1.00, -0.05),node4.pos,decoration:"arrow",angle:1.34rad)
cetz.draw.content((1.12, -0.07),angle:1.34rad,[k(2)+k(3)])
cetz.draw.hobby((1.05, 0.48),(1.06, -0.06),(0.82, -0.53),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.40, 0.90),node2.pos,decoration:"arrow",angle:2.93rad)
cetz.draw.content((0.42, 1.02),angle:2.93rad,[k(3)])
cetz.draw.hobby((-0.13, 0.93),(0.41, 0.96),(0.89, 0.72),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.45, -0.25),node3.pos,decoration:"arrow",angle:5.20rad)
cetz.draw.content((0.34, -0.31),angle:5.20rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((0.58, -0.56),(0.38, -0.26),(0.25, 0.07),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.03, 0.48),node5.pos,decoration:"arrow",angle:5.37rad)
cetz.draw.content((-0.12, 0.41),angle:5.37rad,[k(1)+k(3)])
cetz.draw.hobby((0.19, 0.18),(-0.06, 0.43),(-0.25, 0.73),stroke:stroke,mark: (end: ">"))
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