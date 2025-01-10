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
let embedding53i0=cetz.canvas(length:50%,{

//cetz.draw.hobby((0.59, 0.67),(0.59, 0.67),stroke:stroke,mark: (end: ">"))
})
let embedding53i1=cetz.canvas(length:50%,{
let node0= (pos:(-0.36, -0.73))
node(node0.pos)
let node1= (pos:(0.51, -0.74))
node(node1.pos)
let node2= (pos:(-0.05, -0.06))
node(node2.pos)
let node3= (pos:(0.71, -0.14))
node(node3.pos)
let node4= (pos:(-0.69, 1.00))
node(node4.pos)
let node5= (pos:(-0.53, 0.63))
node(node5.pos)
let node6= (pos:(-0.62, 0.10))
node(node6.pos)
let node7= (pos:(0.61, 0.48))
node(node7.pos)
//edge(node1.pos,(0.08, -0.77),node0.pos,decoration:"arrow",angle:3.12rad)
//cetz.draw.content((0.08, -0.89),angle:3.12rad,[q+k[0]])
//cetz.draw.hobby((0.43, -0.81),(0.08, -0.83),(-0.28, -0.80),stroke:stroke,mark: (end: ">"))
//edge(node0.pos,(-0.21, -0.41),node2.pos,decoration:"wave",angle:-2.00rad)
//cetz.draw.content((-0.10, -0.46),angle:-2.00rad,[q])
//cetz.draw.hobby((-0.27, -0.69),(-0.15, -0.42),(-0.03, -0.15),stroke:stroke,mark: (end: ">"))
//edge(node3.pos,(0.63, -0.45),node1.pos,decoration:"wave",angle:1.26rad)
//cetz.draw.content((0.74, -0.49),angle:1.26rad,[q])
//edge(node2.pos,(-0.34, 0.01),node6.pos,decoration:"arrow",angle:6.00rad)
//cetz.draw.hobby((0.75, -0.22),(0.69, -0.47),(0.60, -0.71),stroke:stroke,mark: (end: ">"))
//edge(node2.pos,(-0.34, 0.01),node6.pos,decoration:"arrow",angle:6.00rad)
//cetz.draw.content((-0.37, -0.11),angle:6.00rad,[-p])
//cetz.draw.hobby((-0.12, -0.11),(-0.35, -0.05),(-0.58, 0.02),stroke:stroke,mark: (end: ">"))
//edge(node7.pos,(0.27, 0.23),node2.pos,decoration:"arrow",angle:0.69rad)
//cetz.draw.content((0.20, 0.32),angle:0.69rad,[-p-q])
//cetz.draw.hobby((0.51, 0.48),(0.23, 0.27),(-0.03, 0.04),stroke:stroke,mark: (end: ">"))
//edge(node7.pos,(0.68, 0.19),node3.pos,decoration:"arrow",angle:-1.42rad)
//cetz.draw.content((0.79, 0.21),angle:-1.42rad,[q+k[3]])
//cetz.draw.hobby((0.69, 0.44),(0.74, 0.18),(0.76, -0.07),stroke:stroke,mark: (end: ">"))
//edge(node4.pos,(-0.48, 0.89),node5.pos,decoration:"none",angle:2.03rad)
//cetz.draw.content((-0.37, 0.94),angle:2.03rad,[k[4]])
//cetz.draw.hobby((-0.63, 1.06),(-0.41, 0.90),(-0.45, 0.64),stroke:stroke,mark: (end: ">"))
//edge(node5.pos,(-0.70, 0.77),node4.pos,decoration:"none",angle:5.17rad)
//cetz.draw.content((-0.81, 0.71),angle:5.17rad,[-p+k[3]+k[4]])
//cetz.draw.hobby((-0.60, 0.59),(-0.76, 0.75),(-0.76, 0.98),stroke:stroke,mark: (end: ">"))
//edge(node6.pos,(-0.60, 0.37),node5.pos,decoration:"coil",angle:1.42rad)
//cetz.draw.content((-0.71, 0.39),angle:1.42rad,[-p+k[3]])
//cetz.draw.hobby((-0.68, 0.16),(-0.65, 0.38),(-0.61, 0.60),stroke:stroke,mark: (end: ">"))
//edge(node0.pos,(-0.85, -0.85),decoration:"arrow",angle:-2.89rad)
//cetz.draw.content((-0.58, -0.91),angle:-2.89rad,[-k[0]])
//cetz.draw.hobby((-0.74, -0.89),(-0.44, -0.81),stroke:stroke,mark: (end: ">"))
//edge(node1.pos,(0.85, -0.85),decoration:"arrow",angle:2.83rad)
//cetz.draw.content((0.72, -0.68),angle:2.83rad,[-k[0]])
//cetz.draw.hobby((0.63, -0.72),(0.78, -0.76),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.85, 0.00),decoration:"arrow",angle:0.77rad)
cetz.draw.content((0.70, 0.02),angle:0.77rad,[k[3]])
//cetz.draw.hobby((0.74, -0.03),(0.74, -0.03),stroke:stroke,mark: (end: ">"))
//edge(node6.pos,(-0.85, 0.00),decoration:"arrow",angle:0.40rad)
//cetz.draw.content((-0.69, -0.06),angle:0.40rad,[k[3]])
//cetz.draw.hobby((-0.74, -0.02),(-0.68, 0.01),stroke:stroke,mark: (end: ">"))
//edge(node4.pos,(-0.85, 0.85),decoration:"coil",angle:0.73rad)
//cetz.draw.content((-0.69, 0.84),angle:0.73rad,[p-k[3]])
//cetz.draw.hobby((-0.74, 0.87),(-0.72, 0.89),stroke:stroke,mark: (end: ">"))
//edge(node7.pos,(0.85, 0.85),decoration:"coil",angle:0.99rad)
//cetz.draw.content((0.63, 0.73),angle:0.99rad,[p-k[3]])
//cetz.draw.hobby((0.62, 0.60),(0.75, 0.80),stroke:stroke,mark: (end: ">"))
})

grid(columns: cols,gutter: 20pt,
    embedding53i0,
    embedding53i1,
    )
}
