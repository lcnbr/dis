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
let node0= (pos:(-0.09, 0.64))
node(node0.pos)
let node1= (pos:(0.39, 0.94))
node(node1.pos)
let node2= (pos:(-0.40, -0.39))
node(node2.pos)
let node3= (pos:(-0.17, -0.91))
node(node3.pos)
let node4= (pos:(0.29, -0.29))
node(node4.pos)
let node5= (pos:(0.42, 0.17))
node(node5.pos)
edge(node1.pos,(0.19, 0.73),node0.pos,decoration:"arrow",angle:-2.58rad)
cetz.draw.content((0.25, 0.63),angle:-2.58rad,[k(0)+k(1)])
cetz.draw.hobby((0.40, 0.85),(0.22, 0.68),(-0.02, 0.59),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.03, 1.00),node1.pos,decoration:"arrow",angle:0.53rad)
cetz.draw.content((-0.03, 1.10),angle:0.53rad,[k(0)])
cetz.draw.hobby((-0.17, 0.71),(-0.01, 1.05),(0.36, 1.04),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.02, 0.18),node4.pos,decoration:"wave",angle:1.94rad)
cetz.draw.content((-0.09, 0.14),angle:1.94rad,[k(1)])
cetz.draw.hobby((-0.14, 0.53),(-0.02, 0.13),(0.18, -0.24),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.54, 0.57),node1.pos,decoration:"wave",angle:-1.51rad)
cetz.draw.content((0.66, 0.58),angle:-1.51rad,[k(1)])
cetz.draw.hobby((0.52, 0.21),(0.60, 0.56),(0.49, 0.90),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.22, -0.62),node2.pos,decoration:"arrow",angle:1.99rad)
cetz.draw.content((-0.11, -0.57),angle:1.99rad,[k(2)])
cetz.draw.hobby((-0.11, -0.85),(-0.17, -0.60),(-0.32, -0.39),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.50, -0.76),node3.pos,decoration:"coil",angle:2.03rad)
cetz.draw.content((-0.61, -0.81),angle:2.03rad,[k(2)+k(3)])
cetz.draw.hobby((-0.51, -0.40),(-0.56, -0.77),(-0.25, -0.98),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(-0.06, -0.07),node2.pos,decoration:"arrow",angle:0.61rad)
cetz.draw.content((-0.13, 0.03),angle:0.61rad,[k(3)])
cetz.draw.hobby((0.31, 0.19),(-0.06, -0.00),(-0.38, -0.27),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.16, -0.68),node4.pos,decoration:"arrow",angle:-2.21rad)
cetz.draw.content((0.25, -0.75),angle:-2.21rad,[k(3)])
cetz.draw.hobby((-0.07, -0.93),(0.21, -0.71),(0.34, -0.38),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.56, -0.12),node5.pos,decoration:"arrow",angle:-1.87rad)
cetz.draw.content((0.68, -0.16),angle:-1.87rad,[k(1)+k(3)])
cetz.draw.hobby((0.36, -0.35),(0.62, -0.14),(0.52, 0.18),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.82, 0.27))
node(node0.pos)
let node1= (pos:(-0.25, 0.86))
node(node1.pos)
let node2= (pos:(0.83, -0.75))
node(node2.pos)
let node3= (pos:(0.29, -0.23))
node(node3.pos)
let node4= (pos:(-0.33, -0.77))
node(node4.pos)
let node5= (pos:(0.80, 0.40))
node(node5.pos)
edge(node1.pos,(-0.45, 0.48),node0.pos,decoration:"arrow",angle:-2.34rad)
cetz.draw.content((-0.36, 0.40),angle:-2.34rad,[k(0)+k(1)])
cetz.draw.hobby((-0.21, 0.76),(-0.41, 0.44),(-0.72, 0.24),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.74, 0.77),node1.pos,decoration:"arrow",angle:0.80rad)
cetz.draw.content((-0.83, 0.85),angle:0.80rad,[k(0)])
cetz.draw.hobby((-0.92, 0.36),(-0.78, 0.81),(-0.34, 0.95),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.69, -0.30),node4.pos,decoration:"wave",angle:2.01rad)
cetz.draw.content((-0.80, -0.35),angle:2.01rad,[k(1)])
cetz.draw.hobby((-0.88, 0.14),(-0.75, -0.33),(-0.46, -0.73),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.32, 0.75),node1.pos,decoration:"wave",angle:-0.41rad)
cetz.draw.content((0.37, 0.86),angle:-0.41rad,[k(1)])
cetz.draw.hobby((0.76, 0.53),(0.35, 0.80),(-0.12, 0.92),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.57, -0.51),node2.pos,decoration:"coil",angle:2.38rad)
cetz.draw.content((0.49, -0.60),angle:2.38rad,[k(2)])
cetz.draw.hobby((0.30, -0.33),(0.51, -0.54),(0.73, -0.74),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.25, -0.95),node4.pos,decoration:"arrow",angle:-3.13rad)
cetz.draw.content((0.25, -1.07),angle:-3.13rad,[k(2)+k(3)])
cetz.draw.hobby((0.75, -0.87),(0.25, -1.01),(-0.25, -0.88),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(1.00, -0.17),node2.pos,decoration:"arrow",angle:-1.55rad)
cetz.draw.content((1.12, -0.17),angle:-1.55rad,[k(3)])
cetz.draw.hobby((0.92, 0.33),(1.06, -0.17),(0.94, -0.67),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(-0.07, -0.47),node3.pos,decoration:"arrow",angle:0.73rad)
cetz.draw.content((-0.15, -0.38),angle:0.73rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((-0.33, -0.66),(-0.10, -0.41),(0.19, -0.22),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.51, 0.14),node5.pos,decoration:"arrow",angle:0.88rad)
cetz.draw.content((0.42, 0.22),angle:0.88rad,[k(1)+k(3)])
cetz.draw.hobby((0.27, -0.13),(0.45, 0.16),(0.70, 0.40),stroke:stroke,mark: (end: ">"))
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