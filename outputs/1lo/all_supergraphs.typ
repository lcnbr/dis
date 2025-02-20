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
let node0= (pos:(0.62, 0.61))
node(node0.pos)
let node1= (pos:(0.70, -0.27))
node(node1.pos)
let node2= (pos:(-0.52, 0.52))
node(node2.pos)
let node3= (pos:(-0.44, -0.37))
node(node3.pos)
edge(node1.pos,(1.00, 0.20),node0.pos,decoration:"arrow",angle:1.66rad)
cetz.draw.content((1.12, 0.21),angle:1.66rad,[k(0)+k(1)])
cetz.draw.hobby((0.84, -0.26),(1.06, 0.21),(0.76, 0.63),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.52, 0.16),node1.pos,decoration:"arrow",angle:4.80rad)
cetz.draw.content((0.40, 0.15),angle:4.80rad,[k(0)])
cetz.draw.hobby((0.52, 0.55),(0.46, 0.16),(0.59, -0.22),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.03, 0.74),node2.pos,decoration:"wave",angle:0.09rad)
cetz.draw.content((0.02, 0.86),angle:0.09rad,[k(1)])
cetz.draw.hobby((0.54, 0.72),(0.03, 0.80),(-0.45, 0.64),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.14, -0.49),node1.pos,decoration:"wave",angle:-3.05rad)
cetz.draw.content((0.16, -0.61),angle:-3.05rad,[k(1)])
cetz.draw.hobby((-0.36, -0.47),(0.15, -0.55),(0.63, -0.39),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.82, 0.05),node2.pos,decoration:"arrow",angle:4.80rad)
cetz.draw.content((-0.94, 0.04),angle:4.80rad,[k(2)])
cetz.draw.hobby((-0.58, -0.38),(-0.88, 0.04),(-0.66, 0.51),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.34, 0.09),node3.pos,decoration:"arrow",angle:1.66rad)
cetz.draw.content((-0.22, 0.10),angle:1.66rad,[k(1)+k(2)])
cetz.draw.hobby((-0.41, 0.47),(-0.28, 0.09),(-0.35, -0.31),stroke:stroke,mark: (end: ">"))
})
[
                            = d0
 overall factor: -1
                            
 symmetry group: 1]
grid(columns: cols,gutter: 20pt,box[#d00 ],)
pagebreak()
}