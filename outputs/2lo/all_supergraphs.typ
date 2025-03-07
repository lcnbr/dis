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
let node0= (pos:(-0.21, 0.81))
node(node0.pos)
let node1= (pos:(0.35, 0.76))
node(node1.pos)
let node2= (pos:(0.23, -0.76))
node(node2.pos)
let node3= (pos:(-0.33, -0.72))
node(node3.pos)
let node4= (pos:(-0.36, 0.05))
node(node4.pos)
let node5= (pos:(0.38, -0.00))
node(node5.pos)
edge(node1.pos,(0.06, 0.70),node0.pos,decoration:"arrow",angle:3.07rad)
cetz.draw.content((0.05, 0.58),angle:3.07rad,[k(0)+k(1)])
cetz.draw.hobby((0.32, 0.68),(0.06, 0.64),(-0.20, 0.72),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.08, 1.00),node1.pos,decoration:"arrow",angle:-0.07rad)
cetz.draw.content((0.09, 1.12),angle:-0.07rad,[k(0)])
cetz.draw.hobby((-0.23, 0.91),(0.09, 1.06),(0.38, 0.86),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.37, 0.45),node4.pos,decoration:"wave",angle:1.38rad)
cetz.draw.content((-0.49, 0.47),angle:1.38rad,[k(1)])
cetz.draw.hobby((-0.31, 0.77),(-0.43, 0.46),(-0.43, 0.12),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.45, 0.39),node1.pos,decoration:"wave",angle:-1.53rad)
cetz.draw.content((0.57, 0.39),angle:-1.53rad,[k(1)])
cetz.draw.hobby((0.47, 0.05),(0.51, 0.39),(0.44, 0.72),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.07, -0.95),node2.pos,decoration:"arrow",angle:6.22rad)
cetz.draw.content((-0.07, -1.07),angle:6.22rad,[k(2)])
cetz.draw.hobby((-0.36, -0.82),(-0.07, -1.01),(0.24, -0.86),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.05, -0.65),node3.pos,decoration:"coil",angle:-0.07rad)
cetz.draw.content((-0.04, -0.53),angle:-0.07rad,[k(2)+k(3)])
cetz.draw.hobby((0.21, -0.67),(-0.04, -0.59),(-0.30, -0.63),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.39, -0.40),node2.pos,decoration:"arrow",angle:1.37rad)
cetz.draw.content((0.51, -0.42),angle:1.37rad,[k(3)])
cetz.draw.hobby((0.46, -0.07),(0.45, -0.41),(0.33, -0.72),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.43, -0.34),node4.pos,decoration:"arrow",angle:4.74rad)
cetz.draw.content((-0.55, -0.34),angle:4.74rad,[k(3)])
cetz.draw.hobby((-0.42, -0.67),(-0.49, -0.34),(-0.44, -0.00),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.01, 0.02),node5.pos,decoration:"arrow",angle:3.07rad)
cetz.draw.content((0.01, -0.10),angle:3.07rad,[k(1)+k(3)])
cetz.draw.hobby((-0.29, -0.01),(0.01, -0.04),(0.30, -0.06),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.67, 0.61))
node(node0.pos)
let node1= (pos:(-0.07, 0.94))
node(node1.pos)
let node2= (pos:(0.62, -0.48))
node(node2.pos)
let node3= (pos:(0.15, -0.73))
node(node3.pos)
let node4= (pos:(-0.40, -0.28))
node(node4.pos)
let node5= (pos:(0.53, 0.23))
node(node5.pos)
edge(node1.pos,(-0.49, 1.00),node0.pos,decoration:"arrow",angle:3.64rad)
cetz.draw.content((-0.55, 1.11),angle:3.64rad,[k(0)+k(1)])
cetz.draw.hobby((-0.11, 1.05),(-0.52, 1.05),(-0.74, 0.70),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.32, 0.68),node1.pos,decoration:"arrow",angle:0.50rad)
cetz.draw.content((-0.26, 0.57),angle:0.50rad,[k(0)])
cetz.draw.hobby((-0.60, 0.55),(-0.29, 0.63),(-0.06, 0.84),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.63, 0.14),node4.pos,decoration:"wave",angle:1.87rad)
cetz.draw.content((-0.74, 0.10),angle:1.87rad,[k(1)])
cetz.draw.hobby((-0.74, 0.52),(-0.68, 0.12),(-0.51, -0.24),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.31, 0.65),node1.pos,decoration:"wave",angle:-0.86rad)
cetz.draw.content((0.40, 0.73),angle:-0.86rad,[k(1)])
cetz.draw.hobby((0.56, 0.34),(0.35, 0.69),(0.04, 0.95),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.51, -0.84),node2.pos,decoration:"coil",angle:-2.64rad)
cetz.draw.content((0.57, -0.94),angle:-2.64rad,[k(2)])
cetz.draw.hobby((0.16, -0.84),(0.54, -0.89),(0.70, -0.54),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.09, -0.32),node4.pos,decoration:"arrow",angle:2.97rad)
cetz.draw.content((0.11, -0.20),angle:2.97rad,[k(2)+k(3)])
cetz.draw.hobby((0.54, -0.38),(0.13, -0.27),(-0.29, -0.22),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.78, -0.10),node2.pos,decoration:"arrow",angle:-1.44rad)
cetz.draw.content((0.90, -0.08),angle:-1.44rad,[k(3)])
cetz.draw.hobby((0.64, 0.23),(0.84, -0.09),(0.73, -0.46),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(-0.25, -0.66),node3.pos,decoration:"arrow",angle:5.58rad)
cetz.draw.content((-0.33, -0.75),angle:5.58rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((-0.46, -0.37),(-0.29, -0.71),(0.08, -0.81),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.30, -0.20),node5.pos,decoration:"arrow",angle:1.18rad)
cetz.draw.content((0.19, -0.15),angle:1.18rad,[k(1)+k(3)])
cetz.draw.hobby((0.11, -0.62),(0.23, -0.21),(0.43, 0.17),stroke:stroke,mark: (end: ">"))
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