(require json)
(define settings
  (call-with-input-file "settings.json" read-json))