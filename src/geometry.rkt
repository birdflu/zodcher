(require racket/hash)
(require json)

(define RANDOM_LAYOUT_PX 400) 

(define (point x y)
  (list x y))

(define (segment point1 point2)
  (list (point1 point2)))
  
(define (point-X point)
  (first point))

(define (point-Y point)
  (last point))

(define get-default-layout
  (λ () (point
         (random RANDOM_LAYOUT_PX)
         (random RANDOM_LAYOUT_PX))))

; X
; Y                   (X, Y)----------------------- 13 ------------------------------> (x)
; top             0      |                                   |                  |
; paddingHeight   1      |                                   6                  |
; bottom          2      |      __________________ 11 _______|____________      |
; left            3      |      |               |                        |      |
; paddingWidth    4      |_ 8 __|               0                        |_ 9 __|
; right           5      |      |               |                        |      |
; marginTop       6      |      |            ___|_______________         |      |
; marginBottom    7      |      |           |                   |        |      |
; marginLeft      8     12     10           1                   |        |      |
; marginRight     9      |      |---- 3 ----|                   |-- 5 ---|      |
;                        |      |           |_______ 4 _________|        |      |
;                        |      |              |                         |      |
;                        |      |              2                         |      |
;                        |      |______________|_________________________|      |
;                        |                                    |                 |
;                        |                                    7                 |
;                        |____________________________________|_________________|
;                        |
;                       \/
;                       (y)
; get default geometry from settings
; and add random X and Y layout
(define (get-default-geometry settings kind)
  (let ((random-point (get-default-layout)))
    (hash-union
     (hash-ref (hash-ref settings 'geometry) kind)
     (string->jsexpr                                                  
      (string-join                                 
       (list "{\"X\" : "(~a (point-X random-point))"}")))
     (string->jsexpr                                                 
      (string-join                                                 
       (list "{\"Y\" : "(~a (point-Y random-point))"}"))))))

; add default geometry to elements
(define (add-default-geometry data settings)
  (map (λ (v) (hash-union
               v
               (get-default-geometry
                settings
                [string->symbol (hash-ref v 'kind)])))
       (hash-ref data 'elements)))

; get data with default geometry
(define (init-geometry data-file settings-file)
  (add-default-geometry
   (call-with-input-file data-file read-json)
   (call-with-input-file settings-file read-json)))