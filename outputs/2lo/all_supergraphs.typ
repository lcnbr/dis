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
let node0= (pos:(-0.55, -0.34))
node(node0.pos)
let node1= (pos:(-0.37, -0.07))
node(node1.pos)
let node2= (pos:(0.34, -0.59))
node(node2.pos)
let node3= (pos:(-0.60, 0.28))
node(node3.pos)
let node4= (pos:(-0.12, -0.55))
node(node4.pos)
let node5= (pos:(0.78, 0.71))
node(node5.pos)
edge(node1.pos,(0.48, 0.50),node0.pos,decoration:"arrow",angle:0.27rad)
cetz.draw.content((0.45, 0.62),angle:0.27rad,[k(0)+k(1)])
cetz.draw.hobby((0.43, 0.55),(2.38, -2.03),(-0.78, -1.33),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.21, 0.64),node1.pos,decoration:"arrow",angle:3.93rad)
cetz.draw.content((0.13, 0.72),angle:3.93rad,[k(0)])
cetz.draw.hobby((-1.34, -3.47),(8.42, -5.93),(2.15, 1.95),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.11, 0.62),node4.pos,decoration:"wave",angle:2.79rad)
cetz.draw.content((0.15, 0.73),angle:2.79rad,[k(1)])
cetz.draw.hobby((-0.74, -0.05),(0.20, 0.65),(0.22, -0.53),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.67, -0.68),node1.pos,decoration:"wave",angle:0.37rad)
cetz.draw.content((0.71, -0.79),angle:0.37rad,[k(1)])
cetz.draw.hobby((1.06, 0.54),(0.86, -0.64),(-0.32, -0.39),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.73, -0.55),node2.pos,decoration:"arrow",angle:5.26rad)
cetz.draw.content((-0.83, -0.61),angle:5.26rad,[k(2)])
cetz.draw.hobby((-0.79, 0.14),(-0.65, -0.73),(0.23, -0.79),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.40, 1.00),node3.pos,decoration:"coil",angle:0.92rad)
cetz.draw.content((-0.50, 1.07),angle:0.92rad,[k(2)+k(3)])
cetz.draw.hobby((0.84, -0.54),(1.09, 1.17),(-0.60, 0.77),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.45, -0.33),node2.pos,decoration:"arrow",angle:1.21rad)
cetz.draw.content((0.56, -0.37),angle:1.21rad,[k(3)])
cetz.draw.hobby((0.80, 0.57),(0.64, 0.04),(0.45, -0.48),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.48, -0.16),node4.pos,decoration:"arrow",angle:1.24rad)
cetz.draw.content((0.59, -0.20),angle:1.24rad,[k(3)])
cetz.draw.hobby((-0.48, 0.52),(0.48, 0.35),(0.15, -0.57),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.56, 0.36),node5.pos,decoration:"arrow",angle:-2.15rad)
cetz.draw.content((0.66, 0.29),angle:-2.15rad,[k(1)+k(3)])
cetz.draw.hobby((0.02, -0.47),(0.40, 0.03),(0.75, 0.55),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.55, -0.34))
node(node0.pos)
let node1= (pos:(-0.37, -0.07))
node(node1.pos)
let node2= (pos:(0.34, -0.59))
node(node2.pos)
let node3= (pos:(-0.60, 0.28))
node(node3.pos)
let node4= (pos:(-0.12, -0.55))
node(node4.pos)
let node5= (pos:(0.78, 0.71))
node(node5.pos)
edge(node1.pos,(0.48, 0.50),node0.pos,decoration:"arrow",angle:0.27rad)
cetz.draw.content((0.45, 0.62),angle:0.27rad,[k(0)+k(1)])
cetz.draw.hobby((0.43, 0.55),(2.38, -2.03),(-0.78, -1.33),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.21, 0.64),node1.pos,decoration:"arrow",angle:3.93rad)
cetz.draw.content((0.13, 0.72),angle:3.93rad,[k(0)])
cetz.draw.hobby((-1.34, -3.47),(8.42, -5.93),(2.15, 1.95),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.11, 0.62),node4.pos,decoration:"wave",angle:2.79rad)
cetz.draw.content((0.15, 0.73),angle:2.79rad,[k(1)])
cetz.draw.hobby((-0.74, -0.05),(0.20, 0.65),(0.22, -0.53),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.67, -0.68),node1.pos,decoration:"wave",angle:0.37rad)
cetz.draw.content((0.71, -0.79),angle:0.37rad,[k(1)])
cetz.draw.hobby((1.06, 0.54),(0.86, -0.64),(-0.32, -0.39),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.73, -0.55),node2.pos,decoration:"coil",angle:5.26rad)
cetz.draw.content((-0.83, -0.61),angle:5.26rad,[k(2)])
cetz.draw.hobby((-0.79, 0.14),(-0.65, -0.73),(0.23, -0.79),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.40, 1.00),node4.pos,decoration:"arrow",angle:3.85rad)
cetz.draw.content((-0.48, 1.09),angle:3.85rad,[k(2)+k(3)])
cetz.draw.hobby((0.85, -0.40),(0.27, 1.27),(-0.59, -0.27),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.45, -0.33),node2.pos,decoration:"arrow",angle:-1.93rad)
cetz.draw.content((0.56, -0.37),angle:-1.93rad,[k(3)])
cetz.draw.hobby((0.80, 0.57),(0.64, 0.04),(0.45, -0.48),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.48, -0.16),node3.pos,decoration:"arrow",angle:1.24rad)
cetz.draw.content((0.59, -0.20),angle:1.24rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((0.15, -0.57),(0.48, 0.35),(-0.48, 0.52),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.56, 0.36),node5.pos,decoration:"arrow",angle:0.78rad)
cetz.draw.content((0.64, 0.27),angle:0.78rad,[k(1)+k(3)])
cetz.draw.hobby((-0.48, 0.13),(0.22, 0.09),(0.76, 0.53),stroke:stroke,mark: (end: ">"))
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