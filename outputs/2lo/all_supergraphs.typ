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
let node0= (pos:(-0.19, 0.60))
node(node0.pos)
let node1= (pos:(0.29, 0.95))
node(node1.pos)
let node2= (pos:(-0.43, -0.49))
node(node2.pos)
let node3= (pos:(-0.14, -1.00))
node(node3.pos)
let node4= (pos:(0.28, -0.32))
node(node4.pos)
let node5= (pos:(0.38, 0.16))
node(node5.pos)
edge(node1.pos,(0.10, 0.72),node0.pos,decoration:"arrow",angle:-2.50rad)
cetz.draw.content((0.17, 0.63),angle:-2.50rad,[k(0)+k(1)])
cetz.draw.hobby((0.31, 0.87),(0.13, 0.67),(-0.11, 0.56),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.09, 0.99),node1.pos,decoration:"arrow",angle:0.60rad)
cetz.draw.content((-0.16, 1.09),angle:0.60rad,[k(0)])
cetz.draw.hobby((-0.27, 0.67),(-0.14, 1.03),(0.25, 1.06),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.03, 0.14),node4.pos,decoration:"wave",angle:2.02rad)
cetz.draw.content((-0.14, 0.09),angle:2.02rad,[k(1)])
cetz.draw.hobby((-0.22, 0.48),(-0.07, 0.08),(0.17, -0.28),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.47, 0.58),node1.pos,decoration:"wave",angle:-1.44rad)
cetz.draw.content((0.59, 0.60),angle:-1.44rad,[k(1)])
cetz.draw.hobby((0.48, 0.22),(0.53, 0.58),(0.39, 0.93),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.22, -0.71),node2.pos,decoration:"arrow",angle:2.08rad)
cetz.draw.content((-0.11, -0.65),angle:2.08rad,[k(2)])
cetz.draw.hobby((-0.08, -0.93),(-0.17, -0.68),(-0.34, -0.48),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.50, -0.88),node3.pos,decoration:"coil",angle:2.12rad)
cetz.draw.content((-0.60, -0.94),angle:2.12rad,[k(2)+k(3)])
cetz.draw.hobby((-0.53, -0.51),(-0.56, -0.90),(-0.21, -1.08),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(-0.09, -0.13),node2.pos,decoration:"arrow",angle:0.69rad)
cetz.draw.content((-0.17, -0.04),angle:0.69rad,[k(3)])
cetz.draw.hobby((0.26, 0.17),(-0.10, -0.06),(-0.41, -0.37),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.18, -0.74),node4.pos,decoration:"arrow",angle:-2.13rad)
cetz.draw.content((0.28, -0.80),angle:-2.13rad,[k(3)])
cetz.draw.hobby((-0.03, -1.02),(0.24, -0.76),(0.34, -0.41),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.56, -0.13),node5.pos,decoration:"arrow",angle:-1.79rad)
cetz.draw.content((0.67, -0.15),angle:-1.79rad,[k(1)+k(3)])
cetz.draw.hobby((0.37, -0.38),(0.62, -0.14),(0.48, 0.18),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.88, 0.39))
node(node0.pos)
let node1= (pos:(-0.21, 0.97))
node(node1.pos)
let node2= (pos:(0.76, -0.85))
node(node2.pos)
let node3= (pos:(0.24, -0.25))
node(node3.pos)
let node4= (pos:(-0.47, -0.75))
node(node4.pos)
let node5= (pos:(0.84, 0.38))
node(node5.pos)
edge(node1.pos,(-0.47, 0.59),node0.pos,decoration:"arrow",angle:-2.43rad)
cetz.draw.content((-0.39, 0.50),angle:-2.43rad,[k(0)+k(1)])
cetz.draw.hobby((-0.19, 0.86),(-0.43, 0.55),(-0.78, 0.36),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.75, 0.92),node1.pos,decoration:"arrow",angle:0.70rad)
cetz.draw.content((-0.82, 1.01),angle:0.70rad,[k(0)])
cetz.draw.hobby((-0.97, 0.50),(-0.79, 0.96),(-0.30, 1.07),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.81, -0.22),node4.pos,decoration:"wave",angle:1.91rad)
cetz.draw.content((-0.92, -0.26),angle:1.91rad,[k(1)])
cetz.draw.hobby((-0.95, 0.27),(-0.86, -0.24),(-0.60, -0.70),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.38, 0.80),node1.pos,decoration:"wave",angle:-0.51rad)
cetz.draw.content((0.43, 0.90),angle:-0.51rad,[k(1)])
cetz.draw.hobby((0.81, 0.51),(0.41, 0.85),(-0.08, 1.02),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.52, -0.57),node2.pos,decoration:"coil",angle:2.29rad)
cetz.draw.content((0.61, -0.49),angle:2.29rad,[k(2)])
cetz.draw.hobby((0.33, -0.27),(0.54, -0.51),(0.75, -0.75),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.13, -1.00),node4.pos,decoration:"arrow",angle:3.06rad)
cetz.draw.content((0.12, -1.12),angle:3.06rad,[k(2)+k(3)])
cetz.draw.hobby((0.66, -0.97),(0.12, -1.06),(-0.40, -0.88),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(1.00, -0.25),node2.pos,decoration:"arrow",angle:-1.64rad)
cetz.draw.content((1.12, -0.26),angle:-1.64rad,[k(3)])
cetz.draw.hobby((0.96, 0.29),(1.06, -0.26),(0.89, -0.78),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(-0.17, -0.47),node3.pos,decoration:"arrow",angle:0.63rad)
cetz.draw.content((-0.24, -0.37),angle:0.63rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((-0.46, -0.65),(-0.18, -0.41),(0.13, -0.23),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.51, 0.12),node5.pos,decoration:"arrow",angle:0.79rad)
cetz.draw.content((0.43, 0.20),angle:0.79rad,[k(1)+k(3)])
cetz.draw.hobby((0.23, -0.14),(0.45, 0.14),(0.73, 0.38),stroke:stroke,mark: (end: ">"))
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