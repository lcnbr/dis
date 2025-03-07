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
let node0= (pos:(-0.05, 0.83))
node(node0.pos)
let node1= (pos:(0.51, 0.74))
node(node1.pos)
let node2= (pos:(0.27, -0.79))
node(node2.pos)
let node3= (pos:(-0.29, -0.70))
node(node3.pos)
let node4= (pos:(-0.25, 0.08))
node(node4.pos)
let node5= (pos:(0.49, -0.04))
node(node5.pos)
edge(node1.pos,(0.22, 0.69),node0.pos,decoration:"arrow",angle:2.99rad)
cetz.draw.content((0.20, 0.58),angle:2.99rad,[k(0)+k(1)])
cetz.draw.hobby((0.48, 0.66),(0.21, 0.64),(-0.04, 0.74),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.27, 1.00),node1.pos,decoration:"arrow",angle:-0.15rad)
cetz.draw.content((0.28, 1.12),angle:-0.15rad,[k(0)])
cetz.draw.hobby((-0.06, 0.93),(0.27, 1.06),(0.55, 0.84),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.24, 0.48),node4.pos,decoration:"wave",angle:1.30rad)
cetz.draw.content((-0.35, 0.51),angle:1.30rad,[k(1)])
cetz.draw.hobby((-0.15, 0.80),(-0.30, 0.49),(-0.33, 0.15),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.59, 0.35),node1.pos,decoration:"wave",angle:-1.60rad)
cetz.draw.content((0.71, 0.35),angle:-1.60rad,[k(1)])
cetz.draw.hobby((0.58, 0.01),(0.65, 0.35),(0.60, 0.68),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.05, -0.96),node2.pos,decoration:"arrow",angle:6.12rad)
cetz.draw.content((-0.06, -1.08),angle:6.12rad,[k(2)])
cetz.draw.hobby((-0.33, -0.80),(-0.05, -1.02),(0.28, -0.89),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.00, -0.66),node3.pos,decoration:"coil",angle:-0.15rad)
cetz.draw.content((0.02, -0.54),angle:-0.15rad,[k(2)+k(3)])
cetz.draw.hobby((0.26, -0.70),(0.01, -0.60),(-0.26, -0.62),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.47, -0.44),node2.pos,decoration:"arrow",angle:1.29rad)
cetz.draw.content((0.58, -0.47),angle:1.29rad,[k(3)])
cetz.draw.hobby((0.56, -0.11),(0.52, -0.46),(0.37, -0.76),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.36, -0.31),node4.pos,decoration:"arrow",angle:4.67rad)
cetz.draw.content((-0.48, -0.31),angle:4.67rad,[k(3)])
cetz.draw.hobby((-0.38, -0.65),(-0.42, -0.31),(-0.35, 0.03),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.12, 0.02),node5.pos,decoration:"arrow",angle:2.99rad)
cetz.draw.content((0.14, 0.14),angle:2.99rad,[k(1)+k(3)])
cetz.draw.hobby((-0.17, 0.12),(0.13, 0.08),(0.42, 0.03),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.75, 0.57))
node(node0.pos)
let node1= (pos:(-0.15, 0.98))
node(node1.pos)
let node2= (pos:(0.73, -0.45))
node(node2.pos)
let node3= (pos:(0.26, -0.77))
node(node3.pos)
let node4= (pos:(-0.37, -0.35))
node(node4.pos)
let node5= (pos:(0.57, 0.29))
node(node5.pos)
edge(node1.pos,(-0.38, 0.68),node0.pos,decoration:"arrow",angle:-2.54rad)
cetz.draw.content((-0.32, 0.58),angle:-2.54rad,[k(0)+k(1)])
cetz.draw.hobby((-0.13, 0.88),(-0.35, 0.63),(-0.67, 0.51),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.60, 1.00),node1.pos,decoration:"arrow",angle:0.60rad)
cetz.draw.content((-0.67, 1.10),angle:0.60rad,[k(0)])
cetz.draw.hobby((-0.83, 0.66),(-0.64, 1.05),(-0.21, 1.09),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.66, 0.07),node4.pos,decoration:"wave",angle:1.97rad)
cetz.draw.content((-0.77, 0.03),angle:1.97rad,[k(1)])
cetz.draw.hobby((-0.81, 0.46),(-0.71, 0.05),(-0.48, -0.32),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.28, 0.71),node1.pos,decoration:"wave",angle:-0.77rad)
cetz.draw.content((0.36, 0.80),angle:-0.77rad,[k(1)])
cetz.draw.hobby((0.58, 0.41),(0.32, 0.75),(-0.03, 0.99),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.66, -0.84),node2.pos,decoration:"coil",angle:-2.54rad)
cetz.draw.content((0.72, -0.94),angle:-2.54rad,[k(2)])
cetz.draw.hobby((0.29, -0.88),(0.69, -0.89),(0.83, -0.52),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.15, -0.34),node4.pos,decoration:"arrow",angle:3.06rad)
cetz.draw.content((0.16, -0.22),angle:3.06rad,[k(2)+k(3)])
cetz.draw.hobby((0.64, -0.36),(0.19, -0.28),(-0.26, -0.28),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.86, -0.03),node2.pos,decoration:"arrow",angle:-1.34rad)
cetz.draw.content((0.97, -0.01),angle:-1.34rad,[k(3)])
cetz.draw.hobby((0.68, 0.30),(0.92, -0.03),(0.84, -0.42),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(-0.18, -0.73),node3.pos,decoration:"arrow",angle:5.67rad)
cetz.draw.content((-0.24, -0.83),angle:5.67rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((-0.42, -0.45),(-0.20, -0.79),(0.19, -0.86),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.37, -0.19),node5.pos,decoration:"arrow",angle:1.28rad)
cetz.draw.content((0.25, -0.15),angle:1.28rad,[k(1)+k(3)])
cetz.draw.hobby((0.21, -0.66),(0.30, -0.21),(0.46, 0.21),stroke:stroke,mark: (end: ">"))
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