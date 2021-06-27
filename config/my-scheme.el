(provide 'my-scheme)
(require 'geiser)

(setq geiser-default-implementation 'racket)


;; (setq geiser-active-implementations '(racket))

;; The purpose of geiser-active-implementations is to allow an
;; implementation to be selected as a function of current file type. The
;; purpose of geiser-default-implementation (IIUC) is to specify the
;; implementation to use when current file/buffer isn't sufficient to
;; determine it. Having lots of active implementations configured shouldn't
;; preclude specifying one as the default. 


(advice-add 'geiser-repl--wrap-fontify-region-function :around #'ignore-errors-around-advice)
(advice-add 'geiser-repl--wrap-unfontify-region-function :around #'ignore-errors-around-advice)


(defun my-start-scheme-repl ()
  (interactive)
  (if (buffer-match-p "* Guile REPL *")
      (switch-to-buffer "* Guile REPL *")
    (geiser 'guile)))


(setq scheme-program-name "mzscheme")