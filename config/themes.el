;;; Treat all themes as safe
;; Because sometimes emacs goes insane
;; This doesn't work for spacemacs.
(setq custom-safe-themes t)

; this forces themes to be safe
(defun custom-theme-load-confirm (hash)
  "Query the user about loading a Custom theme that may not be safe.
The theme should be in the current buffer.  If the user agrees,
query also about adding HASH to `custom-safe-themes'."
  (unless noninteractive
    (save-window-excursion
      (rename-buffer "*Custom Theme*" t)
      (emacs-lisp-mode)
      (pop-to-buffer (current-buffer))
      (goto-char (point-min))
      (prog1 (when t
               ;; Offer to save to `custom-safe-themes'.
               (and (or custom-file user-init-file)
                    t
                    (customize-push-and-save 'custom-safe-themes (list hash)))
               t)
        (quit-window)))))