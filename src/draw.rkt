(require xml)

(define DIAGRAM_ID "zodcher_diagram")

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
    (regexp-replace*
     #rx"\\$[A-z]+"
     (xexpr->string xml-element-pattern) 
     (λ (s)
       (hash-ref
        (hash "$id" (value 'id)
              "$parent" (if (eq? 'null (value 'idParent))
                            DIAGRAM_ID
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
        s)))
    ))


(define (get-xml-element-list data)
  (map
   (λ(hash-list-data) (get-element-xml hash-list-data))
   data))

(define (add-tag-root xml-element-list)
  (string-append
   (string-append* "<root>"  xml-element-list)
   "</root>"))

(define (show data)
  (display-xml/content
   (xexpr->xml
    (string->xexpr
     (add-tag-root
      (get-xml-element-list data))))
   #:indentation 'classic))

(define (draw data)
  (show data))
