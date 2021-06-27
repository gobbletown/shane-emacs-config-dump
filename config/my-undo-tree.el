(require 'undo-tree)

;; I want to use normal undo for region, not undotree
;; I should use advice around undo for this
(setq undo-tree-enable-undo-in-region nil)
(setq undo-tree-auto-save-history t)
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))

(setq undo-tree-visualizer-diff t)
(setq undo-tree-visualizer-timestamps t)

(defmacro save-buffer-state (&rest body)
  "Like save-excursion but for edits."
  `(progn
     (undo-tree-save-state-to-register ?s)
     ,@body
     (undo-tree-restore-state-from-register ?s)
     nil))


(advice-add 'undo-tree-undo :around #'advise-to-save-region)
(advice-remove 'undo-tree-undo #'advise-to-save-region)
(advice-add 'undo :around #'advise-to-save-region)
(advice-remove 'undo #'advise-to-save-region)
(advice-add 'special-lispy-undo :around #'advise-to-save-region)
(advice-remove 'special-lispy-undo #'advise-to-save-region)

(defun undo-tree-undo-around-advice (proc &rest args)
  (if (selected)
      (call-interactively 'undo)
    (let ((res (apply proc args)))
      res)))
(advice-add 'undo-tree-undo :around #'undo-tree-undo-around-advice)
(advice-add 'special-lispy-undo :around #'undo-tree-undo-around-advice)

(advice-add 'undo-tree-make-history-save-file-name :around #'shut-up-around-advice)
(advice-add 'undo-tree-save-history :around #'shut-up-around-advice)

;;; This should do the normal undo. Forget it.
;; (define-key undo-tree-map (kbd "C-_") 'undo)

;; (advice-add 'undo-tree-undo :around #'advise-to-save-excursion)
;; (advice-add 'special-lispy-undo :around #'advise-to-save-excursion)

;; (advice-remove 'undo-tree-undo #'advise-to-save-excursion)
;; (advice-remove 'special-lispy-undo #'advise-to-save-excursion)


;; Disable undo-tree. it's just too slow
(global-undo-tree-mode -1)



(provide 'my-undo-tree)