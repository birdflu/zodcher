; #lang racket
(include "geometry.rkt")

(define (draw data)
  data)

(define (architect data)
  data)

(draw
 (architect
  (init-geometry "../data/mushroom.json" "../data/settings.json")))
