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
let node0= (pos:(0.07, -0.83))
node(node0.pos)
let node1= (pos:(0.90, -0.08))
node(node1.pos)
let node2= (pos:(-0.90, 0.24))
node(node2.pos)
let node3= (pos:(-0.07, 1.00))
node(node3.pos)
edge(node1.pos,(0.77, -0.77),node0.pos,decoration:"arrow",angle:-2.41rad)
cetz.draw.content((0.85, -0.86),angle:-2.41rad,[k(0)+k(1)])
cetz.draw.hobby((1.01, -0.21),(0.82, -0.82),(0.19, -0.95),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.37, -0.32),node1.pos,decoration:"arrow",angle:0.73rad)
cetz.draw.content((0.29, -0.23),angle:0.73rad,[k(0)])
cetz.draw.hobby((0.05, -0.69),(0.33, -0.27),(0.77, -0.04),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.58, -0.45),node2.pos,decoration:"wave",angle:5.45rad)
cetz.draw.content((-0.67, -0.53),angle:5.45rad,[k(1)])
cetz.draw.hobby((-0.10, -0.84),(-0.63, -0.48),(-0.93, 0.08),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.58, 0.61),node1.pos,decoration:"wave",angle:2.30rad)
cetz.draw.content((0.67, 0.69),angle:2.30rad,[k(1)])
cetz.draw.hobby((0.10, 1.01),(0.63, 0.65),(0.93, 0.09),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.36, 0.49),node2.pos,decoration:"arrow",angle:0.74rad)
cetz.draw.content((-0.28, 0.40),angle:0.74rad,[k(2)])
cetz.draw.hobby((-0.04, 0.87),(-0.32, 0.45),(-0.77, 0.21),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.77, 0.94),node3.pos,decoration:"arrow",angle:3.88rad)
cetz.draw.content((-0.86, 1.03),angle:3.88rad,[k(1)+k(2)])
cetz.draw.hobby((-1.01, 0.37),(-0.81, 0.98),(-0.19, 1.12),stroke:stroke,mark: (end: ">"))
})
[
                            = d0
 overall factor: -1
                            
 symmetry group: 1]
grid(columns: cols,gutter: 20pt,box[#d00 ],)
pagebreak()
}