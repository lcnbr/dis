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
let node0= (pos:(0.64, 0.58))
node(node0.pos)
let node1= (pos:(0.65, -0.34))
node(node1.pos)
let node2= (pos:(-0.54, 0.57))
node(node2.pos)
let node3= (pos:(-0.53, -0.35))
node(node3.pos)
edge(node1.pos,(1.00, 0.12),node0.pos,decoration:"arrow",angle:1.58rad)
cetz.draw.content((1.12, 0.12),angle:1.58rad,[k(0)+k(1)])
cetz.draw.hobby((0.80, -0.34),(1.06, 0.12),(0.79, 0.58),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.50, 0.12),node1.pos,decoration:"arrow",angle:4.72rad)
cetz.draw.content((0.38, 0.12),angle:4.72rad,[k(0)])
cetz.draw.hobby((0.54, 0.52),(0.44, 0.12),(0.55, -0.29),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.05, 0.76),node2.pos,decoration:"wave",angle:0.01rad)
cetz.draw.content((0.05, 0.88),angle:0.01rad,[k(1)])
cetz.draw.hobby((0.56, 0.69),(0.05, 0.82),(-0.46, 0.69),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.07, -0.53),node1.pos,decoration:"wave",angle:-3.13rad)
cetz.draw.content((0.07, -0.65),angle:-3.13rad,[k(1)])
cetz.draw.hobby((-0.45, -0.47),(0.07, -0.59),(0.58, -0.46),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.89, 0.11),node2.pos,decoration:"arrow",angle:1.58rad)
cetz.draw.content((-1.01, 0.10),angle:1.58rad,[k(2)])
cetz.draw.hobby((-0.67, -0.35),(-0.95, 0.11),(-0.68, 0.57),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.39, 0.11),node3.pos,decoration:"arrow",angle:-1.56rad)
cetz.draw.content((-0.27, 0.11),angle:-1.56rad,[k(1)+k(2)])
cetz.draw.hobby((-0.43, 0.51),(-0.33, 0.11),(-0.42, -0.29),stroke:stroke,mark: (end: ">"))
})
[
                            #pagebreak
= d0
 overall factor: 1]
grid(columns: cols,gutter: 20pt,d00,)
}