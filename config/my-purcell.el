;; [[https://github.com/purcell/emacs.d/issues/273][moving around between
;; cjk characters is very slow  Issue #273  purcell/emacs.d  GitHub]]

; this should help with the slugishness
(setq inhibit-compacting-font-caches t)

;; This is one of the things that Purcell emacs had
(global-set-key [remap eval-expression] 'pp-eval-expression)


;; (if (cl-search "PURCELL" my-daemon-name)
;;     (setq debug-on-error nil))

(provide 'my-purcell)