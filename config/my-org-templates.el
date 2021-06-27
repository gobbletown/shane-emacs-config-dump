(provide 'my-org-templates)


;;; TODO Make a template for draw the default
;;; #+begin_src sh :results verbatim drawer
;
;
;;; this alist contains the templates
;;; org-structure-template-alist
;
;;; Add a new template
;;; (add-to-list 'org-structure-template-alist
;;;              '("P" "#+TITLE:\n#+OPTIONS: html-postamble:nil whn:nil toc:nil nav:nil\n#+HTML_HEAD:\n#+HTML_HEAD_EXTRA:\n\n? "))
;
;;; This is also a way to add templates
;;; With this, <not will expand to BEGIN_NOTES when I hit tab
;(eval-after-load "org"
;  '(cl-pushnew
;    '("not" "#+BEGIN_NOTES\n?\n#+END_NOTES")
;    org-structure-template-alist))
;
;(add-to-list
; 'org-structure-template-alist
; '("el" "#+begin_src emacs-lisp\n?\n#+end_src" "<src lang=\"emacs-lisp\">\n?\n</src>"))
;
;(add-to-list
; 'org-structure-template-alist
; '("sh" "#+begin_src sh\n?\n#+end_src" "<src lang=\"sh\"></src>"))