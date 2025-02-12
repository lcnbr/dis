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
let node0= (pos:(-0.40, 0.80))
node(node0.pos)
let node1= (pos:(-0.75, 0.30))
node(node1.pos)
let node2= (pos:(0.35, 0.41))
node(node2.pos)
let node3= (pos:(-0.11, -0.26))
node(node3.pos)
let node4= (pos:(0.63, -0.65))
node(node4.pos)
let node5= (pos:(0.98, -0.14))
node(node5.pos)
edge(node1.pos,(-0.77, 0.68),node0.pos,decoration:"arrow",angle:0.96rad)
cetz.draw.content((-0.87, 0.75),angle:0.96rad,[k(0)+k(1)])
cetz.draw.hobby((-0.85, 0.34),(-0.82, 0.72),(-0.47, 0.88),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.49, 0.49),node1.pos,decoration:"arrow",angle:-2.18rad)
cetz.draw.content((-0.39, 0.42),angle:-2.18rad,[k(0)])
cetz.draw.hobby((-0.34, 0.73),(-0.44, 0.46),(-0.66, 0.27),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.02, 0.69),node2.pos,decoration:"wave",angle:2.66rad)
cetz.draw.content((0.07, 0.80),angle:2.66rad,[k(1)])
cetz.draw.hobby((-0.30, 0.85),(0.05, 0.75),(0.34, 0.52),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.50, -0.05),node1.pos,decoration:"wave",angle:5.56rad)
cetz.draw.content((-0.58, -0.14),angle:5.56rad,[k(1)])
cetz.draw.hobby((-0.22, -0.29),(-0.53, -0.10),(-0.76, 0.19),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.11, 0.08),node2.pos,decoration:"arrow",angle:0.97rad)
cetz.draw.content((0.02, 0.14),angle:0.97rad,[k(2)])
cetz.draw.hobby((-0.12, -0.16),(0.07, 0.11),(0.25, 0.38),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.73, 0.21),node5.pos,decoration:"arrow",angle:-0.72rad)
cetz.draw.content((0.81, 0.30),angle:-0.72rad,[k(1)+k(2)])
cetz.draw.hobby((0.45, 0.44),(0.77, 0.26),(1.00, -0.03),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.22, -0.54),node3.pos,decoration:"arrow",angle:2.66rad)
cetz.draw.content((0.16, -0.65),angle:2.66rad,[k(1)+k(2)])
cetz.draw.hobby((0.54, -0.70),(0.18, -0.59),(-0.11, -0.37),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(1.00, -0.53),node5.pos,decoration:"coil",angle:-2.17rad)
cetz.draw.content((1.10, -0.60),angle:-2.17rad,[k(3)])
cetz.draw.hobby((0.71, -0.73),(1.05, -0.56),(1.08, -0.18),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.72, -0.34),node4.pos,decoration:"arrow",angle:4.11rad)
cetz.draw.content((0.62, -0.27),angle:4.11rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((0.89, -0.11),(0.67, -0.30),(0.57, -0.58),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.72, -0.32))
node(node0.pos)
let node1= (pos:(-0.77, 0.33))
node(node1.pos)
let node2= (pos:(0.16, -0.45))
node(node2.pos)
let node3= (pos:(0.09, 0.56))
node(node3.pos)
let node4= (pos:(0.76, -0.15))
node(node4.pos)
let node5= (pos:(0.73, 0.35))
node(node5.pos)
edge(node1.pos,(-0.99, -0.02),node0.pos,decoration:"arrow",angle:4.79rad)
cetz.draw.content((-1.11, -0.03),angle:4.79rad,[k(0)+k(1)])
cetz.draw.hobby((-0.88, 0.33),(-1.05, -0.02),(-0.83, -0.35),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.64, 0.01),node1.pos,decoration:"arrow",angle:1.65rad)
cetz.draw.content((-0.52, 0.02),angle:1.65rad,[k(0)])
cetz.draw.hobby((-0.63, -0.28),(-0.58, 0.01),(-0.67, 0.30),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.30, -0.47),node2.pos,decoration:"wave",angle:3.00rad)
cetz.draw.content((-0.31, -0.59),angle:3.00rad,[k(1)])
cetz.draw.hobby((-0.67, -0.42),(-0.30, -0.53),(0.08, -0.53),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.36, 0.53),node1.pos,decoration:"wave",angle:0.27rad)
cetz.draw.content((-0.40, 0.65),angle:0.27rad,[k(1)])
cetz.draw.hobby((0.00, 0.63),(-0.38, 0.59),(-0.73, 0.43),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.54, -0.47),node4.pos,decoration:"arrow",angle:-2.70rad)
cetz.draw.content((0.59, -0.58),angle:-2.70rad,[k(1)+k(2)])
cetz.draw.hobby((0.21, -0.54),(0.57, -0.53),(0.81, -0.25),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.38, -0.05),node2.pos,decoration:"arrow",angle:0.96rad)
cetz.draw.content((0.28, 0.02),angle:0.96rad,[k(2)])
cetz.draw.hobby((0.62, 0.32),(0.35, 0.02),(0.15, -0.33),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.37, 0.19),node4.pos,decoration:"arrow",angle:5.46rad)
cetz.draw.content((0.28, 0.11),angle:5.46rad,[k(3)])
cetz.draw.hobby((0.09, 0.44),(0.35, 0.13),(0.65, -0.14),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.46, 0.64),node3.pos,decoration:"arrow",angle:2.84rad)
cetz.draw.content((0.50, 0.75),angle:2.84rad,[k(1)+k(3)])
cetz.draw.hobby((0.76, 0.45),(0.49, 0.69),(0.13, 0.66),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(1.00, 0.11),node5.pos,decoration:"coil",angle:-1.51rad)
cetz.draw.content((1.12, 0.12),angle:-1.51rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((0.86, -0.19),(1.06, 0.12),(0.82, 0.40),stroke:stroke,mark: (end: ">"))
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