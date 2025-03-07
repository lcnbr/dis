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
let node0= (pos:(-0.14, 0.54))
node(node0.pos)
let node1= (pos:(0.34, 0.84))
node(node1.pos)
let node2= (pos:(-0.47, -0.48))
node(node2.pos)
let node3= (pos:(-0.24, -1.00))
node(node3.pos)
let node4= (pos:(0.23, -0.38))
node(node4.pos)
let node5= (pos:(0.37, 0.07))
node(node5.pos)
edge(node1.pos,(0.14, 0.64),node0.pos,decoration:"arrow",angle:-2.58rad)
cetz.draw.content((0.20, 0.54),angle:-2.58rad,[k(0)+k(1)])
cetz.draw.hobby((0.36, 0.75),(0.17, 0.58),(-0.07, 0.49),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.02, 0.90),node1.pos,decoration:"arrow",angle:0.52rad)
cetz.draw.content((-0.08, 1.01),angle:0.52rad,[k(0)])
cetz.draw.hobby((-0.22, 0.61),(-0.06, 0.95),(0.32, 0.94),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.03, 0.09),node4.pos,decoration:"wave",angle:1.93rad)
cetz.draw.content((-0.14, 0.05),angle:1.93rad,[k(1)])
cetz.draw.hobby((-0.19, 0.43),(-0.07, 0.03),(0.12, -0.33),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.49, 0.46),node1.pos,decoration:"wave",angle:-1.53rad)
cetz.draw.content((0.61, 0.47),angle:-1.53rad,[k(1)])
cetz.draw.hobby((0.47, 0.11),(0.55, 0.46),(0.44, 0.80),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.29, -0.72),node2.pos,decoration:"arrow",angle:1.98rad)
cetz.draw.content((-0.18, -0.67),angle:1.98rad,[k(2)])
cetz.draw.hobby((-0.18, -0.94),(-0.23, -0.69),(-0.38, -0.48),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.57, -0.84),node3.pos,decoration:"coil",angle:2.01rad)
cetz.draw.content((-0.68, -0.89),angle:2.01rad,[k(2)+k(3)])
cetz.draw.hobby((-0.57, -0.49),(-0.63, -0.86),(-0.32, -1.07),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(-0.11, -0.17),node2.pos,decoration:"arrow",angle:0.60rad)
cetz.draw.content((-0.18, -0.07),angle:0.60rad,[k(3)])
cetz.draw.hobby((0.25, 0.09),(-0.12, -0.10),(-0.44, -0.36),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.09, -0.77),node4.pos,decoration:"arrow",angle:-2.23rad)
cetz.draw.content((0.19, -0.85),angle:-2.23rad,[k(3)])
cetz.draw.hobby((-0.14, -1.03),(0.14, -0.80),(0.28, -0.47),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.50, -0.22),node5.pos,decoration:"arrow",angle:-1.88rad)
cetz.draw.content((0.62, -0.26),angle:-1.88rad,[k(1)+k(3)])
cetz.draw.hobby((0.30, -0.45),(0.56, -0.24),(0.47, 0.08),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.47, 0.70))
node(node0.pos)
let node1= (pos:(0.15, 0.84))
node(node1.pos)
let node2= (pos:(0.39, -0.58))
node(node2.pos)
let node3= (pos:(-0.08, -0.69))
node(node3.pos)
let node4= (pos:(-0.45, -0.16))
node(node4.pos)
let node5= (pos:(0.50, 0.06))
node(node5.pos)
edge(node1.pos,(-0.14, 0.67),node0.pos,decoration:"arrow",angle:-2.92rad)
cetz.draw.content((-0.11, 0.56),angle:-2.92rad,[k(0)+k(1)])
cetz.draw.hobby((0.14, 0.75),(-0.12, 0.62),(-0.42, 0.62),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.21, 1.00),node1.pos,decoration:"arrow",angle:0.22rad)
cetz.draw.content((-0.24, 1.12),angle:0.22rad,[k(0)])
cetz.draw.hobby((-0.51, 0.80),(-0.22, 1.06),(0.14, 0.95),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.55, 0.27),node4.pos,decoration:"wave",angle:1.59rad)
cetz.draw.content((-0.67, 0.27),angle:1.59rad,[k(1)])
cetz.draw.hobby((-0.55, 0.64),(-0.61, 0.27),(-0.54, -0.09),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.40, 0.49),node1.pos,decoration:"wave",angle:-1.15rad)
cetz.draw.content((0.51, 0.54),angle:-1.15rad,[k(1)])
cetz.draw.hobby((0.55, 0.15),(0.46, 0.51),(0.25, 0.82),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.21, -0.87),node2.pos,decoration:"coil",angle:-2.92rad)
cetz.draw.content((0.24, -0.99),angle:-2.92rad,[k(2)])
cetz.draw.hobby((-0.10, -0.79),(0.22, -0.93),(0.46, -0.66),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.03, -0.31),node4.pos,decoration:"arrow",angle:2.69rad)
cetz.draw.content((0.02, -0.20),angle:2.69rad,[k(2)+k(3)])
cetz.draw.hobby((0.35, -0.47),(0.02, -0.27),(-0.34, -0.12),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.63, -0.29),node2.pos,decoration:"arrow",angle:-1.72rad)
cetz.draw.content((0.75, -0.30),angle:-1.72rad,[k(3)])
cetz.draw.hobby((0.60, 0.04),(0.69, -0.30),(0.49, -0.59),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(-0.42, -0.52),node3.pos,decoration:"arrow",angle:5.30rad)
cetz.draw.content((-0.52, -0.59),angle:5.30rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((-0.53, -0.22),(-0.47, -0.56),(-0.17, -0.75),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.19, -0.26),node5.pos,decoration:"arrow",angle:0.90rad)
cetz.draw.content((0.09, -0.18),angle:0.90rad,[k(1)+k(3)])
cetz.draw.hobby((-0.09, -0.58),(0.12, -0.25),(0.38, 0.04),stroke:stroke,mark: (end: ">"))
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