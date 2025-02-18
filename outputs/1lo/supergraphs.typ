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
let node0= (pos:(0.64, 0.56))
node(node0.pos)
let node1= (pos:(0.67, -0.34))
node(node1.pos)
let node2= (pos:(-0.52, 0.53))
node(node2.pos)
let node3= (pos:(-0.49, -0.37))
node(node3.pos)
edge(node1.pos,(1.00, 0.12),node0.pos,decoration:"arrow",angle:1.60rad)
cetz.draw.content((1.12, 0.12),angle:1.60rad,[k(0)+k(1)])
cetz.draw.hobby((0.81, -0.34),(1.06, 0.12),(0.78, 0.57),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.51, 0.10),node1.pos,decoration:"arrow",angle:4.74rad)
cetz.draw.content((0.39, 0.10),angle:4.74rad,[k(0)])
cetz.draw.hobby((0.54, 0.50),(0.45, 0.10),(0.56, -0.29),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.05, 0.72),node2.pos,decoration:"wave",angle:0.03rad)
cetz.draw.content((0.05, 0.84),angle:0.03rad,[k(1)])
cetz.draw.hobby((0.56, 0.67),(0.05, 0.78),(-0.45, 0.64),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.09, -0.54),node1.pos,decoration:"wave",angle:-3.12rad)
cetz.draw.content((0.10, -0.66),angle:-3.12rad,[k(1)])
cetz.draw.hobby((-0.41, -0.49),(0.09, -0.60),(0.59, -0.46),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.85, 0.06),node2.pos,decoration:"arrow",angle:4.75rad)
cetz.draw.content((-0.97, 0.06),angle:4.75rad,[k(2)])
cetz.draw.hobby((-0.63, -0.38),(-0.91, 0.06),(-0.67, 0.53),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.37, 0.08),node3.pos,decoration:"arrow",angle:1.60rad)
cetz.draw.content((-0.25, 0.09),angle:1.60rad,[k(1)+k(2)])
cetz.draw.hobby((-0.42, 0.48),(-0.31, 0.08),(-0.39, -0.31),stroke:stroke,mark: (end: ">"))
})
[
                            = d0
 overall factor: -1
                            
 symmetry group: 1]
grid(columns: cols,gutter: 20pt,box[#d00 ],)
pagebreak()
}