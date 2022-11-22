(require xml)

(define DIAGRAM_ID "zodcher-diagram")

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

(define (xml-list->string xml-list)
  (string-append* "" xml-list))

(define (add-root-tag xml)
  (string-append "<root>" xml "</root>"))

(define (add-page-cell xml-list)
  (cons '"<mxCell id=\"zodcher-diagram\"/>"
        (cons '"<mxCell id=\"page-1\" parent=\"zodcher-diagram\"/>" xml-list)))

(define (show data)
  (display-xml/content
   (xexpr->xml
    (string->xexpr
     (add-root-tag
      (xml-list->string
       (add-page-cell
        (get-xml-element-list data))))))
   #:indentation 'classic))

(define (draw data)
  (show data))
