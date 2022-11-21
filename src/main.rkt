(include "geometry.rkt")
(include "draw.rkt")

(define (architect data)
  data)

;(draw
; (architect
;  (init-geometry "../data/mushroom.json" "../data/settings.json")))


;(show (get-element-xml h))

;(map
; (λ(data) (show (get-element-xml data)))
; (init-geometry "../data/mushroom.json" "../data/settings.json")) 


(define test '#hasheq((X . 174)
                      (Y . 251)
                      (bottom . 5)
                      (id . "Опёнок")
                      (idParent . "Съедобные")
                      (kind . "Гриб")
                      (left . 120)
                      (marginBottom . 14)
                      (marginLeft . 14)
                      (marginRight . 14)
                      (marginTop . 14)
                      (name . "Опёнок")
                      (nameFormat . null)
                      (paddingHeight . 20)
                      (paddingWidth . 20)
                      (right . 5)
                      (style . "html=1;rounded=1;fillColor=#9AC7BF;gradientColor=#ffffff;strokeColor=#86D65F;verticalAlign=top;fontFamily=Tahoma;spacingLeft=50;spacingTop=5;align=center;fontColor=#262626;fontSize=36;shadow=1;whiteSpace=wrap;")
                      (top . 80)))

(define k
  (car (init-geometry "../data/mushroom.json" "../data/settings.json")))

(map
 (λ(data) (show (get-element-xml data)))
 (list test))


(map
 (λ(data) (show (get-element-xml data)))
 (list k))

