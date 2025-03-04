{
  <|
    "Denominator" -> prop[0,p]^-1 prop[0,p+q]^-1,
    "Partial_fraction" -> {
      prop[0,p]^-1 prop[0,p+q]^-1
    },
    "Numerator" -> <|
      "FL" -> 2 eq^2 (dim-2)^-1 (-dot[p,q]^2+dot[p,p] dot[q,q])^-1 (4 dot[p,q]^4-2 dim dot[p,q]^4-dot[p,p]^2 dot[q,q]^2+2 dot[p,q]^3 dot[q,q]+dim dot[p,p]^2 dot[q,q]^2-dim dot[p,q]^3 dot[q,q]-4 dot[p,p] dot[p,q]^2 dot[q,q]-3 dot[p,p] dot[p,q] dot[q,q]^2+dim dot[p,p] dot[p,q]^2 dot[q,q]+dim dot[p,p] dot[p,q] dot[q,q]^2) dot[p,q]^-1,
      "F2" -> 2 eq^2 (dim-2)^-1 (-dot[p,q]^2+dot[p,p] dot[q,q])^-1 (2 dot[p,q]^2-2 dim dot[p,q]^2-3 dot[p,p] dot[q,q]-dot[p,q] dot[q,q]+2 dim dot[p,p] dot[q,q]) dot[p,q],
      "zero" -> 2 eq^2 (2 dot[p,q]^2-dot[p,p] dot[q,q]+dot[p,q] dot[q,q])
    |>,
    "embedding" -> {
      1,
      0,
      -1
    },
    "Cut content" -> 1
  |>,
  <|
    "embedding" -> {
      1,
      1,
      1
    },
    "Denominator" -> prop[0,-p]^-1 prop[0,-p-q]^-1,
    "Partial_fraction" -> {
      prop[0,-p]^-1 prop[0,-p-q]^-1
    },
    "Cut content" -> -1,
    "Numerator" -> <|
      "FL" -> 2 eq^2 (dim-2)^-1 (-dot[p,q]^2+dot[p,p] dot[q,q])^-1 (4 dot[p,q]^4-2 dim dot[p,q]^4-dot[p,p]^2 dot[q,q]^2+2 dot[p,q]^3 dot[q,q]+dim dot[p,p]^2 dot[q,q]^2-dim dot[p,q]^3 dot[q,q]-4 dot[p,p] dot[p,q]^2 dot[q,q]-3 dot[p,p] dot[p,q] dot[q,q]^2+dim dot[p,p] dot[p,q]^2 dot[q,q]+dim dot[p,p] dot[p,q] dot[q,q]^2) dot[p,q]^-1,
      "F2" -> 2 eq^2 (dim-2)^-1 (-dot[p,q]^2+dot[p,p] dot[q,q])^-1 (2 dot[p,q]^2-2 dim dot[p,q]^2-3 dot[p,p] dot[q,q]-dot[p,q] dot[q,q]+2 dim dot[p,p] dot[q,q]) dot[p,q],
      "zero" -> 2 eq^2 (2 dot[p,q]^2-dot[p,p] dot[q,q]+dot[p,q] dot[q,q])
    |>
  |>
}