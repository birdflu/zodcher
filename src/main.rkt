(include "geometry.rkt")
(include "draw.rkt")

(define (architect data)
  data)

(draw
 (architect
  (init-geometry "../data/mushroom.json" "../data/settings.json")))
