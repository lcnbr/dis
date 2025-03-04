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
let node0= (pos:(0.38, -0.89))
node(node0.pos)
let node1= (pos:(0.52, -0.31))
node(node1.pos)
let node2= (pos:(-0.36, 0.51))
node(node2.pos)
let node3= (pos:(0.11, -0.34))
node(node3.pos)
edge(node1.pos,(0.45, 0.45),node0.pos,decoration:"arrow",angle:1.83rad)
cetz.draw.content((0.57, 0.48),angle:1.83rad,[k(0)+k(1)])
cetz.draw.hobby((0.30, 0.99),(-3.85, 0.39),(-0.38, -1.96),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.07, 0.63),node1.pos,decoration:"arrow",angle:-0.50rad)
cetz.draw.content((-0.01, 0.74),angle:-0.50rad,[k(0)])
cetz.draw.hobby((-0.04, -1.39),(-1.76, -0.09),(0.36, 0.33),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.11, 0.58),node2.pos,decoration:"wave",angle:-0.14rad)
cetz.draw.content((0.12, 0.70),angle:-0.14rad,[k(1)])
cetz.draw.hobby((0.62, -0.78),(0.74, 0.20),(-0.13, 0.64),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.93, -0.89),node1.pos,decoration:"wave",angle:-1.63rad)
cetz.draw.content((1.05, -0.90),angle:-1.63rad,[k(1)])
cetz.draw.hobby((-0.18, -0.52),(0.42, -1.49),(0.83, -0.43),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.68, -0.56),node2.pos,decoration:"arrow",angle:5.76rad)
cetz.draw.content((-0.74, -0.67),angle:5.76rad,[k(2)])
cetz.draw.hobby((-0.01, -0.57),(-0.95, -0.37),(-0.62, 0.53),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.38, 1.00),node3.pos,decoration:"arrow",angle:4.60rad)
cetz.draw.content((-0.50, 1.01),angle:4.60rad,[k(1)+k(2)])
cetz.draw.hobby((-0.33, 1.42),(2.66, 1.62),(0.89, -0.81),stroke:stroke,mark: (end: ">"))
})
[
                            = d0
 overall factor: -1
                            
 symmetry group: 1]
grid(columns: cols,gutter: 20pt,box[#d00 ],)
pagebreak()
}