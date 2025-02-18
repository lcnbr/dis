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
let node0= (pos:(-0.08, -0.83))
node(node0.pos)
let node1= (pos:(0.84, -0.25))
node(node1.pos)
let node2= (pos:(-0.83, 0.36))
node(node2.pos)
let node3= (pos:(0.09, 0.94))
node(node3.pos)
edge(node1.pos,(0.60, -0.90),node0.pos,decoration:"arrow",angle:-2.58rad)
cetz.draw.content((0.66, -1.00),angle:-2.58rad,[k(0)+k(1)])
cetz.draw.hobby((0.92, -0.40),(0.63, -0.95),(0.01, -0.97),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.29, -0.39),node1.pos,decoration:"arrow",angle:0.56rad)
cetz.draw.content((0.22, -0.29),angle:0.56rad,[k(0)])
cetz.draw.hobby((-0.08, -0.69),(0.25, -0.34),(0.72, -0.19),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.64, -0.35),node2.pos,decoration:"wave",angle:5.28rad)
cetz.draw.content((-0.74, -0.42),angle:5.28rad,[k(1)])
cetz.draw.hobby((-0.25, -0.81),(-0.69, -0.38),(-0.89, 0.21),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.64, 0.46),node1.pos,decoration:"wave",angle:2.13rad)
cetz.draw.content((0.75, 0.52),angle:2.13rad,[k(1)])
cetz.draw.hobby((0.25, 0.92),(0.70, 0.49),(0.89, -0.10),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.28, 0.50),node2.pos,decoration:"arrow",angle:0.56rad)
cetz.draw.content((-0.21, 0.40),angle:0.56rad,[k(2)])
cetz.draw.hobby((0.09, 0.80),(-0.25, 0.45),(-0.71, 0.30),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.59, 1.00),node3.pos,decoration:"arrow",angle:3.70rad)
cetz.draw.content((-0.65, 1.10),angle:3.70rad,[k(1)+k(2)])
cetz.draw.hobby((-0.91, 0.50),(-0.62, 1.05),(-0.00, 1.07),stroke:stroke,mark: (end: ">"))
})
[
                            = d0
 overall factor: -1
                            
 symmetry group: 1]
grid(columns: cols,gutter: 20pt,box[#d00 ],)
pagebreak()
}