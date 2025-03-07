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
let node0= (pos:(-0.21, 0.72))
node(node0.pos)
let node1= (pos:(0.34, 0.67))
node(node1.pos)
let node2= (pos:(0.22, -0.81))
node(node2.pos)
let node3= (pos:(-0.33, -0.77))
node(node3.pos)
let node4= (pos:(-0.35, -0.02))
node(node4.pos)
let node5= (pos:(0.37, -0.08))
node(node5.pos)
edge(node1.pos,(0.06, 0.61),node0.pos,decoration:"arrow",angle:3.05rad)
cetz.draw.content((0.05, 0.49),angle:3.05rad,[k(0)+k(1)])
cetz.draw.hobby((0.31, 0.59),(0.05, 0.55),(-0.19, 0.64),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.09, 0.91),node1.pos,decoration:"arrow",angle:-0.09rad)
cetz.draw.content((0.10, 1.03),angle:-0.09rad,[k(0)])
cetz.draw.hobby((-0.22, 0.82),(0.09, 0.97),(0.37, 0.77),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.36, 0.37),node4.pos,decoration:"wave",angle:1.38rad)
cetz.draw.content((-0.48, 0.39),angle:1.38rad,[k(1)])
cetz.draw.hobby((-0.30, 0.69),(-0.42, 0.38),(-0.43, 0.05),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.44, 0.30),node1.pos,decoration:"wave",angle:-1.53rad)
cetz.draw.content((0.56, 0.31),angle:-1.53rad,[k(1)])
cetz.draw.hobby((0.46, -0.02),(0.50, 0.30),(0.43, 0.63),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.08, -1.00),node2.pos,decoration:"arrow",angle:6.20rad)
cetz.draw.content((-0.09, -1.12),angle:6.20rad,[k(2)])
cetz.draw.hobby((-0.37, -0.86),(-0.08, -1.06),(0.23, -0.91),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.05, -0.70),node3.pos,decoration:"coil",angle:-0.08rad)
cetz.draw.content((-0.04, -0.58),angle:-0.08rad,[k(2)+k(3)])
cetz.draw.hobby((0.20, -0.73),(-0.05, -0.64),(-0.31, -0.69),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.38, -0.47),node2.pos,decoration:"arrow",angle:1.36rad)
cetz.draw.content((0.50, -0.49),angle:1.36rad,[k(3)])
cetz.draw.hobby((0.45, -0.14),(0.44, -0.48),(0.31, -0.78),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.43, -0.40),node4.pos,decoration:"arrow",angle:4.74rad)
cetz.draw.content((-0.55, -0.40),angle:4.74rad,[k(3)])
cetz.draw.hobby((-0.42, -0.72),(-0.49, -0.40),(-0.44, -0.07),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.01, -0.05),node5.pos,decoration:"arrow",angle:3.06rad)
cetz.draw.content((0.00, -0.17),angle:3.06rad,[k(1)+k(3)])
cetz.draw.hobby((-0.28, -0.08),(0.00, -0.11),(0.29, -0.13),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.48, 0.67))
node(node0.pos)
let node1= (pos:(0.13, 0.87))
node(node1.pos)
let node2= (pos:(0.51, -0.56))
node(node2.pos)
let node3= (pos:(0.04, -0.71))
node(node3.pos)
let node4= (pos:(-0.39, -0.20))
node(node4.pos)
let node5= (pos:(0.56, 0.11))
node(node5.pos)
edge(node1.pos,(-0.25, 1.00),node0.pos,decoration:"arrow",angle:3.45rad)
cetz.draw.content((-0.29, 1.11),angle:3.45rad,[k(0)+k(1)])
cetz.draw.hobby((0.11, 0.98),(-0.27, 1.06),(-0.53, 0.77),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.15, 0.67),node1.pos,decoration:"arrow",angle:0.32rad)
cetz.draw.content((-0.11, 0.56),angle:0.32rad,[k(0)])
cetz.draw.hobby((-0.43, 0.60),(-0.13, 0.62),(0.13, 0.78),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.53, 0.23),node4.pos,decoration:"wave",angle:1.68rad)
cetz.draw.content((-0.65, 0.22),angle:1.68rad,[k(1)])
cetz.draw.hobby((-0.56, 0.60),(-0.59, 0.22),(-0.48, -0.15),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.42, 0.54),node1.pos,decoration:"wave",angle:-1.05rad)
cetz.draw.content((0.52, 0.60),angle:-1.05rad,[k(1)])
cetz.draw.hobby((0.60, 0.21),(0.47, 0.56),(0.24, 0.86),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.35, -0.87),node2.pos,decoration:"coil",angle:-2.83rad)
cetz.draw.content((0.38, -0.98),angle:-2.83rad,[k(2)])
cetz.draw.hobby((0.02, -0.81),(0.37, -0.93),(0.58, -0.63),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.05, -0.32),node4.pos,decoration:"arrow",angle:2.78rad)
cetz.draw.content((0.09, -0.21),angle:2.78rad,[k(2)+k(3)])
cetz.draw.hobby((0.46, -0.45),(0.10, -0.28),(-0.28, -0.16),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.72, -0.23),node2.pos,decoration:"arrow",angle:-1.63rad)
cetz.draw.content((0.84, -0.24),angle:-1.63rad,[k(3)])
cetz.draw.hobby((0.66, 0.10),(0.78, -0.24),(0.61, -0.56),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(-0.33, -0.57),node3.pos,decoration:"arrow",angle:5.39rad)
cetz.draw.content((-0.42, -0.65),angle:5.39rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((-0.47, -0.27),(-0.37, -0.61),(-0.05, -0.77),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.27, -0.25),node5.pos,decoration:"arrow",angle:0.99rad)
cetz.draw.content((0.17, -0.18),angle:0.99rad,[k(1)+k(3)])
cetz.draw.hobby((0.02, -0.60),(0.20, -0.24),(0.45, 0.08),stroke:stroke,mark: (end: ">"))
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