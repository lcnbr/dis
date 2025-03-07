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
let node0= (pos:(-0.18, 0.80))
node(node0.pos)
let node1= (pos:(0.39, 0.76))
node(node1.pos)
let node2= (pos:(0.26, -0.78))
node(node2.pos)
let node3= (pos:(-0.31, -0.74))
node(node3.pos)
let node4= (pos:(-0.33, 0.04))
node(node4.pos)
let node5= (pos:(0.42, -0.02))
node(node5.pos)
edge(node1.pos,(0.10, 0.69),node0.pos,decoration:"arrow",angle:3.07rad)
cetz.draw.content((0.09, 0.57),angle:3.07rad,[k(0)+k(1)])
cetz.draw.hobby((0.36, 0.68),(0.09, 0.63),(-0.16, 0.72),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.12, 1.00),node1.pos,decoration:"arrow",angle:-0.07rad)
cetz.draw.content((0.13, 1.12),angle:-0.07rad,[k(0)])
cetz.draw.hobby((-0.19, 0.90),(0.13, 1.06),(0.42, 0.86),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.34, 0.44),node4.pos,decoration:"wave",angle:1.38rad)
cetz.draw.content((-0.46, 0.46),angle:1.38rad,[k(1)])
cetz.draw.hobby((-0.28, 0.77),(-0.40, 0.45),(-0.40, 0.11),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.50, 0.38),node1.pos,decoration:"wave",angle:-1.53rad)
cetz.draw.content((0.62, 0.38),angle:-1.53rad,[k(1)])
cetz.draw.hobby((0.51, 0.04),(0.56, 0.38),(0.48, 0.71),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.04, -0.98),node2.pos,decoration:"arrow",angle:6.20rad)
cetz.draw.content((-0.05, -1.10),angle:6.20rad,[k(2)])
cetz.draw.hobby((-0.34, -0.84),(-0.05, -1.04),(0.28, -0.89),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.02, -0.67),node3.pos,decoration:"coil",angle:-0.08rad)
cetz.draw.content((-0.01, -0.55),angle:-0.08rad,[k(2)+k(3)])
cetz.draw.hobby((0.24, -0.70),(-0.01, -0.61),(-0.28, -0.66),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.43, -0.42),node2.pos,decoration:"arrow",angle:1.36rad)
cetz.draw.content((0.55, -0.45),angle:1.36rad,[k(3)])
cetz.draw.hobby((0.50, -0.09),(0.49, -0.43),(0.36, -0.75),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.41, -0.35),node4.pos,decoration:"arrow",angle:4.74rad)
cetz.draw.content((-0.53, -0.36),angle:4.74rad,[k(3)])
cetz.draw.hobby((-0.40, -0.69),(-0.47, -0.35),(-0.41, -0.01),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.05, 0.01),node5.pos,decoration:"arrow",angle:3.06rad)
cetz.draw.content((0.06, 0.13),angle:3.06rad,[k(1)+k(3)])
cetz.draw.hobby((-0.25, 0.09),(0.05, 0.07),(0.35, 0.04),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.93, 0.33))
node(node0.pos)
let node1= (pos:(-0.29, 0.94))
node(node1.pos)
let node2= (pos:(0.77, -0.82))
node(node2.pos)
let node3= (pos:(0.22, -0.25))
node(node3.pos)
let node4= (pos:(-0.45, -0.78))
node(node4.pos)
let node5= (pos:(0.79, 0.40))
node(node5.pos)
edge(node1.pos,(-0.52, 0.55),node0.pos,decoration:"arrow",angle:-2.38rad)
cetz.draw.content((-0.44, 0.46),angle:-2.38rad,[k(0)+k(1)])
cetz.draw.hobby((-0.26, 0.83),(-0.48, 0.50),(-0.82, 0.30),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.82, 0.85),node1.pos,decoration:"arrow",angle:0.77rad)
cetz.draw.content((-0.90, 0.94),angle:0.77rad,[k(0)])
cetz.draw.hobby((-1.02, 0.43),(-0.86, 0.90),(-0.39, 1.04),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.82, -0.27),node4.pos,decoration:"wave",angle:1.97rad)
cetz.draw.content((-0.93, -0.32),angle:1.97rad,[k(1)])
cetz.draw.hobby((-0.99, 0.21),(-0.87, -0.30),(-0.59, -0.74),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.30, 0.80),node1.pos,decoration:"wave",angle:-0.46rad)
cetz.draw.content((0.36, 0.91),angle:-0.46rad,[k(1)])
cetz.draw.hobby((0.75, 0.54),(0.34, 0.85),(-0.16, 0.99),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.51, -0.56),node2.pos,decoration:"coil",angle:2.34rad)
cetz.draw.content((0.43, -0.64),angle:2.34rad,[k(2)])
cetz.draw.hobby((0.23, -0.35),(0.45, -0.58),(0.68, -0.81),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.15, -1.00),node4.pos,decoration:"arrow",angle:3.11rad)
cetz.draw.content((0.15, -1.12),angle:3.11rad,[k(2)+k(3)])
cetz.draw.hobby((0.69, -0.94),(0.15, -1.06),(-0.38, -0.91),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.98, -0.21),node2.pos,decoration:"arrow",angle:-1.58rad)
cetz.draw.content((1.10, -0.21),angle:-1.58rad,[k(3)])
cetz.draw.hobby((0.91, 0.32),(1.04, -0.21),(0.90, -0.74),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(-0.17, -0.49),node3.pos,decoration:"arrow",angle:0.68rad)
cetz.draw.content((-0.25, -0.39),angle:0.68rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((-0.45, -0.68),(-0.19, -0.42),(0.12, -0.23),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.48, 0.13),node5.pos,decoration:"arrow",angle:0.85rad)
cetz.draw.content((0.39, 0.21),angle:0.85rad,[k(1)+k(3)])
cetz.draw.hobby((0.21, -0.15),(0.42, 0.15),(0.68, 0.40),stroke:stroke,mark: (end: ">"))
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