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
let node0= (pos:(-0.25, 0.80))
node(node0.pos)
let node1= (pos:(0.30, 0.78))
node(node1.pos)
let node2= (pos:(0.25, -0.72))
node(node2.pos)
let node3= (pos:(-0.31, -0.70))
node(node3.pos)
let node4= (pos:(-0.36, 0.05))
node(node4.pos)
let node5= (pos:(0.36, 0.03))
node(node5.pos)
edge(node1.pos,(0.03, 1.00),node0.pos,decoration:"arrow",angle:3.11rad)
cetz.draw.content((0.04, 1.12),angle:3.11rad,[k(0)+k(1)])
cetz.draw.hobby((0.33, 0.88),(0.03, 1.06),(-0.27, 0.90),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.02, 0.70),node1.pos,decoration:"arrow",angle:6.26rad)
cetz.draw.content((0.02, 0.58),angle:6.26rad,[k(0)])
cetz.draw.hobby((-0.23, 0.71),(0.02, 0.64),(0.28, 0.70),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.39, 0.44),node4.pos,decoration:"wave",angle:1.42rad)
cetz.draw.content((-0.51, 0.46),angle:1.42rad,[k(1)])
cetz.draw.hobby((-0.34, 0.76),(-0.45, 0.45),(-0.44, 0.12),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.42, 0.42),node1.pos,decoration:"wave",angle:-1.48rad)
cetz.draw.content((0.54, 0.43),angle:-1.48rad,[k(1)])
cetz.draw.hobby((0.45, 0.09),(0.48, 0.42),(0.39, 0.74),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.04, -0.92),node2.pos,decoration:"arrow",angle:6.25rad)
cetz.draw.content((-0.04, -1.04),angle:6.25rad,[k(2)])
cetz.draw.hobby((-0.33, -0.80),(-0.04, -0.98),(0.27, -0.82),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.03, -0.62),node3.pos,decoration:"coil",angle:-0.04rad)
cetz.draw.content((-0.02, -0.50),angle:-0.04rad,[k(2)+k(3)])
cetz.draw.hobby((0.23, -0.63),(-0.02, -0.56),(-0.28, -0.61),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.39, -0.36),node2.pos,decoration:"arrow",angle:1.41rad)
cetz.draw.content((0.51, -0.38),angle:1.41rad,[k(3)])
cetz.draw.hobby((0.44, -0.03),(0.45, -0.37),(0.34, -0.68),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.42, -0.33),node4.pos,decoration:"arrow",angle:4.79rad)
cetz.draw.content((-0.54, -0.34),angle:4.79rad,[k(3)])
cetz.draw.hobby((-0.40, -0.65),(-0.48, -0.33),(-0.44, -0.00),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.00, 0.04),node5.pos,decoration:"arrow",angle:3.11rad)
cetz.draw.content((0.01, 0.16),angle:3.11rad,[k(1)+k(3)])
cetz.draw.hobby((-0.29, 0.11),(0.00, 0.10),(0.29, 0.09),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.50, 0.68))
node(node0.pos)
let node1= (pos:(0.10, 0.87))
node(node1.pos)
let node2= (pos:(0.47, -0.53))
node(node2.pos)
let node3= (pos:(-0.00, -0.67))
node(node3.pos)
let node4= (pos:(-0.41, -0.17))
node(node4.pos)
let node5= (pos:(0.51, 0.12))
node(node5.pos)
edge(node1.pos,(-0.27, 1.00),node0.pos,decoration:"arrow",angle:3.44rad)
cetz.draw.content((-0.30, 1.11),angle:3.44rad,[k(0)+k(1)])
cetz.draw.hobby((0.08, 0.98),(-0.29, 1.06),(-0.55, 0.78),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.17, 0.68),node1.pos,decoration:"arrow",angle:0.31rad)
cetz.draw.content((-0.13, 0.57),angle:0.31rad,[k(0)])
cetz.draw.hobby((-0.44, 0.60),(-0.15, 0.62),(0.10, 0.78),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.54, 0.25),node4.pos,decoration:"wave",angle:1.67rad)
cetz.draw.content((-0.66, 0.24),angle:1.67rad,[k(1)])
cetz.draw.hobby((-0.58, 0.61),(-0.60, 0.24),(-0.50, -0.12),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.38, 0.54),node1.pos,decoration:"wave",angle:-1.06rad)
cetz.draw.content((0.49, 0.60),angle:-1.06rad,[k(1)])
cetz.draw.hobby((0.56, 0.22),(0.44, 0.57),(0.21, 0.86),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.30, -0.83),node2.pos,decoration:"coil",angle:-2.84rad)
cetz.draw.content((0.34, -0.95),angle:-2.84rad,[k(2)])
cetz.draw.hobby((-0.01, -0.78),(0.32, -0.89),(0.54, -0.60),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.02, -0.29),node4.pos,decoration:"arrow",angle:2.77rad)
cetz.draw.content((0.06, -0.18),angle:2.77rad,[k(2)+k(3)])
cetz.draw.hobby((0.42, -0.42),(0.07, -0.25),(-0.30, -0.13),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.68, -0.21),node2.pos,decoration:"arrow",angle:-1.63rad)
cetz.draw.content((0.80, -0.22),angle:-1.63rad,[k(3)])
cetz.draw.hobby((0.62, 0.11),(0.74, -0.22),(0.57, -0.53),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(-0.35, -0.54),node3.pos,decoration:"arrow",angle:5.38rad)
cetz.draw.content((-0.45, -0.61),angle:5.38rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((-0.49, -0.24),(-0.40, -0.58),(-0.08, -0.74),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.23, -0.22),node5.pos,decoration:"arrow",angle:0.98rad)
cetz.draw.content((0.13, -0.16),angle:0.98rad,[k(1)+k(3)])
cetz.draw.hobby((-0.02, -0.56),(0.17, -0.22),(0.40, 0.09),stroke:stroke,mark: (end: ">"))
})
[
                            = d0
 overall factor: -2
                            
 symmetry group: 1]
grid(columns: cols,gutter: 20pt,box[#d00 ],)
pagebreak()
[
                            = d1
 overall factor: -1
                            
 symmetry group: 2]
grid(columns: cols,gutter: 20pt,box[#d10 ],)
pagebreak()
}