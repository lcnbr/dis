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
let node0= (pos:(-0.41, -0.35))
node(node0.pos)
let node1= (pos:(-0.84, 0.39))
node(node1.pos)
let node2= (pos:(0.46, -0.38))
node(node2.pos)
let node3= (pos:(-0.48, 0.20))
node(node3.pos)
let node4= (pos:(-0.12, -0.47))
node(node4.pos)
let node5= (pos:(1.00, 0.71))
node(node5.pos)
edge(node1.pos,(0.26, 0.93),node0.pos,decoration:"arrow",angle:-0.55rad)
cetz.draw.content((0.32, 1.03),angle:-0.55rad,[k(0)+k(1)])
cetz.draw.hobby((-0.77, 0.76),(0.56, 0.71),(-0.05, -0.47),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.17, 0.17),node1.pos,decoration:"arrow",angle:1.57rad)
cetz.draw.content((0.29, 0.17),angle:1.57rad,[k(0)])
cetz.draw.hobby((-0.16, -0.38),(0.15, 0.47),(-0.75, 0.62),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.04, 0.40),node4.pos,decoration:"wave",angle:2.96rad)
cetz.draw.content((-0.02, 0.52),angle:2.96rad,[k(1)])
cetz.draw.hobby((-0.60, -0.17),(0.06, 0.43),(0.14, -0.45),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.37, -0.60),node1.pos,decoration:"wave",angle:0.26rad)
cetz.draw.content((0.40, -0.72),angle:0.26rad,[k(1)])
cetz.draw.hobby((1.14, 0.37),(0.29, -0.68),(-0.86, 0.03),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.73, -0.27),node2.pos,decoration:"arrow",angle:4.69rad)
cetz.draw.content((-0.85, -0.27),angle:4.69rad,[k(2)])
cetz.draw.hobby((-0.69, 0.07),(-0.49, -0.85),(0.43, -0.64),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.19, 0.78),node3.pos,decoration:"coil",angle:0.61rad)
cetz.draw.content((-0.26, 0.87),angle:0.61rad,[k(2)+k(3)])
cetz.draw.hobby((0.74, -0.26),(0.58, 0.84),(-0.48, 0.51),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.17, 0.03),node2.pos,decoration:"arrow",angle:1.76rad)
cetz.draw.content((0.05, 0.00),angle:1.76rad,[k(3)])
cetz.draw.hobby((0.83, 0.81),(0.16, 0.44),(0.27, -0.31),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.53, -0.14),node4.pos,decoration:"arrow",angle:1.22rad)
cetz.draw.content((0.64, -0.18),angle:1.22rad,[k(3)])
cetz.draw.hobby((-0.39, 0.46),(0.55, 0.32),(0.14, -0.54),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.57, 0.41),node5.pos,decoration:"arrow",angle:3.84rad)
cetz.draw.content((0.49, 0.50),angle:3.84rad,[k(1)+k(3)])
cetz.draw.hobby((-0.09, -0.29),(0.31, 0.25),(0.83, 0.67),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.41, -0.35))
node(node0.pos)
let node1= (pos:(-0.84, 0.39))
node(node1.pos)
let node2= (pos:(0.46, -0.38))
node(node2.pos)
let node3= (pos:(-0.48, 0.20))
node(node3.pos)
let node4= (pos:(-0.11, -0.47))
node(node4.pos)
let node5= (pos:(1.00, 0.71))
node(node5.pos)
edge(node1.pos,(0.26, 0.93),node0.pos,decoration:"arrow",angle:-0.56rad)
cetz.draw.content((0.33, 1.03),angle:-0.56rad,[k(0)+k(1)])
cetz.draw.hobby((-0.77, 0.76),(0.56, 0.71),(-0.05, -0.47),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.17, 0.17),node1.pos,decoration:"arrow",angle:1.57rad)
cetz.draw.content((0.29, 0.17),angle:1.57rad,[k(0)])
cetz.draw.hobby((-0.16, -0.38),(0.15, 0.47),(-0.75, 0.62),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.04, 0.40),node4.pos,decoration:"wave",angle:2.96rad)
cetz.draw.content((-0.02, 0.52),angle:2.96rad,[k(1)])
cetz.draw.hobby((-0.60, -0.17),(0.05, 0.43),(0.15, -0.44),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.37, -0.60),node1.pos,decoration:"wave",angle:0.26rad)
cetz.draw.content((0.40, -0.72),angle:0.26rad,[k(1)])
cetz.draw.hobby((1.14, 0.37),(0.29, -0.68),(-0.86, 0.03),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.73, -0.27),node2.pos,decoration:"coil",angle:4.69rad)
cetz.draw.content((-0.85, -0.27),angle:4.69rad,[k(2)])
cetz.draw.hobby((-0.69, 0.07),(-0.49, -0.85),(0.43, -0.64),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.20, 0.78),node4.pos,decoration:"arrow",angle:3.59rad)
cetz.draw.content((-0.25, 0.88),angle:3.59rad,[k(2)+k(3)])
cetz.draw.hobby((0.75, -0.14),(-0.01, 0.89),(-0.45, -0.31),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.17, 0.02),node2.pos,decoration:"arrow",angle:4.92rad)
cetz.draw.content((0.05, -0.01),angle:4.92rad,[k(3)])
cetz.draw.hobby((0.83, 0.81),(0.16, 0.44),(0.27, -0.31),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.53, -0.14),node3.pos,decoration:"arrow",angle:1.22rad)
cetz.draw.content((0.64, -0.18),angle:1.22rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((0.15, -0.53),(0.55, 0.33),(-0.40, 0.46),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.57, 0.41),node5.pos,decoration:"arrow",angle:0.47rad)
cetz.draw.content((0.63, 0.30),angle:0.47rad,[k(1)+k(3)])
cetz.draw.hobby((-0.32, 0.14),(0.33, 0.24),(0.91, 0.56),stroke:stroke,mark: (end: ">"))
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