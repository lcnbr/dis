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
let node0= (pos:(-0.35, 0.84))
node(node0.pos)
let node1= (pos:(-0.78, 0.34))
node(node1.pos)
let node2= (pos:(0.39, 0.34))
node(node2.pos)
let node3= (pos:(-0.17, -0.31))
node(node3.pos)
let node4= (pos:(0.58, -0.81))
node(node4.pos)
let node5= (pos:(1.00, -0.31))
node(node5.pos)
edge(node1.pos,(-0.75, 0.75),node0.pos,decoration:"arrow",angle:0.86rad)
cetz.draw.content((-0.84, 0.83),angle:0.86rad,[k(0)+k(1)])
cetz.draw.hobby((-0.87, 0.40),(-0.80, 0.79),(-0.42, 0.92),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.48, 0.52),node1.pos,decoration:"arrow",angle:-2.28rad)
cetz.draw.content((-0.39, 0.44),angle:-2.28rad,[k(0)])
cetz.draw.hobby((-0.30, 0.75),(-0.44, 0.48),(-0.69, 0.30),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.08, 0.67),node2.pos,decoration:"wave",angle:2.55rad)
cetz.draw.content((0.14, 0.77),angle:2.55rad,[k(1)])
cetz.draw.hobby((-0.25, 0.88),(0.11, 0.72),(0.39, 0.45),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.55, -0.06),node1.pos,decoration:"wave",angle:5.46rad)
cetz.draw.content((-0.64, -0.14),angle:5.46rad,[k(1)])
cetz.draw.hobby((-0.28, -0.33),(-0.59, -0.10),(-0.80, 0.23),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.11, 0.01),node2.pos,decoration:"arrow",angle:0.86rad)
cetz.draw.content((0.02, 0.09),angle:0.86rad,[k(2)])
cetz.draw.hobby((-0.16, -0.21),(0.07, 0.05),(0.29, 0.31),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.77, 0.08),node5.pos,decoration:"arrow",angle:-0.82rad)
cetz.draw.content((0.86, 0.16),angle:-0.82rad,[k(1)+k(2)])
cetz.draw.hobby((0.50, 0.36),(0.82, 0.13),(1.02, -0.20),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.15, -0.65),node3.pos,decoration:"arrow",angle:2.56rad)
cetz.draw.content((0.08, -0.75),angle:2.56rad,[k(1)+k(2)])
cetz.draw.hobby((0.47, -0.85),(0.11, -0.70),(-0.17, -0.43),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.98, -0.72),node5.pos,decoration:"coil",angle:-2.27rad)
cetz.draw.content((1.07, -0.80),angle:-2.27rad,[k(3)])
cetz.draw.hobby((0.65, -0.89),(1.03, -0.76),(1.10, -0.37),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.71, -0.49),node4.pos,decoration:"arrow",angle:4.01rad)
cetz.draw.content((0.62, -0.41),angle:4.01rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((0.91, -0.28),(0.66, -0.45),(0.53, -0.73),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.28, 1.00))
node(node0.pos)
let node1= (pos:(-0.81, 0.50))
node(node1.pos)
let node2= (pos:(0.54, 0.44))
node(node2.pos)
let node3= (pos:(-0.27, -0.35))
node(node3.pos)
let node4= (pos:(0.42, -0.65))
node(node4.pos)
let node5= (pos:(0.83, -0.26))
node(node5.pos)
edge(node1.pos,(-0.73, 0.95),node0.pos,decoration:"arrow",angle:0.76rad)
cetz.draw.content((-0.82, 1.03),angle:0.76rad,[k(0)+k(1)])
cetz.draw.hobby((-0.90, 0.57),(-0.78, 0.99),(-0.36, 1.10),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.46, 0.66),node1.pos,decoration:"arrow",angle:-2.38rad)
cetz.draw.content((-0.38, 0.58),angle:-2.38rad,[k(0)])
cetz.draw.hobby((-0.24, 0.91),(-0.42, 0.62),(-0.72, 0.45),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.19, 0.81),node2.pos,decoration:"wave",angle:2.54rad)
cetz.draw.content((0.25, 0.90),angle:2.54rad,[k(1)])
cetz.draw.hobby((-0.17, 1.03),(0.22, 0.85),(0.53, 0.56),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.63, 0.02),node1.pos,decoration:"wave",angle:5.27rad)
cetz.draw.content((-0.73, -0.04),angle:5.27rad,[k(1)])
cetz.draw.hobby((-0.39, -0.33),(-0.68, -0.01),(-0.85, 0.38),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.43, -0.06),node4.pos,decoration:"arrow",angle:1.45rad)
cetz.draw.content((0.31, -0.05),angle:1.45rad,[k(1)+k(2)])
cetz.draw.hobby((0.45, 0.35),(0.36, -0.10),(0.35, -0.55),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.88, 0.17),node2.pos,decoration:"arrow",angle:-1.17rad)
cetz.draw.content((0.99, 0.22),angle:-1.17rad,[k(2)])
cetz.draw.hobby((0.93, -0.21),(0.94, 0.19),(0.65, 0.47),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.02, -0.70),node4.pos,decoration:"arrow",angle:5.85rad)
cetz.draw.content((-0.07, -0.80),angle:5.85rad,[k(3)])
cetz.draw.hobby((-0.31, -0.46),(-0.04, -0.75),(0.37, -0.75),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.24, -0.25),node3.pos,decoration:"arrow",angle:3.23rad)
cetz.draw.content((0.23, -0.13),angle:3.23rad,[k(1)+k(3)])
cetz.draw.hobby((0.72, -0.19),(0.27, -0.19),(-0.18, -0.26),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.82, -0.66),node5.pos,decoration:"coil",angle:-2.37rad)
cetz.draw.content((0.91, -0.75),angle:-2.37rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((0.46, -0.76),(0.86, -0.71),(0.93, -0.31),stroke:stroke,mark: (end: ">"))
})
[
                            = d0
 overall factor: 2
                            
 symmetry group: 1]
grid(columns: cols,gutter: 20pt,box[#d00 ],)
pagebreak()
[
                            = d1
 overall factor: 1
                            
 symmetry group: 1]
grid(columns: cols,gutter: 20pt,box[#d10 ],)
pagebreak()
}