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
let node0= (pos:(-0.17, 0.63))
node(node0.pos)
let node1= (pos:(0.31, 0.94))
node(node1.pos)
let node2= (pos:(-0.48, -0.41))
node(node2.pos)
let node3= (pos:(-0.23, -0.92))
node(node3.pos)
let node4= (pos:(0.21, -0.29))
node(node4.pos)
let node5= (pos:(0.35, 0.16))
node(node5.pos)
edge(node1.pos,(0.11, 0.73),node0.pos,decoration:"arrow",angle:-2.57rad)
cetz.draw.content((0.18, 0.63),angle:-2.57rad,[k(0)+k(1)])
cetz.draw.hobby((0.33, 0.85),(0.14, 0.68),(-0.10, 0.58),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.05, 1.00),node1.pos,decoration:"arrow",angle:0.53rad)
cetz.draw.content((-0.11, 1.10),angle:0.53rad,[k(0)])
cetz.draw.hobby((-0.25, 0.70),(-0.09, 1.04),(0.28, 1.04),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.05, 0.17),node4.pos,decoration:"wave",angle:1.95rad)
cetz.draw.content((-0.17, 0.13),angle:1.95rad,[k(1)])
cetz.draw.hobby((-0.21, 0.52),(-0.10, 0.12),(0.10, -0.25),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.46, 0.56),node1.pos,decoration:"wave",angle:-1.51rad)
cetz.draw.content((0.58, 0.57),angle:-1.51rad,[k(1)])
cetz.draw.hobby((0.44, 0.21),(0.52, 0.56),(0.41, 0.90),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.30, -0.64),node2.pos,decoration:"arrow",angle:2.01rad)
cetz.draw.content((-0.19, -0.59),angle:2.01rad,[k(2)])
cetz.draw.hobby((-0.18, -0.86),(-0.24, -0.61),(-0.39, -0.40),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.58, -0.78),node3.pos,decoration:"coil",angle:2.04rad)
cetz.draw.content((-0.68, -0.83),angle:2.04rad,[k(2)+k(3)])
cetz.draw.hobby((-0.59, -0.42),(-0.63, -0.80),(-0.32, -1.00),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(-0.13, -0.08),node2.pos,decoration:"arrow",angle:0.62rad)
cetz.draw.content((-0.20, 0.01),angle:0.62rad,[k(3)])
cetz.draw.hobby((0.23, 0.18),(-0.14, -0.02),(-0.46, -0.29),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.09, -0.69),node4.pos,decoration:"arrow",angle:-2.20rad)
cetz.draw.content((0.19, -0.76),angle:-2.20rad,[k(3)])
cetz.draw.hobby((-0.13, -0.95),(0.15, -0.72),(0.27, -0.38),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.49, -0.13),node5.pos,decoration:"arrow",angle:-1.86rad)
cetz.draw.content((0.61, -0.16),angle:-1.86rad,[k(1)+k(3)])
cetz.draw.hobby((0.29, -0.36),(0.55, -0.14),(0.45, 0.18),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.55, 0.65))
node(node0.pos)
let node1= (pos:(0.08, 0.88))
node(node1.pos)
let node2= (pos:(0.52, -0.60))
node(node2.pos)
let node3= (pos:(0.03, -0.78))
node(node3.pos)
let node4= (pos:(-0.42, -0.26))
node(node4.pos)
let node5= (pos:(0.56, 0.09))
node(node5.pos)
edge(node1.pos,(-0.20, 0.66),node0.pos,decoration:"arrow",angle:-2.80rad)
cetz.draw.content((-0.16, 0.55),angle:-2.80rad,[k(0)+k(1)])
cetz.draw.hobby((0.08, 0.78),(-0.18, 0.61),(-0.49, 0.57),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.32, 1.00),node1.pos,decoration:"arrow",angle:0.35rad)
cetz.draw.content((-0.36, 1.11),angle:0.35rad,[k(0)])
cetz.draw.hobby((-0.60, 0.75),(-0.34, 1.06),(0.06, 0.99),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.58, 0.19),node4.pos,decoration:"wave",angle:1.70rad)
cetz.draw.content((-0.70, 0.17),angle:1.70rad,[k(1)])
cetz.draw.hobby((-0.63, 0.57),(-0.64, 0.17),(-0.52, -0.20),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.40, 0.54),node1.pos,decoration:"wave",angle:-1.03rad)
cetz.draw.content((0.50, 0.60),angle:-1.03rad,[k(1)])
cetz.draw.hobby((0.60, 0.20),(0.45, 0.56),(0.20, 0.87),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.37, -0.94),node2.pos,decoration:"coil",angle:0.34rad)
cetz.draw.content((0.41, -1.05),angle:0.34rad,[k(2)])
cetz.draw.hobby((0.03, -0.89),(0.39, -0.99),(0.60, -0.68),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.04, -0.37),node4.pos,decoration:"arrow",angle:2.81rad)
cetz.draw.content((0.08, -0.25),angle:2.81rad,[k(2)+k(3)])
cetz.draw.hobby((0.47, -0.50),(0.09, -0.32),(-0.31, -0.22),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.74, -0.26),node2.pos,decoration:"arrow",angle:-1.60rad)
cetz.draw.content((0.86, -0.26),angle:-1.60rad,[k(3)])
cetz.draw.hobby((0.66, 0.08),(0.80, -0.27),(0.63, -0.60),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(-0.35, -0.65),node3.pos,decoration:"arrow",angle:5.42rad)
cetz.draw.content((-0.44, -0.72),angle:5.42rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((-0.50, -0.33),(-0.39, -0.69),(-0.05, -0.85),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.27, -0.29),node5.pos,decoration:"arrow",angle:1.02rad)
cetz.draw.content((0.16, -0.22),angle:1.02rad,[k(1)+k(3)])
cetz.draw.hobby((0.01, -0.66),(0.20, -0.29),(0.44, 0.05),stroke:stroke,mark: (end: ">"))
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