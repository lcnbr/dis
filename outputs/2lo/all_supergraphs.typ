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
let node0= (pos:(-0.21, 0.80))
node(node0.pos)
let node1= (pos:(0.36, 0.76))
node(node1.pos)
let node2= (pos:(0.27, -0.78))
node(node2.pos)
let node3= (pos:(-0.30, -0.75))
node(node3.pos)
let node4= (pos:(-0.34, 0.03))
node(node4.pos)
let node5= (pos:(0.41, -0.01))
node(node5.pos)
edge(node1.pos,(0.09, 1.00),node0.pos,decoration:"arrow",angle:3.08rad)
cetz.draw.content((0.10, 1.12),angle:3.08rad,[k(0)+k(1)])
cetz.draw.hobby((0.39, 0.86),(0.10, 1.06),(-0.22, 0.90),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.07, 0.69),node1.pos,decoration:"arrow",angle:6.22rad)
cetz.draw.content((0.07, 0.57),angle:6.22rad,[k(0)])
cetz.draw.hobby((-0.19, 0.71),(0.07, 0.63),(0.33, 0.68),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.36, 0.43),node4.pos,decoration:"wave",angle:1.39rad)
cetz.draw.content((-0.48, 0.46),angle:1.39rad,[k(1)])
cetz.draw.hobby((-0.30, 0.76),(-0.42, 0.44),(-0.42, 0.10),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.47, 0.38),node1.pos,decoration:"wave",angle:-1.51rad)
cetz.draw.content((0.59, 0.39),angle:-1.51rad,[k(1)])
cetz.draw.hobby((0.49, 0.04),(0.53, 0.38),(0.45, 0.72),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.03, -0.98),node2.pos,decoration:"arrow",angle:6.22rad)
cetz.draw.content((-0.04, -1.10),angle:6.22rad,[k(2)])
cetz.draw.hobby((-0.33, -0.85),(-0.03, -1.04),(0.28, -0.88),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.01, -0.67),node3.pos,decoration:"coil",angle:-0.06rad)
cetz.draw.content((-0.00, -0.55),angle:-0.06rad,[k(2)+k(3)])
cetz.draw.hobby((0.25, -0.69),(-0.01, -0.61),(-0.27, -0.66),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.43, -0.42),node2.pos,decoration:"arrow",angle:1.39rad)
cetz.draw.content((0.54, -0.44),angle:1.39rad,[k(3)])
cetz.draw.hobby((0.48, -0.08),(0.49, -0.42),(0.36, -0.74),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.41, -0.36),node4.pos,decoration:"arrow",angle:4.77rad)
cetz.draw.content((-0.53, -0.37),angle:4.77rad,[k(3)])
cetz.draw.hobby((-0.39, -0.70),(-0.47, -0.36),(-0.43, -0.02),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.03, 0.01),node5.pos,decoration:"arrow",angle:3.08rad)
cetz.draw.content((0.04, 0.13),angle:3.08rad,[k(1)+k(3)])
cetz.draw.hobby((-0.26, 0.09),(0.04, 0.07),(0.34, 0.05),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.72, 0.61))
node(node0.pos)
let node1= (pos:(-0.07, 0.90))
node(node1.pos)
let node2= (pos:(0.53, -0.62))
node(node2.pos)
let node3= (pos:(0.03, -0.85))
node(node3.pos)
let node4= (pos:(-0.50, -0.34))
node(node4.pos)
let node5= (pos:(0.50, 0.12))
node(node5.pos)
edge(node1.pos,(-0.35, 0.65),node0.pos,decoration:"arrow",angle:-2.72rad)
cetz.draw.content((-0.30, 0.54),angle:-2.72rad,[k(0)+k(1)])
cetz.draw.hobby((-0.07, 0.80),(-0.32, 0.60),(-0.65, 0.54),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.51, 1.00),node1.pos,decoration:"arrow",angle:0.42rad)
cetz.draw.content((-0.56, 1.11),angle:0.42rad,[k(0)])
cetz.draw.hobby((-0.78, 0.71),(-0.53, 1.05),(-0.11, 1.02),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.71, 0.12),node4.pos,decoration:"wave",angle:1.79rad)
cetz.draw.content((-0.83, 0.09),angle:1.79rad,[k(1)])
cetz.draw.hobby((-0.79, 0.52),(-0.77, 0.10),(-0.61, -0.29),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.30, 0.57),node1.pos,decoration:"wave",angle:-0.94rad)
cetz.draw.content((0.39, 0.64),angle:-0.94rad,[k(1)])
cetz.draw.hobby((0.53, 0.23),(0.35, 0.61),(0.05, 0.90),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.40, -0.98),node2.pos,decoration:"coil",angle:-2.71rad)
cetz.draw.content((0.45, -1.09),angle:-2.71rad,[k(2)])
cetz.draw.hobby((0.03, -0.96),(0.42, -1.04),(0.62, -0.69),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.01, -0.41),node4.pos,decoration:"arrow",angle:2.89rad)
cetz.draw.content((0.02, -0.30),angle:2.89rad,[k(2)+k(3)])
cetz.draw.hobby((0.46, -0.52),(0.05, -0.37),(-0.39, -0.29),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.73, -0.24),node2.pos,decoration:"arrow",angle:-1.51rad)
cetz.draw.content((0.85, -0.23),angle:-1.51rad,[k(3)])
cetz.draw.hobby((0.61, 0.11),(0.79, -0.24),(0.64, -0.60),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(-0.39, -0.74),node3.pos,decoration:"arrow",angle:5.50rad)
cetz.draw.content((-0.47, -0.83),angle:5.50rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((-0.57, -0.43),(-0.42, -0.79),(-0.05, -0.92),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.23, -0.31),node5.pos,decoration:"arrow",angle:1.10rad)
cetz.draw.content((0.12, -0.25),angle:1.10rad,[k(1)+k(3)])
cetz.draw.hobby((0.00, -0.73),(0.16, -0.31),(0.39, 0.07),stroke:stroke,mark: (end: ">"))
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