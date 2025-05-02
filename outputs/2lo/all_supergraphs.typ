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
let node0= (pos:(-0.67, -0.57))
node(node0.pos)
let node1= (pos:(-0.87, 0.00))
node(node1.pos)
let node2= (pos:(0.68, 0.55))
node(node2.pos)
let node3= (pos:(0.88, -0.02))
node(node3.pos)
let node4= (pos:(0.14, -0.38))
node(node4.pos)
let node5= (pos:(-0.13, 0.37))
node(node5.pos)
edge(node1.pos,(-0.68, -0.25),node0.pos,decoration:"arrow",angle:1.92rad)
cetz.draw.content((-0.57, -0.21),angle:1.92rad,[k(0)+k(1)])
cetz.draw.hobby((-0.78, 0.01),(-0.62, -0.23),(-0.59, -0.51),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.99, -0.36),node1.pos,decoration:"arrow",angle:5.06rad)
cetz.draw.content((-1.10, -0.40),angle:5.06rad,[k(0)])
cetz.draw.hobby((-0.76, -0.62),(-1.04, -0.38),(-0.98, -0.01),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.24, -0.57),node4.pos,decoration:"wave",angle:0.22rad)
cetz.draw.content((-0.22, -0.69),angle:0.22rad,[k(1)])
cetz.draw.hobby((-0.59, -0.64),(-0.23, -0.63),(0.10, -0.48),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(-0.54, 0.27),node1.pos,decoration:"wave",angle:3.60rad)
cetz.draw.content((-0.59, 0.38),angle:3.60rad,[k(1)])
cetz.draw.hobby((-0.22, 0.42),(-0.57, 0.32),(-0.86, 0.11),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.69, 0.23),node2.pos,decoration:"arrow",angle:5.05rad)
cetz.draw.content((0.58, 0.19),angle:5.05rad,[k(2)])
cetz.draw.hobby((0.79, -0.03),(0.63, 0.21),(0.61, 0.50),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(1.00, 0.34),node3.pos,decoration:"coil",angle:-1.24rad)
cetz.draw.content((1.11, 0.38),angle:-1.24rad,[k(2)+k(3)])
cetz.draw.hobby((0.77, 0.60),(1.06, 0.36),(0.99, -0.01),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.26, 0.55),node2.pos,decoration:"arrow",angle:0.22rad)
cetz.draw.content((0.23, 0.67),angle:0.22rad,[k(3)])
cetz.draw.hobby((-0.09, 0.47),(0.24, 0.61),(0.61, 0.62),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.55, -0.29),node4.pos,decoration:"arrow",angle:-2.69rad)
cetz.draw.content((0.61, -0.39),angle:-2.69rad,[k(3)])
cetz.draw.hobby((0.87, -0.13),(0.58, -0.34),(0.23, -0.44),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.01, -0.01),node5.pos,decoration:"arrow",angle:1.91rad)
cetz.draw.content((0.12, 0.03),angle:1.91rad,[k(1)+k(3)])
cetz.draw.hobby((0.17, -0.29),(0.06, 0.01),(-0.04, 0.31),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(0.02, -0.90))
node(node0.pos)
let node1= (pos:(-0.72, -0.59))
node(node1.pos)
let node2= (pos:(0.35, 0.96))
node(node2.pos)
let node3= (pos:(0.07, 0.29))
node(node3.pos)
let node4= (pos:(0.78, -0.08))
node(node4.pos)
let node5= (pos:(-0.69, 0.52))
node(node5.pos)
edge(node1.pos,(-0.46, -1.00),node0.pos,decoration:"arrow",angle:9.03rad)
cetz.draw.content((-0.50, -1.11),angle:9.03rad,[k(0)+k(1)])
cetz.draw.hobby((-0.77, -0.71),(-0.48, -1.06),(-0.02, -1.01),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.31, -0.64),node1.pos,decoration:"arrow",angle:5.89rad)
cetz.draw.content((-0.26, -0.53),angle:5.89rad,[k(0)])
cetz.draw.hobby((0.01, -0.79),(-0.28, -0.58),(-0.64, -0.52),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.49, -0.58),node4.pos,decoration:"wave",angle:0.82rad)
cetz.draw.content((0.58, -0.66),angle:0.82rad,[k(1)])
cetz.draw.hobby((0.16, -0.90),(0.54, -0.61),(0.79, -0.21),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(-0.83, -0.04),node1.pos,decoration:"wave",angle:4.68rad)
cetz.draw.content((-0.95, -0.03),angle:4.68rad,[k(1)])
cetz.draw.hobby((-0.79, 0.44),(-0.89, -0.03),(-0.82, -0.50),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.22, 0.65),node2.pos,decoration:"coil",angle:1.18rad)
cetz.draw.content((0.33, 0.60),angle:1.18rad,[k(2)])
cetz.draw.hobby((0.16, 0.33),(0.27, 0.60),(0.38, 0.87),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.73, 0.50),node4.pos,decoration:"arrow",angle:1.96rad)
cetz.draw.content((0.84, 0.55),angle:1.96rad,[k(2)+k(3)])
cetz.draw.hobby((0.48, 0.94),(0.79, 0.53),(0.86, 0.03),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(-0.24, 0.91),node2.pos,decoration:"arrow",angle:3.54rad)
cetz.draw.content((-0.29, 1.02),angle:3.54rad,[k(3)])
cetz.draw.hobby((-0.67, 0.66),(-0.26, 0.96),(0.24, 1.04),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.42, 0.04),node3.pos,decoration:"arrow",angle:5.82rad)
cetz.draw.content((0.36, -0.06),angle:5.82rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((0.68, -0.12),(0.37, -0.00),(0.09, 0.19),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.35, 0.36),node5.pos,decoration:"arrow",angle:5.97rad)
cetz.draw.content((-0.38, 0.24),angle:5.97rad,[k(1)+k(3)])
cetz.draw.hobby((-0.01, 0.23),(-0.34, 0.29),(-0.65, 0.43),stroke:stroke,mark: (end: ">"))
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