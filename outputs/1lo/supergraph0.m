{
  <|
    "Numerator" -> <|
      "w1" -> 1/9 ee^2 dim Nc phat^-4 (d-2)^-1 (dot[p,p]+dot[p,q]) (-2 phat^2-dot[p,p]+d dot[p,p]+dim phat^2),
      "w0" -> 1/9 ee^2 dim Nc phat^-2 (d-2)^-1 (dot[p,p]+dot[p,q]) (-2 phat^2+dot[p,p]+dim phat^2),
      "w2" -> 1/9 ee^2 dim Nc (2 dot[p,q]^2-dot[p,p] dot[q,q]+dot[p,q] dot[q,q])
    |>,
    "embedding" -> {
      1,
      0,
      -1
    },
    "Denominator" -> prop[0,p]^-1 prop[0,p+q]^-1,
    "Partial_fraction" -> {
      prop[0,p]^-1 prop[0,p+q]^-1
    }
  |>,
  <|
    "Denominator" -> prop[0,-p]^-1 prop[0,-p-q]^-1,
    "Numerator" -> <|
      "w0" -> 1/9 ee^2 dim Nc phat^-2 (d-2)^-1 (dot[p,p]+dot[p,q]) (-2 phat^2+dot[p,p]+dim phat^2),
      "w1" -> 1/9 ee^2 dim Nc phat^-4 (d-2)^-1 (dot[p,p]+dot[p,q]) (-2 phat^2-dot[p,p]+d dot[p,p]+dim phat^2),
      "w2" -> 1/9 ee^2 dim Nc (2 dot[p,q]^2-dot[p,p] dot[q,q]+dot[p,q] dot[q,q])
    |>,
    "embedding" -> {
      1,
      1,
      1
    },
    "Partial_fraction" -> {
      prop[0,-p]^-1 prop[0,-p-q]^-1
    }
  |>
}