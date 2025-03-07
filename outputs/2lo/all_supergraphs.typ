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
let node0= (pos:(-0.26, 0.78))
node(node0.pos)
let node1= (pos:(0.31, 0.78))
node(node1.pos)
let node2= (pos:(0.31, -0.76))
node(node2.pos)
let node3= (pos:(-0.26, -0.77))
node(node3.pos)
let node4= (pos:(-0.34, 0.01))
node(node4.pos)
let node5= (pos:(0.40, 0.01))
node(node5.pos)
edge(node1.pos,(0.03, 0.69),node0.pos,decoration:"arrow",angle:-3.14rad)
cetz.draw.content((0.03, 0.57),angle:-3.14rad,[k(0)+k(1)])
cetz.draw.hobby((0.29, 0.70),(0.03, 0.63),(-0.23, 0.69),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.02, 1.00),node1.pos,decoration:"arrow",angle:0.00rad)
cetz.draw.content((0.02, 1.12),angle:0.00rad,[k(0)])
cetz.draw.hobby((-0.28, 0.88),(0.02, 1.06),(0.33, 0.88),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.39, 0.40),node4.pos,decoration:"wave",angle:1.46rad)
cetz.draw.content((-0.51, 0.42),angle:1.46rad,[k(1)])
cetz.draw.hobby((-0.35, 0.74),(-0.45, 0.41),(-0.43, 0.07),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.45, 0.41),node1.pos,decoration:"wave",angle:-1.45rad)
cetz.draw.content((0.56, 0.42),angle:-1.45rad,[k(1)])
cetz.draw.hobby((0.49, 0.07),(0.51, 0.41),(0.40, 0.74),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.03, -0.98),node2.pos,decoration:"arrow",angle:0.01rad)
cetz.draw.content((0.03, -1.10),angle:0.01rad,[k(2)])
cetz.draw.hobby((-0.28, -0.87),(0.03, -1.04),(0.34, -0.86),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.03, -0.67),node3.pos,decoration:"coil",angle:0.01rad)
cetz.draw.content((0.03, -0.55),angle:0.01rad,[k(2)+k(3)])
cetz.draw.hobby((0.29, -0.68),(0.03, -0.61),(-0.24, -0.68),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.45, -0.39),node2.pos,decoration:"arrow",angle:1.45rad)
cetz.draw.content((0.57, -0.40),angle:1.45rad,[k(3)])
cetz.draw.hobby((0.49, -0.05),(0.51, -0.39),(0.41, -0.72),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.39, -0.39),node4.pos,decoration:"arrow",angle:4.83rad)
cetz.draw.content((-0.51, -0.41),angle:4.83rad,[k(3)])
cetz.draw.hobby((-0.35, -0.72),(-0.45, -0.40),(-0.43, -0.05),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.03, 0.01),node5.pos,decoration:"arrow",angle:3.14rad)
cetz.draw.content((0.03, 0.13),angle:3.14rad,[k(1)+k(3)])
cetz.draw.hobby((-0.27, 0.07),(0.03, 0.07),(0.33, 0.07),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.63, 0.61))
node(node0.pos)
let node1= (pos:(-0.02, 0.92))
node(node1.pos)
let node2= (pos:(0.62, -0.52))
node(node2.pos)
let node3= (pos:(0.14, -0.76))
node(node3.pos)
let node4= (pos:(-0.39, -0.29))
node(node4.pos)
let node5= (pos:(0.56, 0.18))
node(node5.pos)
edge(node1.pos,(-0.28, 0.67),node0.pos,decoration:"arrow",angle:-2.67rad)
cetz.draw.content((-0.22, 0.57),angle:-2.67rad,[k(0)+k(1)])
cetz.draw.hobby((-0.01, 0.83),(-0.25, 0.62),(-0.56, 0.55),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.44, 1.00),node1.pos,decoration:"arrow",angle:0.47rad)
cetz.draw.content((-0.50, 1.11),angle:0.47rad,[k(0)])
cetz.draw.hobby((-0.70, 0.71),(-0.47, 1.05),(-0.06, 1.03),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.61, 0.14),node4.pos,decoration:"wave",angle:1.82rad)
cetz.draw.content((-0.72, 0.11),angle:1.82rad,[k(1)])
cetz.draw.hobby((-0.70, 0.52),(-0.66, 0.12),(-0.50, -0.25),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.35, 0.62),node1.pos,decoration:"wave",angle:-0.90rad)
cetz.draw.content((0.44, 0.69),angle:-0.90rad,[k(1)])
cetz.draw.hobby((0.59, 0.30),(0.40, 0.65),(0.10, 0.93),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.50, -0.88),node2.pos,decoration:"coil",angle:-2.67rad)
cetz.draw.content((0.56, -0.99),angle:-2.67rad,[k(2)])
cetz.draw.hobby((0.15, -0.87),(0.53, -0.94),(0.70, -0.60),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.09, -0.35),node4.pos,decoration:"arrow",angle:2.93rad)
cetz.draw.content((0.12, -0.23),angle:2.93rad,[k(2)+k(3)])
cetz.draw.hobby((0.54, -0.43),(0.14, -0.30),(-0.29, -0.24),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.79, -0.15),node2.pos,decoration:"arrow",angle:-1.48rad)
cetz.draw.content((0.91, -0.14),angle:-1.48rad,[k(3)])
cetz.draw.hobby((0.67, 0.19),(0.85, -0.15),(0.73, -0.51),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(-0.26, -0.67),node3.pos,decoration:"arrow",angle:5.55rad)
cetz.draw.content((-0.34, -0.76),angle:5.55rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((-0.46, -0.38),(-0.30, -0.72),(0.06, -0.84),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.31, -0.23),node5.pos,decoration:"arrow",angle:1.14rad)
cetz.draw.content((0.20, -0.18),angle:1.14rad,[k(1)+k(3)])
cetz.draw.hobby((0.11, -0.65),(0.24, -0.24),(0.45, 0.13),stroke:stroke,mark: (end: ">"))
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