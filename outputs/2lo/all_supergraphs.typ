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
let node0= (pos:(-0.76, -0.36))
node(node0.pos)
let node1= (pos:(-0.81, 0.20))
node(node1.pos)
let node2= (pos:(0.71, 0.31))
node(node2.pos)
let node3= (pos:(0.75, -0.25))
node(node3.pos)
let node4= (pos:(-0.00, -0.40))
node(node4.pos)
let node5= (pos:(-0.06, 0.34))
node(node5.pos)
edge(node1.pos,(-1.00, -0.10),node0.pos,decoration:"arrow",angle:1.64rad)
cetz.draw.content((-1.12, -0.11),angle:1.64rad,[k(0)+k(1)])
cetz.draw.hobby((-0.91, 0.21),(-1.06, -0.10),(-0.86, -0.39),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.70, -0.08),node1.pos,decoration:"arrow",angle:-1.50rad)
cetz.draw.content((-0.58, -0.07),angle:-1.50rad,[k(0)])
cetz.draw.hobby((-0.68, -0.33),(-0.64, -0.07),(-0.72, 0.18),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.39, -0.47),node4.pos,decoration:"wave",angle:3.09rad)
cetz.draw.content((-0.39, -0.59),angle:3.09rad,[k(1)])
cetz.draw.hobby((-0.72, -0.45),(-0.39, -0.53),(-0.06, -0.48),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(-0.45, 0.35),node1.pos,decoration:"wave",angle:0.19rad)
cetz.draw.content((-0.47, 0.47),angle:0.19rad,[k(1)])
cetz.draw.hobby((-0.12, 0.41),(-0.46, 0.41),(-0.77, 0.29),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.64, 0.02),node2.pos,decoration:"arrow",angle:4.79rad)
cetz.draw.content((0.52, 0.01),angle:4.79rad,[k(2)])
cetz.draw.hobby((0.66, -0.24),(0.58, 0.02),(0.62, 0.28),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(0.94, 0.05),node3.pos,decoration:"coil",angle:1.65rad)
cetz.draw.content((1.06, 0.05),angle:1.65rad,[k(2)+k(3)])
cetz.draw.hobby((0.80, 0.34),(1.00, 0.05),(0.85, -0.27),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.33, 0.41),node2.pos,decoration:"arrow",angle:3.10rad)
cetz.draw.content((0.34, 0.53),angle:3.10rad,[k(3)])
cetz.draw.hobby((-0.00, 0.42),(0.33, 0.47),(0.66, 0.40),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.39, -0.41),node4.pos,decoration:"arrow",angle:0.19rad)
cetz.draw.content((0.42, -0.53),angle:0.19rad,[k(3)])
cetz.draw.hobby((0.71, -0.35),(0.40, -0.47),(0.07, -0.47),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(-0.03, -0.03),node5.pos,decoration:"arrow",angle:-1.49rad)
cetz.draw.content((0.09, -0.02),angle:-1.49rad,[k(1)+k(3)])
cetz.draw.hobby((0.05, -0.32),(0.03, -0.02),(0.01, 0.27),stroke:stroke,mark: (end: ">"))
})
let d10=cetz.canvas(length:50%,{
let node0= (pos:(-0.40, -0.85))
node(node0.pos)
let node1= (pos:(-0.91, -0.17))
node(node1.pos)
let node2= (pos:(0.89, 0.66))
node(node2.pos)
let node3= (pos:(0.28, 0.19))
node(node3.pos)
let node4= (pos:(0.73, -0.51))
node(node4.pos)
let node5= (pos:(-0.28, 0.81))
node(node5.pos)
edge(node1.pos,(-0.56, -0.44),node0.pos,decoration:"arrow",angle:2.22rad)
cetz.draw.content((-0.47, -0.37),angle:2.22rad,[k(0)+k(1)])
cetz.draw.hobby((-0.80, -0.16),(-0.51, -0.40),(-0.35, -0.75),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(-0.89, -0.69),node1.pos,decoration:"arrow",angle:5.37rad)
cetz.draw.content((-0.98, -0.77),angle:5.37rad,[k(0)])
cetz.draw.hobby((-0.50, -0.93),(-0.94, -0.73),(-1.02, -0.25),stroke:stroke,mark: (end: ">"))
edge(node0.pos,(0.20, -0.81),node4.pos,decoration:"wave",angle:-2.86rad)
cetz.draw.content((0.23, -0.93),angle:-2.86rad,[k(1)])
cetz.draw.hobby((-0.28, -0.92),(0.22, -0.87),(0.67, -0.64),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(-0.71, 0.39),node1.pos,decoration:"wave",angle:1.01rad)
cetz.draw.content((-0.81, 0.45),angle:1.01rad,[k(1)])
cetz.draw.hobby((-0.42, 0.79),(-0.76, 0.42),(-0.95, -0.04),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(0.61, 0.44),node2.pos,decoration:"coil",angle:-2.49rad)
cetz.draw.content((0.69, 0.34),angle:-2.49rad,[k(2)])
cetz.draw.hobby((0.38, 0.19),(0.63, 0.37),(0.87, 0.56),stroke:stroke,mark: (end: ">"))
edge(node2.pos,(1.00, 0.04),node4.pos,decoration:"arrow",angle:1.42rad)
cetz.draw.content((1.12, 0.02),angle:1.42rad,[k(2)+k(3)])
cetz.draw.hobby((1.00, 0.56),(1.06, 0.04),(0.86, -0.45),stroke:stroke,mark: (end: ">"))
edge(node5.pos,(0.33, 0.93),node2.pos,decoration:"arrow",angle:3.01rad)
cetz.draw.content((0.35, 1.05),angle:3.01rad,[k(3)])
cetz.draw.hobby((-0.19, 0.92),(0.34, 0.99),(0.83, 0.79),stroke:stroke,mark: (end: ">"))
edge(node4.pos,(0.47, -0.21),node3.pos,decoration:"arrow",angle:5.29rad)
cetz.draw.content((0.36, -0.28),angle:5.29rad,[k(1)+k(2)+k(3)])
cetz.draw.hobby((0.62, -0.50),(0.40, -0.22),(0.25, 0.09),stroke:stroke,mark: (end: ">"))
edge(node3.pos,(-0.06, 0.48),node5.pos,decoration:"arrow",angle:5.44rad)
cetz.draw.content((-0.15, 0.40),angle:5.44rad,[k(1)+k(3)])
cetz.draw.hobby((0.18, 0.19),(-0.09, 0.42),(-0.29, 0.71),stroke:stroke,mark: (end: ">"))
})
[
                            = d0
 overall factor: AutG(1)^-1*InternalFermionLoopSign(-1)*NumeratorIndependentSymmetryGrouping(2)*ExternalFermionOrderingSign(1)
                            
 symmetry group: 1]
grid(columns: cols,gutter: 20pt,box[#d00 ],)
pagebreak()
[
                            = d1
 overall factor: AutG(1)^-1*InternalFermionLoopSign(-1)*ExternalFermionOrderingSign(1)
                            
 symmetry group: 2]
grid(columns: cols,gutter: 20pt,box[#d10 ],)
pagebreak()
}