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
let node0= (pos:(-0.54, -0.54))
node(node0.pos)
let node1= (pos:(0.54, -0.54))
node(node1.pos)
let node2= (pos:(-0.54, 0.54))
node(node2.pos)
let node3= (pos:(0.54, 0.54))
node(node3.pos)
edge(node1.pos,(0.00, -0.55),node0.pos,decoration:"arrow",angle:3.14rad)
cetz.draw.content((0.00, -0.67),angle:3.14rad,[q+k[0]])
cetz.draw.hobby((0.43, -0.61),(0.00, -0.61),(-0.43, -0.60),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.55, 0.00),node2.pos,decoration:"wave",angle:4.71rad)
cetz.draw.content((-0.67, 0.00),angle:4.71rad,[q])
cetz.draw.hobby((-0.61, -0.43),(-0.61, 0.00),(-0.60, 0.44),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.55, -0.00),node1.pos,decoration:"wave",angle:1.57rad)
cetz.draw.content((0.67, -0.00),angle:1.57rad,[q])
cetz.draw.hobby((0.61, 0.43),(0.61, -0.00),(0.61, -0.44),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.00, 0.55),node3.pos,decoration:"arrow",angle:3.14rad)
cetz.draw.content((0.00, 0.67),angle:3.14rad,[p+q])
cetz.draw.hobby((-0.43, 0.61),(0.00, 0.61),(0.44, 0.60),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-1.00, -1.00),decoration:"arrow",angle:-2.35rad)
cetz.draw.content((-0.68, -0.85),angle:-2.35rad,[-k[0]])
cetz.draw.hobby((-0.89, -0.97),(-0.57, -0.65),stroke:stroke,mark: (end: ">"))
edge(node1.pos,(1.00, -1.00),decoration:"arrow",angle:2.36rad)
cetz.draw.content((0.85, -0.69),angle:2.36rad,[-k[0]])
cetz.draw.hobby((0.65, -0.57),(0.97, -0.89),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(1.00, 1.00),decoration:"arrow",angle:3.93rad)
cetz.draw.content((0.68, 0.85),angle:3.93rad,[p])
cetz.draw.hobby((0.57, 0.65),(0.89, 0.97),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-1.00, 1.00),decoration:"arrow",angle:2.36rad)
cetz.draw.content((-0.85, 0.69),angle:2.36rad,[p])
cetz.draw.hobby((-0.97, 0.89),(-0.65, 0.57),stroke:stroke,mark: (end: ">"))
})
let embedding1f0=cetz.canvas(length:50%,{
let node0= (pos:(0.54, -0.54))
node(node0.pos)
let node1= (pos:(-0.54, -0.54))
node(node1.pos)
let node2= (pos:(0.54, 0.54))
node(node2.pos)
let node3= (pos:(-0.54, 0.54))
node(node3.pos)
edge(node0.pos,(-0.00, -0.56),node1.pos,decoration:"arrow",angle:-3.14rad)
edge(node0.pos,(0.55, 0.00),node2.pos,decoration:"wave",angle:-1.57rad)
edge(node3.pos,(-0.55, -0.00),node1.pos,decoration:"wave",angle:1.57rad)
edge(node3.pos,(0.00, 0.56),node2.pos,decoration:"arrow",angle:3.14rad)
edge(node1.pos,(-1.00, -1.00),decoration:"arrow",angle:-2.36rad)
edge(node0.pos,(1.00, -1.00),decoration:"arrow",angle:2.36rad)
edge(node2.pos,(1.00, 1.00),decoration:"arrow",angle:3.92rad)
edge(node3.pos,(-1.00, 1.00),decoration:"arrow",angle:2.36rad)
})
let embedding2i0=cetz.canvas(length:50%,{
let node0= (pos:(-0.54, -0.54))
node(node0.pos)
let node1= (pos:(0.54, -0.54))
node(node1.pos)
let node2= (pos:(-0.54, 0.54))
node(node2.pos)
let node3= (pos:(0.54, 0.54))
node(node3.pos)
edge(node1.pos,(0.00, -0.55),node0.pos,decoration:"arrow",angle:3.14rad)
cetz.draw.content((0.00, -0.67),angle:3.14rad,[q+k[0]])
cetz.draw.hobby((0.44, -0.60),(0.00, -0.61),(-0.43, -0.60),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.55, 0.00),node2.pos,decoration:"wave",angle:4.71rad)
cetz.draw.content((-0.67, 0.00),angle:4.71rad,[q])
cetz.draw.hobby((-0.60, -0.43),(-0.61, 0.00),(-0.60, 0.43),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.56, -0.00),node1.pos,decoration:"wave",angle:1.57rad)
cetz.draw.content((0.68, -0.00),angle:1.57rad,[q])
cetz.draw.hobby((0.61, 0.43),(0.62, -0.00),(0.61, -0.43),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.00, 0.55),node2.pos,decoration:"arrow",angle:-0.00rad)
cetz.draw.content((0.00, 0.67),angle:-0.00rad,[-p-q])
cetz.draw.hobby((0.44, 0.60),(0.00, 0.61),(-0.43, 0.60),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-1.00, -1.00),decoration:"arrow",angle:-2.36rad)
cetz.draw.content((-0.68, -0.85),angle:-2.36rad,[-k[0]])
cetz.draw.hobby((-0.89, -0.97),(-0.57, -0.65),stroke:stroke,mark: (end: ">"))
edge(node1.pos,(1.00, -1.00),decoration:"arrow",angle:2.36rad)
cetz.draw.content((0.86, -0.69),angle:2.36rad,[-k[0]])
cetz.draw.hobby((0.65, -0.57),(0.97, -0.89),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(-1.00, 1.00),decoration:"arrow",angle:5.50rad)
cetz.draw.content((-0.85, 0.68),angle:5.50rad,[p])
cetz.draw.hobby((-0.97, 0.89),(-0.65, 0.57),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(1.00, 1.00),decoration:"arrow",angle:0.79rad)
cetz.draw.content((0.69, 0.85),angle:0.79rad,[p])
cetz.draw.hobby((0.57, 0.65),(0.89, 0.97),stroke:stroke,mark: (end: ">"))
})
let embedding2f0=cetz.canvas(length:50%,{
let node0= (pos:(0.54, -0.54))
node(node0.pos)
let node1= (pos:(-0.54, -0.54))
node(node1.pos)
let node2= (pos:(0.54, 0.54))
node(node2.pos)
let node3= (pos:(-0.54, 0.54))
node(node3.pos)
edge(node0.pos,(-0.00, -0.55),node1.pos,decoration:"arrow",angle:-3.14rad)
edge(node0.pos,(0.56, 0.00),node2.pos,decoration:"wave",angle:-1.57rad)
edge(node3.pos,(-0.56, 0.00),node1.pos,decoration:"wave",angle:1.57rad)
edge(node2.pos,(-0.00, 0.55),node3.pos,decoration:"arrow",angle:0.00rad)
edge(node1.pos,(-1.00, -1.00),decoration:"arrow",angle:-2.36rad)
edge(node0.pos,(1.00, -1.00),decoration:"arrow",angle:2.35rad)
edge(node3.pos,(-1.00, 1.00),decoration:"arrow",angle:5.50rad)
edge(node2.pos,(1.00, 1.00),decoration:"arrow",angle:0.78rad)
})
[= embedding 1 [1, 0, -1] 
 == initial
Denominator:
```mathematica
prop[0,q]^-2
```Partial Fractioned Denominator:
```mathematica
prop[0,q]^-2
```]
grid(columns: cols,gutter: 20pt,box[#embedding1i0 -3+8],)
pagebreak()
[== final
Denominator: 
```mathematica
prop[0,q]^-2
```]
grid(columns: cols,gutter: 20pt,box[#embedding1f0 -1+10],)
pagebreak()
[= embedding 2 [1, 1, 1] 
 == initial
Denominator:
```mathematica
prop[0,q]^-2
```Partial Fractioned Denominator:
```mathematica
prop[0,q]^-2
```]
grid(columns: cols,gutter: 20pt,box[#embedding2i0 -3-10],)
pagebreak()
[== final
Denominator: 
```mathematica
prop[0,q]^-2
```]
grid(columns: cols,gutter: 20pt,box[#embedding2f0 -1-8],)
pagebreak()
}