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
let node0= (pos:(0.74, -0.27))
node(node0.pos)
let node1= (pos:(0.77, 0.30))
node(node1.pos)
let node2= (pos:(-0.77, 0.36))
node(node2.pos)
let node3= (pos:(-0.79, -0.20))
node(node3.pos)
let node4= (pos:(-0.03, -0.33))
node(node4.pos)
let node5= (pos:(0.00, 0.42))
node(node5.pos)
edge(node1.pos,(0.67, 0.02),node0.pos,decoration:"arrow",angle:7.81rad)
cetz.draw.content((0.55, 0.02),angle:7.81rad,[k(0)+k(1)])
cetz.draw.hobby((0.68, 0.28),(0.61, 0.02),(0.66, -0.24),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.97, 0.00),node1.pos,decoration:"arrow",angle:4.67rad)
cetz.draw.content((1.09, -0.00),angle:4.67rad,[k(0)])
cetz.draw.hobby((0.84, -0.30),(1.03, 0.00),(0.87, 0.32),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.37, -0.39),node4.pos,decoration:"wave",angle:-3.07rad)
cetz.draw.content((0.37, -0.51),angle:-3.07rad,[k(1)])
cetz.draw.hobby((0.70, -0.36),(0.37, -0.45),(0.03, -0.41),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.40, 0.45),node1.pos,decoration:"wave",angle:-0.16rad)
cetz.draw.content((0.42, 0.57),angle:-0.16rad,[k(1)])
cetz.draw.hobby((0.07, 0.50),(0.41, 0.51),(0.73, 0.39),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.69, 0.08),node2.pos,decoration:"arrow",angle:4.67rad)
cetz.draw.content((-0.57, 0.07),angle:4.67rad,[k(2)])
cetz.draw.hobby((-0.71, -0.18),(-0.63, 0.07),(-0.69, 0.34),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-1.00, 0.09),node3.pos,decoration:"coil",angle:4.67rad)
cetz.draw.content((-1.12, 0.09),angle:4.67rad,[k(2)+k(3)])
cetz.draw.hobby((-0.87, 0.39),(-1.06, 0.09),(-0.90, -0.22),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(-0.39, 0.48),node2.pos,decoration:"arrow",angle:3.22rad)
cetz.draw.content((-0.40, 0.60),angle:3.22rad,[k(3)])
cetz.draw.hobby((-0.06, 0.50),(-0.39, 0.54),(-0.72, 0.45),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.43, -0.35),node4.pos,decoration:"arrow",angle:6.12rad)
cetz.draw.content((-0.45, -0.47),angle:6.12rad,[k(3)])
cetz.draw.hobby((-0.76, -0.30),(-0.44, -0.41),(-0.09, -0.41),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(-0.01, 0.05),node5.pos,decoration:"arrow",angle:1.53rad)
cetz.draw.content((0.11, 0.04),angle:1.53rad,[k(1)+k(3)])
cetz.draw.hobby((0.03, -0.25),(0.05, 0.04),(0.06, 0.34),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.40, -0.83))
node(node0.pos)
let node1= (pos:(-0.90, -0.15))
node(node1.pos)
let node2= (pos:(0.91, 0.64))
node(node2.pos)
let node3= (pos:(0.29, 0.19))
node(node3.pos)
let node4= (pos:(0.72, -0.52))
node(node4.pos)
let node5= (pos:(-0.25, 0.82))
node(node5.pos)
edge(node1.pos,(-0.56, -0.42),node0.pos,decoration:"arrow",angle:2.20rad)
cetz.draw.content((-0.46, -0.35),angle:2.20rad,[k(0)+k(1)])
cetz.draw.hobby((-0.79, -0.13),(-0.51, -0.39),(-0.36, -0.73),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.89, -0.66),node1.pos,decoration:"arrow",angle:5.34rad)
cetz.draw.content((-0.98, -0.73),angle:5.34rad,[k(0)])
cetz.draw.hobby((-0.51, -0.91),(-0.94, -0.70),(-1.00, -0.23),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.18, -0.80),node4.pos,decoration:"wave",angle:0.26rad)
cetz.draw.content((0.22, -0.92),angle:0.26rad,[k(1)])
cetz.draw.hobby((-0.29, -0.90),(0.21, -0.86),(0.66, -0.64),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(-0.69, 0.40),node1.pos,decoration:"wave",angle:4.13rad)
cetz.draw.content((-0.79, 0.47),angle:4.13rad,[k(1)])
cetz.draw.hobby((-0.39, 0.80),(-0.73, 0.44),(-0.93, -0.02),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.62, 0.43),node2.pos,decoration:"coil",angle:0.63rad)
cetz.draw.content((0.70, 0.33),angle:0.63rad,[k(2)])
cetz.draw.hobby((0.39, 0.19),(0.64, 0.37),(0.88, 0.55),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(1.00, 0.03),node4.pos,decoration:"arrow",angle:1.40rad)
cetz.draw.content((1.12, 0.01),angle:1.40rad,[k(2)+k(3)])
cetz.draw.hobby((1.01, 0.54),(1.06, 0.02),(0.85, -0.46),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.36, 0.92),node2.pos,decoration:"arrow",angle:2.99rad)
cetz.draw.content((0.37, 1.04),angle:2.99rad,[k(3)])
cetz.draw.hobby((-0.16, 0.92),(0.37, 0.98),(0.85, 0.77),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.47, -0.21),node3.pos,decoration:"arrow",angle:5.26rad)
cetz.draw.content((0.36, -0.28),angle:5.26rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((0.61, -0.50),(0.40, -0.22),(0.26, 0.09),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.04, 0.48),node5.pos,decoration:"arrow",angle:5.41rad)
cetz.draw.content((-0.13, 0.41),angle:5.41rad,[k(1)+k(3)])
cetz.draw.hobby((0.19, 0.19),(-0.07, 0.43),(-0.27, 0.71),stroke:stroke,mark: (end: ">"))
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