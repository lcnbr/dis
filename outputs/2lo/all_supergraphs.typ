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
let node0= (pos:(-0.20, 0.79))
node(node0.pos)
let node1= (pos:(0.36, 0.78))
node(node1.pos)
let node2= (pos:(0.31, -0.73))
node(node2.pos)
let node3= (pos:(-0.24, -0.71))
node(node3.pos)
let node4= (pos:(-0.30, 0.05))
node(node4.pos)
let node5= (pos:(0.43, 0.02))
node(node5.pos)
edge(node1.pos,(0.08, 0.70),node0.pos,decoration:"arrow",angle:3.12rad)
cetz.draw.content((0.08, 0.58),angle:3.12rad,[k(0)+k(1)])
cetz.draw.hobby((0.33, 0.70),(0.08, 0.64),(-0.18, 0.71),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.09, 1.00),node1.pos,decoration:"arrow",angle:-0.02rad)
cetz.draw.content((0.09, 1.12),angle:-0.02rad,[k(0)])
cetz.draw.hobby((-0.22, 0.89),(0.09, 1.06),(0.38, 0.88),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.34, 0.43),node4.pos,decoration:"wave",angle:1.43rad)
cetz.draw.content((-0.46, 0.45),angle:1.43rad,[k(1)])
cetz.draw.hobby((-0.29, 0.75),(-0.40, 0.44),(-0.38, 0.11),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.48, 0.41),node1.pos,decoration:"wave",angle:-1.48rad)
cetz.draw.content((0.60, 0.42),angle:-1.48rad,[k(1)])
cetz.draw.hobby((0.51, 0.08),(0.54, 0.41),(0.45, 0.74),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.03, -0.93),node2.pos,decoration:"arrow",angle:6.25rad)
cetz.draw.content((0.03, -1.05),angle:6.25rad,[k(2)])
cetz.draw.hobby((-0.27, -0.81),(0.03, -0.99),(0.33, -0.83),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.04, -0.63),node3.pos,decoration:"coil",angle:-0.03rad)
cetz.draw.content((0.04, -0.51),angle:-0.03rad,[k(2)+k(3)])
cetz.draw.hobby((0.30, -0.64),(0.04, -0.57),(-0.22, -0.63),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.46, -0.37),node2.pos,decoration:"arrow",angle:1.42rad)
cetz.draw.content((0.58, -0.39),angle:1.42rad,[k(3)])
cetz.draw.hobby((0.50, -0.04),(0.52, -0.37),(0.41, -0.69),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.36, -0.34),node4.pos,decoration:"arrow",angle:4.80rad)
cetz.draw.content((-0.48, -0.35),angle:4.80rad,[k(3)])
cetz.draw.hobby((-0.33, -0.67),(-0.42, -0.34),(-0.39, -0.01),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.06, 0.03),node5.pos,decoration:"arrow",angle:3.11rad)
cetz.draw.content((0.07, 0.15),angle:3.11rad,[k(1)+k(3)])
cetz.draw.hobby((-0.23, 0.10),(0.06, 0.09),(0.35, 0.09),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.94, 0.25))
node(node0.pos)
let node1= (pos:(-0.36, 0.89))
node(node1.pos)
let node2= (pos:(0.83, -0.77))
node(node2.pos)
let node3= (pos:(0.24, -0.25))
node(node3.pos)
let node4= (pos:(-0.39, -0.83))
node(node4.pos)
let node5= (pos:(0.76, 0.44))
node(node5.pos)
edge(node1.pos,(-0.56, 0.49),node0.pos,decoration:"arrow",angle:-2.31rad)
cetz.draw.content((-0.47, 0.41),angle:-2.31rad,[k(0)+k(1)])
cetz.draw.hobby((-0.32, 0.79),(-0.51, 0.45),(-0.83, 0.22),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.87, 0.77),node1.pos,decoration:"arrow",angle:0.84rad)
cetz.draw.content((-0.96, 0.85),angle:0.84rad,[k(0)])
cetz.draw.hobby((-1.04, 0.34),(-0.92, 0.81),(-0.46, 0.98),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.78, -0.35),node4.pos,decoration:"wave",angle:2.04rad)
cetz.draw.content((-0.89, -0.40),angle:2.04rad,[k(1)])
cetz.draw.hobby((-0.99, 0.11),(-0.84, -0.38),(-0.52, -0.79),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.25, 0.79),node1.pos,decoration:"wave",angle:-0.38rad)
cetz.draw.content((0.29, 0.90),angle:-0.38rad,[k(1)])
cetz.draw.hobby((0.71, 0.57),(0.27, 0.85),(-0.23, 0.96),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.55, -0.54),node2.pos,decoration:"coil",angle:2.42rad)
cetz.draw.content((0.47, -0.63),angle:2.42rad,[k(2)])
cetz.draw.hobby((0.26, -0.35),(0.49, -0.56),(0.73, -0.77),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.23, -1.00),node4.pos,decoration:"arrow",angle:-3.10rad)
cetz.draw.content((0.23, -1.12),angle:-3.10rad,[k(2)+k(3)])
cetz.draw.hobby((0.76, -0.90),(0.23, -1.06),(-0.30, -0.95),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.99, -0.15),node2.pos,decoration:"arrow",angle:-1.51rad)
cetz.draw.content((1.11, -0.15),angle:-1.51rad,[k(3)])
cetz.draw.hobby((0.88, 0.37),(1.05, -0.15),(0.95, -0.68),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(-0.13, -0.51),node3.pos,decoration:"arrow",angle:0.76rad)
cetz.draw.content((-0.21, -0.42),angle:0.76rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((-0.39, -0.72),(-0.15, -0.45),(0.14, -0.24),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.47, 0.15),node5.pos,decoration:"arrow",angle:0.92rad)
cetz.draw.content((0.37, 0.22),angle:0.92rad,[k(1)+k(3)])
cetz.draw.hobby((0.22, -0.15),(0.40, 0.17),(0.65, 0.43),stroke:stroke,mark: (end: ">"))
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