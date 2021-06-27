(provide 'my-compatibility)

;; I think that this is deprecated. It comes from emacs24. But it means
;; some of my emacs distributions are not showing recentf, which is
;; annoying.

(defcustom ivy-height-alist nil
  "An alist to customize `ivy-height'.

It is a list of (CALLER . HEIGHT).  CALLER is a caller of
`ivy-read' and HEIGHT is the number of lines displayed."
  :type '(alist :key-type function :value-type integer))


; (defadvice show-paren-function (around fix-show-paren-function activate)
;    (cond ((looking-at-p "\\s(") ad-do-it)
;      (t (save-excursion
;           (ignore-errors (backward-up-list))
;           ad-do-it)))
;    )

(if (and (not (fexists 'org-projectile:per-repo))
         (fexists 'org-projectile-per-project))
    (defalias 'org-projectile:per-repo 'org-projectile-per-project))

(defalias 'string-to-int 'string-to-number)