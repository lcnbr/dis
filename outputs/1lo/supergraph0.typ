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
let embedding1i0=cetz.canvas(length:50%,{
let node0= (pos:(0.60, -0.98))
node(node0.pos)
let node1= (pos:(0.70, -0.48))
node(node1.pos)
let node2= (pos:(-0.60, 0.86))
node(node2.pos)
let node3= (pos:(0.22, -0.27))
node(node3.pos)
edge(node1.pos,(0.77, 0.75),node0.pos,decoration:"arrow",angle:1.61rad)
cetz.draw.content((0.89, 0.75),angle:1.61rad,[q+k[0]])
cetz.draw.hobby((0.11, 3.48),(-12.23, 1.72),(-1.40, -4.45),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.31, 1.00),node2.pos,decoration:"wave",angle:-0.28rad)
cetz.draw.content((0.35, 1.12),angle:-0.28rad,[q])
cetz.draw.hobby((0.91, -0.79),(0.98, 0.58),(-0.31, 1.06),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.58, -0.73),node1.pos,decoration:"wave",angle:-2.50rad)
cetz.draw.content((0.65, -0.82),angle:-2.50rad,[q])
cetz.draw.hobby((0.09, -0.34),(0.27, -0.82),(0.74, -0.62),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.18, 0.98),node3.pos,decoration:"arrow",angle:2.70rad)
cetz.draw.content((0.23, 1.09),angle:2.70rad,[p+q])
cetz.draw.hobby((-0.43, 1.04),(0.49, 0.79),(0.45, -0.16),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.65, -0.65),decoration:"arrow",angle:2.88rad)
cetz.draw.content((-0.05, -0.93),angle:2.88rad,[-k[0]])
cetz.draw.hobby((-0.56, -0.73),(0.49, -1.02),stroke:stroke,mark: (end: ">"))
edge(node1.pos,(0.65, -0.65),decoration:"arrow",angle:1.26rad)
cetz.draw.content((0.79, -0.60),angle:1.26rad,[-k[0]])
cetz.draw.hobby((0.73, -0.59),(0.73, -0.57),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.65, 0.65),decoration:"arrow",angle:4.28rad)
cetz.draw.content((0.32, 0.24),angle:4.28rad,[p])
cetz.draw.hobby((0.21, -0.16),(0.55, 0.58),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.65, 0.65),decoration:"arrow",angle:-1.77rad)
cetz.draw.content((-0.51, 0.73),angle:-1.77rad,[p])
cetz.draw.hobby((-0.57, 0.73),(-0.56, 0.75),stroke:stroke,mark: (end: ">"))
})
let embedding1f0=cetz.canvas(length:50%,{
let node0= (pos:(0.60, -0.98))
node(node0.pos)
let node1= (pos:(0.70, -0.48))
node(node1.pos)
let node2= (pos:(-0.60, 0.86))
node(node2.pos)
let node3= (pos:(0.22, -0.27))
node(node3.pos)
edge(node0.pos,(0.77, 0.75),node1.pos,decoration:"arrow",angle:-1.53rad)
edge(node0.pos,(0.31, 1.00),node2.pos,decoration:"wave",angle:-0.28rad)
edge(node3.pos,(0.58, -0.73),node1.pos,decoration:"wave",angle:-2.50rad)
edge(node3.pos,(0.18, 0.98),node2.pos,decoration:"arrow",angle:-0.44rad)
edge(node1.pos,(-0.65, -0.65),decoration:"arrow",angle:-3.02rad)
edge(node0.pos,(0.65, -0.65),decoration:"arrow",angle:4.59rad)
edge(node2.pos,(0.65, 0.65),decoration:"arrow",angle:2.97rad)
edge(node3.pos,(-0.65, 0.65),decoration:"arrow",angle:2.33rad)
})
let embedding2i0=cetz.canvas(length:50%,{
let node0= (pos:(0.60, -0.98))
node(node0.pos)
let node1= (pos:(0.69, -0.51))
node(node1.pos)
let node2= (pos:(-0.60, 0.86))
node(node2.pos)
let node3= (pos:(0.22, -0.27))
node(node3.pos)
edge(node1.pos,(0.77, 0.75),node0.pos,decoration:"arrow",angle:1.61rad)
cetz.draw.content((0.89, 0.75),angle:1.61rad,[q+k[0]])
cetz.draw.hobby((0.10, 3.54),(-12.52, 1.74),(-1.43, -4.54),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.31, 1.00),node2.pos,decoration:"wave",angle:-0.28rad)
cetz.draw.content((0.35, 1.12),angle:-0.28rad,[q])
cetz.draw.hobby((0.91, -0.79),(0.98, 0.58),(-0.31, 1.06),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.58, -0.70),node1.pos,decoration:"wave",angle:-2.51rad)
cetz.draw.content((0.65, -0.80),angle:-2.51rad,[q])
cetz.draw.hobby((0.11, -0.33),(0.26, -0.78),(0.71, -0.64),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.18, 0.98),node2.pos,decoration:"arrow",angle:-0.44rad)
cetz.draw.content((0.23, 1.09),angle:-0.44rad,[-p-q])
cetz.draw.hobby((0.45, -0.16),(0.49, 0.79),(-0.43, 1.04),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.65, -0.65),decoration:"arrow",angle:2.88rad)
cetz.draw.content((-0.05, -0.93),angle:2.88rad,[-k[0]])
cetz.draw.hobby((-0.56, -0.73),(0.49, -1.02),stroke:stroke,mark: (end: ">"))
edge(node1.pos,(0.65, -0.65),decoration:"arrow",angle:1.22rad)
cetz.draw.content((0.78, -0.62),angle:1.22rad,[-k[0]])
cetz.draw.hobby((0.72, -0.63),(0.74, -0.57),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-0.65, 0.65),decoration:"arrow",angle:1.37rad)
cetz.draw.content((-0.51, 0.73),angle:1.37rad,[p])
cetz.draw.hobby((-0.57, 0.73),(-0.56, 0.75),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.65, 0.65),decoration:"arrow",angle:1.14rad)
cetz.draw.content((0.32, 0.24),angle:1.14rad,[p])
cetz.draw.hobby((0.21, -0.16),(0.55, 0.58),stroke:stroke,mark: (end: ">"))
})
let embedding2f0=cetz.canvas(length:50%,{
let node0= (pos:(0.60, -0.98))
node(node0.pos)
let node1= (pos:(0.70, -0.48))
node(node1.pos)
let node2= (pos:(-0.60, 0.86))
node(node2.pos)
let node3= (pos:(0.22, -0.27))
node(node3.pos)
edge(node0.pos,(0.77, 0.75),node1.pos,decoration:"arrow",angle:-1.53rad)
edge(node0.pos,(0.31, 1.00),node2.pos,decoration:"wave",angle:-0.28rad)
edge(node3.pos,(0.58, -0.73),node1.pos,decoration:"wave",angle:-2.50rad)
edge(node2.pos,(0.18, 0.98),node3.pos,decoration:"arrow",angle:2.70rad)
edge(node1.pos,(-0.65, -0.65),decoration:"arrow",angle:-3.02rad)
edge(node0.pos,(0.65, -0.65),decoration:"arrow",angle:4.59rad)
edge(node3.pos,(-0.65, 0.65),decoration:"arrow",angle:5.47rad)
edge(node2.pos,(0.65, 0.65),decoration:"arrow",angle:-0.17rad)
})
[= embedding 1 [1, 0, -1] 
 == initial
Denominator:
```mathematica
prop[0,p]^-1 prop[0,p+q]^-1
```Partial Fractioned Denominator:
```mathematica
prop[0,p]^-1 prop[0,p+q]^-1
```]
grid(columns: cols,gutter: 20pt,box[#embedding1i0 -3+8],)
pagebreak()
[== final
Denominator: 
```mathematica
prop[0,p]^-1 prop[0,p-q]^-1
```]
grid(columns: cols,gutter: 20pt,box[#embedding1f0 -1+10],)
pagebreak()
[= embedding 2 [1, 1, 1] 
 == initial
Denominator:
```mathematica
prop[0,-p]^-1 prop[0,-p-q]^-1
```Partial Fractioned Denominator:
```mathematica
prop[0,-p]^-1 prop[0,-p-q]^-1
```]
grid(columns: cols,gutter: 20pt,box[#embedding2i0 -3-10],)
pagebreak()
[== final
Denominator: 
```mathematica
prop[0,-p]^-1 prop[0,-p+q]^-1
```]
grid(columns: cols,gutter: 20pt,box[#embedding2f0 -1-8],)
pagebreak()
}