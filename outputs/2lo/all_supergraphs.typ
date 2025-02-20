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
let node0= (pos:(-0.85, -0.01))
node(node0.pos)
let node1= (pos:(-0.50, 0.86))
node(node1.pos)
let node2= (pos:(0.50, 0.38))
node(node2.pos)
let node3= (pos:(0.20, -0.43))
node(node3.pos)
let node4= (pos:(0.48, -0.79))
node(node4.pos)
let node5= (pos:(0.97, 0.50))
node(node5.pos)
edge(node1.pos,(-1.00, 0.56),node0.pos,decoration:"arrow",angle:4.33rad)
cetz.draw.content((-1.11, 0.60),angle:4.33rad,[k(0)+k(1)])
cetz.draw.hobby((-0.64, 0.92),(-1.06, 0.58),(-0.99, 0.04),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.59, 0.39),node1.pos,decoration:"arrow",angle:1.19rad)
cetz.draw.content((-0.48, 0.35),angle:1.19rad,[k(0)])
cetz.draw.hobby((-0.74, 0.02),(-0.53, 0.37),(-0.44, 0.76),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.35, -0.52),node4.pos,decoration:"wave",angle:2.56rad)
cetz.draw.content((-0.41, -0.62),angle:2.56rad,[k(1)])
cetz.draw.hobby((-0.81, -0.18),(-0.31, -0.61),(0.31, -0.83),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.20, 0.87),node1.pos,decoration:"wave",angle:-0.20rad)
cetz.draw.content((0.23, 0.99),angle:-0.20rad,[k(1)])
cetz.draw.hobby((0.88, 0.64),(0.29, 0.91),(-0.35, 0.95),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.59, -0.11),node2.pos,decoration:"arrow",angle:1.21rad)
cetz.draw.content((0.70, -0.16),angle:1.21rad,[k(2)])
cetz.draw.hobby((0.32, -0.46),(0.64, -0.14),(0.61, 0.32),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.11, 0.06),node3.pos,decoration:"coil",angle:1.21rad)
cetz.draw.content((-0.00, 0.11),angle:1.21rad,[k(2)+k(3)])
cetz.draw.hobby((0.38, 0.41),(0.05, 0.08),(0.08, -0.37),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.79, 0.85),node2.pos,decoration:"arrow",angle:-0.33rad)
cetz.draw.content((0.83, 0.96),angle:-0.33rad,[k(3)])
cetz.draw.hobby((1.04, 0.62),(0.61, 0.91),(0.38, 0.45),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.12, -0.97),node4.pos,decoration:"arrow",angle:2.80rad)
cetz.draw.content((0.08, -1.09),angle:2.80rad,[k(3)])
cetz.draw.hobby((0.05, -0.41),(-0.05, -0.92),(0.47, -0.94),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.95, -0.23),node5.pos,decoration:"arrow",angle:-1.93rad)
cetz.draw.content((1.06, -0.27),angle:-1.93rad,[k(1)+k(3)])
cetz.draw.hobby((0.64, -0.75),(1.00, -0.25),(1.06, 0.36),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.60, 0.63))
node(node0.pos)
let node1= (pos:(-0.02, 0.92))
node(node1.pos)
let node2= (pos:(0.58, -0.46))
node(node2.pos)
let node3= (pos:(0.12, -0.68))
node(node3.pos)
let node4= (pos:(-0.38, -0.23))
node(node4.pos)
let node5= (pos:(0.53, 0.22))
node(node5.pos)
edge(node1.pos,(-0.42, 1.00),node0.pos,decoration:"arrow",angle:3.60rad)
cetz.draw.content((-0.47, 1.11),angle:3.60rad,[k(0)+k(1)])
cetz.draw.hobby((-0.05, 1.03),(-0.45, 1.05),(-0.67, 0.73),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.26, 0.69),node1.pos,decoration:"arrow",angle:0.46rad)
cetz.draw.content((-0.21, 0.58),angle:0.46rad,[k(0)])
cetz.draw.hobby((-0.54, 0.57),(-0.24, 0.63),(-0.00, 0.83),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.58, 0.18),node4.pos,decoration:"wave",angle:1.82rad)
cetz.draw.content((-0.70, 0.15),angle:1.82rad,[k(1)])
cetz.draw.hobby((-0.67, 0.55),(-0.64, 0.16),(-0.48, -0.19),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.33, 0.63),node1.pos,decoration:"wave",angle:-0.91rad)
cetz.draw.content((0.43, 0.70),angle:-0.91rad,[k(1)])
cetz.draw.hobby((0.56, 0.32),(0.38, 0.66),(0.10, 0.93),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.46, -0.80),node2.pos,decoration:"coil",angle:0.45rad)
cetz.draw.content((0.51, -0.91),angle:0.45rad,[k(2)])
cetz.draw.hobby((0.13, -0.79),(0.49, -0.85),(0.66, -0.53),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.08, -0.29),node4.pos,decoration:"arrow",angle:2.92rad)
cetz.draw.content((0.11, -0.17),angle:2.92rad,[k(2)+k(3)])
cetz.draw.hobby((0.51, -0.36),(0.13, -0.24),(-0.28, -0.17),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.75, -0.10),node2.pos,decoration:"arrow",angle:-1.49rad)
cetz.draw.content((0.87, -0.10),angle:-1.49rad,[k(3)])
cetz.draw.hobby((0.64, 0.22),(0.81, -0.11),(0.68, -0.45),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(-0.26, -0.60),node3.pos,decoration:"arrow",angle:5.54rad)
cetz.draw.content((-0.34, -0.68),angle:5.54rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((-0.45, -0.31),(-0.30, -0.64),(0.05, -0.76),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.29, -0.18),node5.pos,decoration:"arrow",angle:1.13rad)
cetz.draw.content((0.18, -0.13),angle:1.13rad,[k(1)+k(3)])
cetz.draw.hobby((0.09, -0.57),(0.22, -0.19),(0.42, 0.17),stroke:stroke,mark: (end: ">"))
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
                            
 symmetry group: 1]
grid(columns: cols,gutter: 20pt,box[#d10 ],)
pagebreak()
}