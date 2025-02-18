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
let node0= (pos:(-0.07, 0.64))
node(node0.pos)
let node1= (pos:(0.40, 0.93))
node(node1.pos)
let node2= (pos:(-0.38, -0.37))
node(node2.pos)
let node3= (pos:(-0.16, -0.87))
node(node3.pos)
let node4= (pos:(0.29, -0.27))
node(node4.pos)
let node5= (pos:(0.43, 0.18))
node(node5.pos)
edge(node1.pos,(0.21, 0.74),node0.pos,decoration:"arrow",angle:-2.58rad)
cetz.draw.content((0.27, 0.63),angle:-2.58rad,[k(0)+k(1)])
cetz.draw.hobby((0.42, 0.85),(0.23, 0.68),(-0.00, 0.59),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.05, 1.00),node1.pos,decoration:"arrow",angle:0.51rad)
cetz.draw.content((-0.01, 1.10),angle:0.51rad,[k(0)])
cetz.draw.hobby((-0.15, 0.71),(0.01, 1.04),(0.38, 1.04),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.04, 0.20),node4.pos,decoration:"wave",angle:1.93rad)
cetz.draw.content((-0.08, 0.15),angle:1.93rad,[k(1)])
cetz.draw.hobby((-0.12, 0.53),(-0.01, 0.14),(0.19, -0.22),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.55, 0.57),node1.pos,decoration:"wave",angle:-1.53rad)
cetz.draw.content((0.67, 0.57),angle:-1.53rad,[k(1)])
cetz.draw.hobby((0.53, 0.22),(0.61, 0.56),(0.50, 0.90),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.21, -0.60),node2.pos,decoration:"arrow",angle:1.99rad)
cetz.draw.content((-0.10, -0.55),angle:1.99rad,[k(2)])
cetz.draw.hobby((-0.10, -0.81),(-0.16, -0.57),(-0.30, -0.36),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.49, -0.72),node3.pos,decoration:"coil",angle:2.02rad)
cetz.draw.content((-0.59, -0.78),angle:2.02rad,[k(2)+k(3)])
cetz.draw.hobby((-0.49, -0.38),(-0.54, -0.74),(-0.23, -0.94),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(-0.04, -0.06),node2.pos,decoration:"arrow",angle:0.61rad)
cetz.draw.content((-0.11, 0.04),angle:0.61rad,[k(3)])
cetz.draw.hobby((0.32, 0.20),(-0.05, 0.01),(-0.36, -0.25),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.17, -0.65),node4.pos,decoration:"arrow",angle:-2.22rad)
cetz.draw.content((0.26, -0.72),angle:-2.22rad,[k(3)])
cetz.draw.hobby((-0.05, -0.90),(0.22, -0.68),(0.35, -0.35),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.57, -0.11),node5.pos,decoration:"arrow",angle:-1.87rad)
cetz.draw.content((0.68, -0.14),angle:-1.87rad,[k(1)+k(3)])
cetz.draw.hobby((0.37, -0.33),(0.63, -0.13),(0.53, 0.19),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.40, 0.70))
node(node0.pos)
let node1= (pos:(0.20, 0.86))
node(node1.pos)
let node2= (pos:(0.50, -0.54))
node(node2.pos)
let node3= (pos:(0.03, -0.66))
node(node3.pos)
let node4= (pos:(-0.35, -0.15))
node(node4.pos)
let node5= (pos:(0.58, 0.10))
node(node5.pos)
edge(node1.pos,(-0.16, 1.00),node0.pos,decoration:"arrow",angle:3.40rad)
cetz.draw.content((-0.19, 1.12),angle:3.40rad,[k(0)+k(1)])
cetz.draw.hobby((0.19, 0.96),(-0.18, 1.06),(-0.44, 0.79),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.07, 0.68),node1.pos,decoration:"arrow",angle:0.26rad)
cetz.draw.content((-0.04, 0.56),angle:0.26rad,[k(0)])
cetz.draw.hobby((-0.35, 0.62),(-0.06, 0.62),(0.20, 0.76),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.46, 0.27),node4.pos,decoration:"wave",angle:1.63rad)
cetz.draw.content((-0.58, 0.27),angle:1.63rad,[k(1)])
cetz.draw.hobby((-0.48, 0.63),(-0.52, 0.27),(-0.44, -0.09),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.47, 0.52),node1.pos,decoration:"wave",angle:-1.10rad)
cetz.draw.content((0.57, 0.57),angle:-1.10rad,[k(1)])
cetz.draw.hobby((0.63, 0.19),(0.52, 0.54),(0.31, 0.84),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.33, -0.83),node2.pos,decoration:"coil",angle:0.25rad)
cetz.draw.content((0.36, -0.95),angle:0.25rad,[k(2)])
cetz.draw.hobby((0.01, -0.76),(0.34, -0.89),(0.57, -0.62),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.07, -0.28),node4.pos,decoration:"arrow",angle:2.72rad)
cetz.draw.content((0.12, -0.17),angle:2.72rad,[k(2)+k(3)])
cetz.draw.hobby((0.46, -0.43),(0.12, -0.24),(-0.24, -0.11),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.72, -0.24),node2.pos,decoration:"arrow",angle:-1.68rad)
cetz.draw.content((0.84, -0.25),angle:-1.68rad,[k(3)])
cetz.draw.hobby((0.68, 0.09),(0.78, -0.25),(0.60, -0.55),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(-0.31, -0.51),node3.pos,decoration:"arrow",angle:5.34rad)
cetz.draw.content((-0.40, -0.58),angle:5.34rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((-0.43, -0.21),(-0.35, -0.55),(-0.05, -0.72),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.28, -0.22),node5.pos,decoration:"arrow",angle:0.93rad)
cetz.draw.content((0.19, -0.15),angle:0.93rad,[k(1)+k(3)])
cetz.draw.hobby((0.02, -0.55),(0.22, -0.22),(0.47, 0.08),stroke:stroke,mark: (end: ">"))
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
                            
 symmetry group: 1]
grid(columns: cols,gutter: 20pt,box[#d10 ],)
pagebreak()
}