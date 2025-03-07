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
let node0= (pos:(-0.24, 0.78))
node(node0.pos)
let node1= (pos:(0.30, 0.80))
node(node1.pos)
let node2= (pos:(0.35, -0.68))
node(node2.pos)
let node3= (pos:(-0.20, -0.70))
node(node3.pos)
let node4= (pos:(-0.30, 0.04))
node(node4.pos)
let node5= (pos:(0.41, 0.06))
node(node5.pos)
edge(node1.pos,(0.03, 0.70),node0.pos,decoration:"arrow",angle:-3.11rad)
cetz.draw.content((0.04, 0.58),angle:-3.11rad,[k(0)+k(1)])
cetz.draw.hobby((0.28, 0.71),(0.03, 0.64),(-0.22, 0.70),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.02, 1.00),node1.pos,decoration:"arrow",angle:0.03rad)
cetz.draw.content((0.02, 1.12),angle:0.03rad,[k(0)])
cetz.draw.hobby((-0.27, 0.88),(0.02, 1.06),(0.32, 0.90),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.36, 0.42),node4.pos,decoration:"wave",angle:1.49rad)
cetz.draw.content((-0.48, 0.43),angle:1.49rad,[k(1)])
cetz.draw.hobby((-0.33, 0.74),(-0.42, 0.42),(-0.39, 0.09),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.44, 0.44),node1.pos,decoration:"wave",angle:-1.42rad)
cetz.draw.content((0.56, 0.46),angle:-1.42rad,[k(1)])
cetz.draw.hobby((0.49, 0.12),(0.50, 0.45),(0.40, 0.76),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.08, -0.90),node2.pos,decoration:"arrow",angle:0.02rad)
cetz.draw.content((0.08, -1.02),angle:0.02rad,[k(2)])
cetz.draw.hobby((-0.22, -0.80),(0.08, -0.96),(0.37, -0.78),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.07, -0.61),node3.pos,decoration:"coil",angle:0.03rad)
cetz.draw.content((0.07, -0.49),angle:0.03rad,[k(2)+k(3)])
cetz.draw.hobby((0.32, -0.60),(0.07, -0.55),(-0.18, -0.62),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.47, -0.32),node2.pos,decoration:"arrow",angle:1.48rad)
cetz.draw.content((0.59, -0.33),angle:1.48rad,[k(3)])
cetz.draw.hobby((0.50, 0.00),(0.53, -0.33),(0.44, -0.64),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.34, -0.34),node4.pos,decoration:"arrow",angle:4.85rad)
cetz.draw.content((-0.46, -0.36),angle:4.85rad,[k(3)])
cetz.draw.hobby((-0.29, -0.66),(-0.40, -0.35),(-0.38, -0.02),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.05, 0.05),node5.pos,decoration:"arrow",angle:3.17rad)
cetz.draw.content((0.05, 0.17),angle:3.17rad,[k(1)+k(3)])
cetz.draw.hobby((-0.23, 0.10),(0.05, 0.11),(0.34, 0.12),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.67, 0.60))
node(node0.pos)
let node1= (pos:(-0.02, 0.91))
node(node1.pos)
let node2= (pos:(0.59, -0.61))
node(node2.pos)
let node3= (pos:(0.09, -0.85))
node(node3.pos)
let node4= (pos:(-0.44, -0.34))
node(node4.pos)
let node5= (pos:(0.56, 0.12))
node(node5.pos)
edge(node1.pos,(-0.30, 0.65),node0.pos,decoration:"arrow",angle:-2.70rad)
cetz.draw.content((-0.24, 0.54),angle:-2.70rad,[k(0)+k(1)])
cetz.draw.hobby((-0.01, 0.81),(-0.27, 0.60),(-0.59, 0.54),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.46, 1.00),node1.pos,decoration:"arrow",angle:0.44rad)
cetz.draw.content((-0.51, 1.11),angle:0.44rad,[k(0)])
cetz.draw.hobby((-0.73, 0.71),(-0.48, 1.05),(-0.06, 1.02),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.65, 0.11),node4.pos,decoration:"wave",angle:1.80rad)
cetz.draw.content((-0.77, 0.08),angle:1.80rad,[k(1)])
cetz.draw.hobby((-0.74, 0.51),(-0.71, 0.09),(-0.55, -0.29),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.35, 0.58),node1.pos,decoration:"wave",angle:-0.93rad)
cetz.draw.content((0.45, 0.65),angle:-0.93rad,[k(1)])
cetz.draw.hobby((0.59, 0.24),(0.40, 0.61),(0.10, 0.91),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.46, -0.98),node2.pos,decoration:"coil",angle:-2.71rad)
cetz.draw.content((0.51, -1.09),angle:-2.71rad,[k(2)])
cetz.draw.hobby((0.10, -0.96),(0.48, -1.03),(0.68, -0.69),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.06, -0.41),node4.pos,decoration:"arrow",angle:2.90rad)
cetz.draw.content((0.08, -0.29),angle:2.90rad,[k(2)+k(3)])
cetz.draw.hobby((0.52, -0.51),(0.11, -0.36),(-0.33, -0.29),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.79, -0.23),node2.pos,decoration:"arrow",angle:-1.51rad)
cetz.draw.content((0.91, -0.22),angle:-1.51rad,[k(3)])
cetz.draw.hobby((0.67, 0.12),(0.85, -0.23),(0.71, -0.60),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(-0.32, -0.74),node3.pos,decoration:"arrow",angle:5.51rad)
cetz.draw.content((-0.41, -0.83),angle:5.51rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((-0.51, -0.43),(-0.36, -0.79),(0.01, -0.92),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.29, -0.30),node5.pos,decoration:"arrow",angle:1.11rad)
cetz.draw.content((0.18, -0.25),angle:1.11rad,[k(1)+k(3)])
cetz.draw.hobby((0.06, -0.72),(0.22, -0.31),(0.45, 0.07),stroke:stroke,mark: (end: ">"))
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