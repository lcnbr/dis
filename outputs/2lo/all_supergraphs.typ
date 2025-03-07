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
let node0= (pos:(-0.36, 0.43))
node(node0.pos)
let node1= (pos:(-0.06, 0.91))
node(node1.pos)
let node2= (pos:(-0.22, -0.62))
node(node2.pos)
let node3= (pos:(0.21, -1.00))
node(node3.pos)
let node4= (pos:(0.37, -0.25))
node(node4.pos)
let node5= (pos:(0.30, 0.23))
node(node5.pos)
edge(node1.pos,(-0.41, 0.80),node0.pos,decoration:"arrow",angle:4.11rad)
cetz.draw.content((-0.51, 0.87),angle:4.11rad,[k(0)+k(1)])
cetz.draw.hobby((-0.13, 0.99),(-0.47, 0.83),(-0.46, 0.45),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.15, 0.63),node1.pos,decoration:"arrow",angle:1.02rad)
cetz.draw.content((-0.05, 0.57),angle:1.02rad,[k(0)])
cetz.draw.hobby((-0.28, 0.41),(-0.10, 0.60),(-0.01, 0.84),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.06, 0.06),node4.pos,decoration:"wave",angle:2.38rad)
cetz.draw.content((-0.15, -0.02),angle:2.38rad,[k(1)])
cetz.draw.hobby((-0.35, 0.31),(-0.08, -0.00),(0.25, -0.25),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.23, 0.63),node1.pos,decoration:"wave",angle:-1.07rad)
cetz.draw.content((0.34, 0.69),angle:-1.07rad,[k(1)])
cetz.draw.hobby((0.37, 0.31),(0.29, 0.65),(0.05, 0.92),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.16, -1.00),node2.pos,decoration:"arrow",angle:2.45rad)
cetz.draw.content((-0.24, -1.09),angle:2.45rad,[k(2)])
cetz.draw.hobby((0.16, -1.10),(-0.21, -1.04),(-0.31, -0.68),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.04, -0.76),node3.pos,decoration:"coil",angle:2.41rad)
cetz.draw.content((0.13, -0.67),angle:2.41rad,[k(2)+k(3)])
cetz.draw.hobby((-0.14, -0.58),(0.08, -0.71),(0.24, -0.92),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(-0.03, -0.19),node2.pos,decoration:"arrow",angle:1.04rad)
cetz.draw.content((-0.13, -0.13),angle:1.04rad,[k(3)])
cetz.draw.hobby((0.19, 0.20),(-0.06, -0.13),(-0.24, -0.51),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.42, -0.66),node4.pos,decoration:"arrow",angle:-1.79rad)
cetz.draw.content((0.53, -0.68),angle:-1.79rad,[k(3)])
cetz.draw.hobby((0.31, -0.98),(0.48, -0.66),(0.46, -0.31),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.55, 0.02),node5.pos,decoration:"arrow",angle:-1.44rad)
cetz.draw.content((0.67, 0.03),angle:-1.44rad,[k(1)+k(3)])
cetz.draw.hobby((0.47, -0.27),(0.61, 0.03),(0.39, 0.28),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.83, 0.30))
node(node0.pos)
let node1= (pos:(-0.27, 0.92))
node(node1.pos)
let node2= (pos:(0.84, -0.67))
node(node2.pos)
let node3= (pos:(0.29, -0.17))
node(node3.pos)
let node4= (pos:(-0.31, -0.72))
node(node4.pos)
let node5= (pos:(0.78, 0.48))
node(node5.pos)
edge(node1.pos,(-0.47, 0.53),node0.pos,decoration:"arrow",angle:-2.30rad)
cetz.draw.content((-0.38, 0.45),angle:-2.30rad,[k(0)+k(1)])
cetz.draw.hobby((-0.24, 0.82),(-0.42, 0.49),(-0.73, 0.27),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.77, 0.80),node1.pos,decoration:"arrow",angle:0.84rad)
cetz.draw.content((-0.86, 0.88),angle:0.84rad,[k(0)])
cetz.draw.hobby((-0.93, 0.39),(-0.81, 0.84),(-0.37, 1.01),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.69, -0.26),node4.pos,decoration:"wave",angle:2.04rad)
cetz.draw.content((-0.79, -0.31),angle:2.04rad,[k(1)])
cetz.draw.hobby((-0.88, 0.18),(-0.74, -0.29),(-0.44, -0.68),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.30, 0.82),node1.pos,decoration:"wave",angle:-0.39rad)
cetz.draw.content((0.34, 0.93),angle:-0.39rad,[k(1)])
cetz.draw.hobby((0.74, 0.61),(0.33, 0.88),(-0.15, 0.98),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.58, -0.44),node2.pos,decoration:"coil",angle:2.41rad)
cetz.draw.content((0.50, -0.53),angle:2.41rad,[k(2)])
cetz.draw.hobby((0.30, -0.27),(0.52, -0.47),(0.75, -0.67),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.27, -0.88),node4.pos,decoration:"arrow",angle:-3.10rad)
cetz.draw.content((0.28, -1.00),angle:-3.10rad,[k(2)+k(3)])
cetz.draw.hobby((0.77, -0.79),(0.28, -0.94),(-0.23, -0.83),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(1.00, -0.08),node2.pos,decoration:"arrow",angle:-1.52rad)
cetz.draw.content((1.12, -0.08),angle:-1.52rad,[k(3)])
cetz.draw.hobby((0.90, 0.41),(1.06, -0.08),(0.96, -0.59),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(-0.07, -0.41),node3.pos,decoration:"arrow",angle:0.75rad)
cetz.draw.content((-0.15, -0.33),angle:0.75rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((-0.32, -0.61),(-0.09, -0.36),(0.19, -0.16),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.50, 0.21),node5.pos,decoration:"arrow",angle:0.91rad)
cetz.draw.content((0.41, 0.28),angle:0.91rad,[k(1)+k(3)])
cetz.draw.hobby((0.27, -0.07),(0.44, 0.23),(0.68, 0.48),stroke:stroke,mark: (end: ">"))
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