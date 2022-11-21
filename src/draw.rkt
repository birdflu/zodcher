(require xml)

(define (get-element-xml json-element)
  (define (value key)
    (hash-ref json-element key))
  (let ((xml-element-pattern
         '(mxCell ((id "$id")
                   (parent "$parent")
                   (value "$value")
                   (style "$style")
                   (vertex "1"))
                  (mxGeometry ((width "$width")
                               (height "$height")
                               (relative "1")
                               (as "geometry"))
                              (mxPoint
                               ((x "$x")
                                (y "$y")
                                (as "offset")))))  ))
  
    
    (string->xexpr
     (regexp-replace*
      #rx"\\$[A-z]+"
      (xexpr->string xml-element-pattern)
      (λ (s)
        (hash-ref
         (hash "$id" (value 'id)
               "$parent" (if (null? (value 'idParent))
                             "diagram"
                             (value 'idParent))
               "$value" (value 'name)
               "$style" (value 'style)
               "$width" (number->string (+
                                         (value 'left)
                                         (value 'paddingWidth)
                                         (value 'right)))
               "$height" (number->string (+
                                          (value 'top)
                                          (value 'paddingHeight)
                                          (value 'bottom)))
               "$x" (number->string (value 'X))
               "$y" (number->string (value 'Y)))
         s))))
    ))

(define (show data)
  (display-xml/content (xexpr->xml data)
                       #:indentation 'classic))

(define (draw data)
  data)