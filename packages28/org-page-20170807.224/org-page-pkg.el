(define-package "org-page" "20170807.224" "a static site generator based on org mode"
  '((ht "1.5")
    (simple-httpd "1.4.6")
    (mustache "0.22")
    (htmlize "1.47")
    (org "8.0")
    (dash "2.0.0")
    (cl-lib "0.5")
    (git "0.1.1"))
  :commit "d0e55416174a60d3305e97ca193b333f4cccba4f" :authors
  '(("Kelvin Hu <ini DOT kelvin AT gmail DOT com>"))
  :maintainer
  '("Kelvin Hu <ini DOT kelvin AT gmail DOT com>")
  :keywords
  '("org-mode" "convenience" "beautify")
  :url "https://github.com/kelvinh/org-page")
;; Local Variables:
;; no-byte-compile: t
;; End:
