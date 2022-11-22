(require xml)

(define DIAGRAM_ID "zodcher-diagram")
(define PAGE_ID "page-1")
(define GRAPH_MODEL_TAG (string-append
                         "dx=\"1200\""
                         "dy=\"900\""
                         "grid=\"1\""
                         "gridSize=\"10\""
                         "guides=\"1\""
                         "tooltips=\"1\""
                         "connect=\"1\""
                         "arrows=\"1\""
                         "fold=\"1\""
                         "page=\"1\""
                         "pageScale=\"1\""
                         "pageWidth=\"1000\""
                         "pageHeight=\"800\""
                         "math=\"0\""
                         "shadow=\"0\""))
(define MX_FILE_TAG (string-append
                     "host=\"app.diagrams.net\""
                     "modified=\"\""
                     "agent=\"\""
                     "etag=\"-lJEG1eWEpPOzzp1d58H\""
                     "compressed=\"false\""
                     "version=\"14.6.11\""
                     "type=\"device\""))

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
                            PAGE_ID
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

(define (add-graph-model-tag xml)
  (string-append
   "<mxGraphModel" GRAPH_MODEL_TAG ">"
   xml
   "</mxGraphModel>"))

(define (add-header xml)
  (string-append "<mxfile " MX_FILE_TAG ">"
                 "<diagram id=\"" DIAGRAM_ID "\" name=\"Diagram\">"
                 "<mxGraphModel " GRAPH_MODEL_TAG ">"
                 "<root>"
                 xml
                 "</root>"
                 "</mxGraphModel>"
                 "</diagram>"
                 "</mxfile>"))

(define (add-page-cell xml-list)
  (cons (string-append "<mxCell id=\"" PAGE_ID "-p\"/>") 
        (cons (string-append "<mxCell id=\"" PAGE_ID
                             "\" parent=\""  PAGE_ID
                             "-p\"/>")
              xml-list)))

(define (draw data port)
  (display-xml/content
   (xexpr->xml
    (string->xexpr
     (add-header
      (xml-list->string
       (add-page-cell
        (get-xml-element-list data))))))
   port
   #:indentation 'classic))
