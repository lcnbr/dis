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
let node0= (pos:(-0.14, 0.81))
node(node0.pos)
let node1= (pos:(0.41, 0.76))
node(node1.pos)
let node2= (pos:(0.26, -0.73))
node(node2.pos)
let node3= (pos:(-0.29, -0.67))
node(node3.pos)
let node4= (pos:(-0.30, 0.08))
node(node4.pos)
let node5= (pos:(0.43, 0.01))
node(node5.pos)
edge(node1.pos,(0.15, 1.00),node0.pos,decoration:"arrow",angle:3.06rad)
cetz.draw.content((0.16, 1.12),angle:3.06rad,[k(0)+k(1)])
cetz.draw.hobby((0.44, 0.86),(0.16, 1.06),(-0.16, 0.91),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.13, 0.70),node1.pos,decoration:"arrow",angle:6.19rad)
cetz.draw.content((0.12, 0.58),angle:6.19rad,[k(0)])
cetz.draw.hobby((-0.13, 0.73),(0.12, 0.64),(0.38, 0.68),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.30, 0.47),node4.pos,decoration:"wave",angle:1.36rad)
cetz.draw.content((-0.42, 0.49),angle:1.36rad,[k(1)])
cetz.draw.hobby((-0.24, 0.78),(-0.36, 0.48),(-0.37, 0.15),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.51, 0.39),node1.pos,decoration:"wave",angle:-1.54rad)
cetz.draw.content((0.63, 0.40),angle:-1.54rad,[k(1)])
cetz.draw.hobby((0.51, 0.06),(0.57, 0.39),(0.50, 0.72),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.03, -0.91),node2.pos,decoration:"arrow",angle:6.18rad)
cetz.draw.content((-0.04, -1.03),angle:6.18rad,[k(2)])
cetz.draw.hobby((-0.32, -0.77),(-0.04, -0.97),(0.28, -0.83),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.00, -0.61),node3.pos,decoration:"coil",angle:-0.09rad)
cetz.draw.content((0.01, -0.49),angle:-0.09rad,[k(2)+k(3)])
cetz.draw.hobby((0.25, -0.64),(0.00, -0.55),(-0.26, -0.59),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.43, -0.38),node2.pos,decoration:"arrow",angle:1.35rad)
cetz.draw.content((0.55, -0.41),angle:1.35rad,[k(3)])
cetz.draw.hobby((0.50, -0.06),(0.49, -0.39),(0.36, -0.70),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.38, -0.30),node4.pos,decoration:"arrow",angle:4.73rad)
cetz.draw.content((-0.50, -0.30),angle:4.73rad,[k(3)])
cetz.draw.hobby((-0.37, -0.63),(-0.44, -0.30),(-0.38, 0.03),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.07, 0.04),node5.pos,decoration:"arrow",angle:3.05rad)
cetz.draw.content((0.05, -0.08),angle:3.05rad,[k(1)+k(3)])
cetz.draw.hobby((-0.23, 0.01),(0.06, -0.02),(0.35, -0.04),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.46, 0.70))
node(node0.pos)
let node1= (pos:(0.14, 0.85))
node(node1.pos)
let node2= (pos:(0.41, -0.54))
node(node2.pos)
let node3= (pos:(-0.06, -0.65))
node(node3.pos)
let node4= (pos:(-0.43, -0.14))
node(node4.pos)
let node5= (pos:(0.50, 0.09))
node(node5.pos)
edge(node1.pos,(-0.22, 1.00),node0.pos,decoration:"arrow",angle:3.39rad)
cetz.draw.content((-0.25, 1.12),angle:3.39rad,[k(0)+k(1)])
cetz.draw.hobby((0.13, 0.96),(-0.23, 1.06),(-0.50, 0.80),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.13, 0.68),node1.pos,decoration:"arrow",angle:0.25rad)
cetz.draw.content((-0.11, 0.57),angle:0.25rad,[k(0)])
cetz.draw.hobby((-0.41, 0.62),(-0.12, 0.62),(0.13, 0.76),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.53, 0.28),node4.pos,decoration:"wave",angle:1.60rad)
cetz.draw.content((-0.65, 0.28),angle:1.60rad,[k(1)])
cetz.draw.hobby((-0.54, 0.64),(-0.59, 0.27),(-0.52, -0.08),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.40, 0.52),node1.pos,decoration:"wave",angle:-1.12rad)
cetz.draw.content((0.51, 0.57),angle:-1.12rad,[k(1)])
cetz.draw.hobby((0.55, 0.19),(0.45, 0.54),(0.25, 0.84),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.23, -0.83),node2.pos,decoration:"coil",angle:0.24rad)
cetz.draw.content((0.26, -0.94),angle:0.24rad,[k(2)])
cetz.draw.hobby((-0.08, -0.75),(0.25, -0.88),(0.48, -0.62),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.01, -0.28),node4.pos,decoration:"arrow",angle:2.71rad)
cetz.draw.content((0.04, -0.17),angle:2.71rad,[k(2)+k(3)])
cetz.draw.hobby((0.37, -0.43),(0.04, -0.24),(-0.32, -0.11),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.64, -0.24),node2.pos,decoration:"arrow",angle:-1.70rad)
cetz.draw.content((0.75, -0.26),angle:-1.70rad,[k(3)])
cetz.draw.hobby((0.60, 0.08),(0.69, -0.26),(0.51, -0.55),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(-0.39, -0.50),node3.pos,decoration:"arrow",angle:5.32rad)
cetz.draw.content((-0.49, -0.57),angle:5.32rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((-0.51, -0.20),(-0.44, -0.54),(-0.14, -0.71),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.20, -0.22),node5.pos,decoration:"arrow",angle:0.92rad)
cetz.draw.content((0.11, -0.15),angle:0.92rad,[k(1)+k(3)])
cetz.draw.hobby((-0.07, -0.54),(0.13, -0.22),(0.39, 0.07),stroke:stroke,mark: (end: ">"))
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