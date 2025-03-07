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
let node0= (pos:(-0.25, 0.78))
node(node0.pos)
let node1= (pos:(0.31, 0.78))
node(node1.pos)
let node2= (pos:(0.29, -0.76))
node(node2.pos)
let node3= (pos:(-0.28, -0.75))
node(node3.pos)
let node4= (pos:(-0.35, 0.02))
node(node4.pos)
let node5= (pos:(0.40, 0.01))
node(node5.pos)
edge(node1.pos,(0.03, 0.69),node0.pos,decoration:"arrow",angle:3.13rad)
cetz.draw.content((0.03, 0.57),angle:3.13rad,[k(0)+k(1)])
cetz.draw.hobby((0.29, 0.69),(0.03, 0.63),(-0.23, 0.70),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.03, 1.00),node1.pos,decoration:"arrow",angle:-0.01rad)
cetz.draw.content((0.03, 1.12),angle:-0.01rad,[k(0)])
cetz.draw.hobby((-0.27, 0.89),(0.03, 1.06),(0.34, 0.88),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.39, 0.42),node4.pos,decoration:"wave",angle:1.44rad)
cetz.draw.content((-0.51, 0.43),angle:1.44rad,[k(1)])
cetz.draw.hobby((-0.35, 0.74),(-0.45, 0.42),(-0.43, 0.08),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.45, 0.41),node1.pos,decoration:"wave",angle:-1.46rad)
cetz.draw.content((0.56, 0.42),angle:-1.46rad,[k(1)])
cetz.draw.hobby((0.48, 0.07),(0.51, 0.41),(0.41, 0.74),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.00, -0.97),node2.pos,decoration:"arrow",angle:6.26rad)
cetz.draw.content((0.00, -1.09),angle:6.26rad,[k(2)])
cetz.draw.hobby((-0.30, -0.85),(0.00, -1.03),(0.31, -0.86),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.01, -0.67),node3.pos,decoration:"coil",angle:-0.02rad)
cetz.draw.content((0.01, -0.55),angle:-0.02rad,[k(2)+k(3)])
cetz.draw.hobby((0.27, -0.67),(0.01, -0.60),(-0.25, -0.67),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.44, -0.39),node2.pos,decoration:"arrow",angle:1.43rad)
cetz.draw.content((0.55, -0.41),angle:1.43rad,[k(3)])
cetz.draw.hobby((0.48, -0.05),(0.50, -0.40),(0.39, -0.72),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.40, -0.38),node4.pos,decoration:"arrow",angle:4.81rad)
cetz.draw.content((-0.52, -0.39),angle:4.81rad,[k(3)])
cetz.draw.hobby((-0.37, -0.71),(-0.46, -0.38),(-0.43, -0.04),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.02, 0.01),node5.pos,decoration:"arrow",angle:3.13rad)
cetz.draw.content((0.02, -0.11),angle:3.13rad,[k(1)+k(3)])
cetz.draw.hobby((-0.28, -0.04),(0.02, -0.05),(0.32, -0.05),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.69, 0.60))
node(node0.pos)
let node1= (pos:(-0.04, 0.91))
node(node1.pos)
let node2= (pos:(0.61, -0.61))
node(node2.pos)
let node3= (pos:(0.10, -0.86))
node(node3.pos)
let node4= (pos:(-0.45, -0.36))
node(node4.pos)
let node5= (pos:(0.56, 0.13))
node(node5.pos)
edge(node1.pos,(-0.31, 0.65),node0.pos,decoration:"arrow",angle:-2.69rad)
cetz.draw.content((-0.26, 0.54),angle:-2.69rad,[k(0)+k(1)])
cetz.draw.hobby((-0.03, 0.81),(-0.29, 0.60),(-0.61, 0.53),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.48, 1.00),node1.pos,decoration:"arrow",angle:0.46rad)
cetz.draw.content((-0.54, 1.11),angle:0.46rad,[k(0)])
cetz.draw.hobby((-0.75, 0.70),(-0.51, 1.05),(-0.08, 1.03),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.67, 0.10),node4.pos,decoration:"wave",angle:1.81rad)
cetz.draw.content((-0.79, 0.07),angle:1.81rad,[k(1)])
cetz.draw.hobby((-0.76, 0.50),(-0.73, 0.08),(-0.56, -0.31),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.34, 0.59),node1.pos,decoration:"wave",angle:-0.91rad)
cetz.draw.content((0.43, 0.66),angle:-0.91rad,[k(1)])
cetz.draw.hobby((0.59, 0.25),(0.39, 0.62),(0.08, 0.91),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.48, -0.99),node2.pos,decoration:"coil",angle:-2.69rad)
cetz.draw.content((0.53, -1.09),angle:-2.69rad,[k(2)])
cetz.draw.hobby((0.11, -0.97),(0.50, -1.04),(0.69, -0.69),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.06, -0.42),node4.pos,decoration:"arrow",angle:2.92rad)
cetz.draw.content((0.08, -0.30),angle:2.92rad,[k(2)+k(3)])
cetz.draw.hobby((0.53, -0.51),(0.11, -0.37),(-0.34, -0.31),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.80, -0.22),node2.pos,decoration:"arrow",angle:-1.49rad)
cetz.draw.content((0.92, -0.21),angle:-1.49rad,[k(3)])
cetz.draw.hobby((0.67, 0.13),(0.86, -0.22),(0.72, -0.60),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(-0.32, -0.77),node3.pos,decoration:"arrow",angle:5.54rad)
cetz.draw.content((-0.40, -0.85),angle:5.54rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((-0.52, -0.45),(-0.36, -0.81),(0.02, -0.94),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.29, -0.31),node5.pos,decoration:"arrow",angle:1.12rad)
cetz.draw.content((0.19, -0.25),angle:1.12rad,[k(1)+k(3)])
cetz.draw.hobby((0.07, -0.74),(0.22, -0.31),(0.45, 0.07),stroke:stroke,mark: (end: ">"))
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