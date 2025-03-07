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
let node0= (pos:(-0.05, 0.65))
node(node0.pos)
let node1= (pos:(0.46, 0.90))
node(node1.pos)
let node2= (pos:(-0.48, -0.35))
node(node2.pos)
let node3= (pos:(-0.29, -0.89))
node(node3.pos)
let node4= (pos:(0.23, -0.32))
node(node4.pos)
let node5= (pos:(0.41, 0.12))
node(node5.pos)
edge(node1.pos,(0.24, 0.71),node0.pos,decoration:"arrow",angle:-2.69rad)
cetz.draw.content((0.29, 0.60),angle:-2.69rad,[k(0)+k(1)])
cetz.draw.hobby((0.47, 0.81),(0.26, 0.66),(0.01, 0.59),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.11, 1.00),node1.pos,decoration:"arrow",angle:0.41rad)
cetz.draw.content((0.06, 1.11),angle:0.41rad,[k(0)])
cetz.draw.hobby((-0.13, 0.73),(0.07, 1.05),(0.44, 1.00),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.01, 0.18),node4.pos,decoration:"wave",angle:1.84rad)
cetz.draw.content((-0.10, 0.15),angle:1.84rad,[k(1)])
cetz.draw.hobby((-0.11, 0.54),(-0.04, 0.13),(0.12, -0.26),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.57, 0.51),node1.pos,decoration:"wave",angle:-1.63rad)
cetz.draw.content((0.69, 0.50),angle:-1.63rad,[k(1)])
cetz.draw.hobby((0.51, 0.16),(0.63, 0.50),(0.56, 0.85),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.32, -0.60),node2.pos,decoration:"arrow",angle:1.89rad)
cetz.draw.content((-0.21, -0.57),angle:1.89rad,[k(2)])
cetz.draw.hobby((-0.23, -0.84),(-0.27, -0.58),(-0.39, -0.36),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.61, -0.71),node3.pos,decoration:"coil",angle:1.94rad)
cetz.draw.content((-0.73, -0.75),angle:1.94rad,[k(2)+k(3)])
cetz.draw.hobby((-0.58, -0.36),(-0.68, -0.72),(-0.38, -0.95),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(-0.10, -0.07),node2.pos,decoration:"arrow",angle:0.51rad)
cetz.draw.content((-0.15, 0.04),angle:0.51rad,[k(3)])
cetz.draw.hobby((0.29, 0.16),(-0.09, -0.00),(-0.44, -0.24),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.06, -0.70),node4.pos,decoration:"arrow",angle:-2.32rad)
cetz.draw.content((0.15, -0.78),angle:-2.32rad,[k(3)])
cetz.draw.hobby((-0.20, -0.93),(0.11, -0.73),(0.27, -0.41),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.52, -0.18),node5.pos,decoration:"arrow",angle:-1.96rad)
cetz.draw.content((0.64, -0.23),angle:-1.96rad,[k(1)+k(3)])
cetz.draw.hobby((0.30, -0.39),(0.58, -0.20),(0.51, 0.13),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.84, 0.33))
node(node0.pos)
let node1= (pos:(-0.20, 0.91))
node(node1.pos)
let node2= (pos:(0.78, -0.83))
node(node2.pos)
let node3= (pos:(0.27, -0.26))
node(node3.pos)
let node4= (pos:(-0.41, -0.76))
node(node4.pos)
let node5= (pos:(0.84, 0.35))
node(node5.pos)
edge(node1.pos,(-0.44, 0.53),node0.pos,decoration:"arrow",angle:-2.41rad)
cetz.draw.content((-0.36, 0.44),angle:-2.41rad,[k(0)+k(1)])
cetz.draw.hobby((-0.18, 0.80),(-0.40, 0.49),(-0.73, 0.30),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.72, 0.84),node1.pos,decoration:"arrow",angle:0.74rad)
cetz.draw.content((-0.80, 0.93),angle:0.74rad,[k(0)])
cetz.draw.hobby((-0.92, 0.43),(-0.75, 0.88),(-0.29, 1.00),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.75, -0.25),node4.pos,decoration:"wave",angle:1.94rad)
cetz.draw.content((-0.86, -0.30),angle:1.94rad,[k(1)])
cetz.draw.hobby((-0.90, 0.21),(-0.80, -0.28),(-0.54, -0.71),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.38, 0.75),node1.pos,decoration:"wave",angle:-0.48rad)
cetz.draw.content((0.43, 0.85),angle:-0.48rad,[k(1)])
cetz.draw.hobby((0.81, 0.49),(0.41, 0.80),(-0.07, 0.95),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.54, -0.57),node2.pos,decoration:"coil",angle:2.30rad)
cetz.draw.content((0.45, -0.65),angle:2.30rad,[k(2)])
cetz.draw.hobby((0.27, -0.35),(0.47, -0.59),(0.68, -0.82),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.17, -0.99),node4.pos,decoration:"arrow",angle:3.08rad)
cetz.draw.content((0.17, -1.11),angle:3.08rad,[k(2)+k(3)])
cetz.draw.hobby((0.69, -0.95),(0.17, -1.05),(-0.34, -0.88),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(1.00, -0.25),node2.pos,decoration:"arrow",angle:-1.62rad)
cetz.draw.content((1.12, -0.25),angle:-1.62rad,[k(3)])
cetz.draw.hobby((0.96, 0.27),(1.06, -0.25),(0.90, -0.76),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(-0.12, -0.48),node3.pos,decoration:"arrow",angle:0.65rad)
cetz.draw.content((-0.20, -0.38),angle:0.65rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((-0.40, -0.65),(-0.14, -0.41),(0.16, -0.24),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.53, 0.11),node5.pos,decoration:"arrow",angle:0.80rad)
cetz.draw.content((0.44, 0.19),angle:0.80rad,[k(1)+k(3)])
cetz.draw.hobby((0.25, -0.15),(0.46, 0.13),(0.73, 0.36),stroke:stroke,mark: (end: ">"))
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