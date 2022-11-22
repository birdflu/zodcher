#lang racket
(include "geometry.rkt")
(include "draw.rkt")

(define RESULT_PATH "./diagram.xml")

(define (architect data)
  data)

(define out
  (open-output-file  RESULT_PATH
                     #:mode 'text	 	 	 	 
                     #:exists 'append))

(draw
 (architect
  (init-geometry
   "./data/mushroom.json"
   "./data/settings.json"))
 out)
 
(close-output-port out)
(displayln
 (string-append "diagram is exported to " RESULT_PATH))