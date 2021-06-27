(define-package "lean-mode" "20210305.1705" "A major mode for the Lean language"
  '((emacs "24.3")
    (dash "2.18.0")
    (s "1.10.0")
    (f "0.19.0")
    (flycheck "30"))
  :commit "5c50338ac149ca5225fc737be291db1f63c45f1d" :authors
  '(("Leonardo de Moura" . "leonardo@microsoft.com")
    ("Soonho Kong      " . "soonhok@cs.cmu.edu")
    ("Gabriel Ebner    " . "gebner@gebner.org")
    ("Sebastian Ullrich" . "sebasti@nullri.ch"))
  :maintainer
  '("Sebastian Ullrich" . "sebasti@nullri.ch")
  :keywords
  '("languages")
  :url "https://github.com/leanprover/lean-mode")
;; Local Variables:
;; no-byte-compile: t
;; End:
