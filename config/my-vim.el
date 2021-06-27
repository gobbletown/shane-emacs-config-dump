;; TODO Rather than requiring my-utils here, if I wanted to add a notification to the my-copy-line function I should do it by adding advice from utils.el.

(require 'auto-highlight-symbol)

;; This is nice. I should make more of these to emulate vim
;; Need to check here if it is in evil mode


;; Check to see evil is enabled, then check evil state
;; TODO
;; (cond
;;  ((eq evil-state 'visual) (do-something))
;;  ((eq evil-state 'normal) (do-other-thing))
;;  ((eq evil-state 'insert) (do-another-thing)))

(defun my-copy-line (&optional arg)
  "arg is C-u, if provided"
  (interactive "P")
  (if (region-active-p)
      (progn
        (execute-kbd-macro (kbd "M-w"))
        (ns (yanked) t)
        (deselect))
    (progn
      ;; Instead of M-e, use (end-of-line)
      ;; Org end of line doesn't take you to the end of a wrapped line
      ;; (execute-kbd-macro (kbd "C-@ C-a C-a M-w"))
      (if (equal current-prefix-arg nil) ;; No C-u
          (progn
            (end-of-line)
            (call-interactively 'cua-set-mark)
            (beginning-of-line-or-indentation)
            (beginning-of-line-or-indentation)
            (call-interactively 'cua-exchange-point-and-mark)
            ;; (execute-kbd-macro (kbd "C-@ C-a C-a C-x C-x"))
            )
        (progn
          (beginning-of-line)
          (cua-set-mark)
          ;; (call-interactively 'cua-set-mark)
          (end-of-line)
          ;; (call-interactively 'cua-exchange-point-and-mark)
          ;; (execute-kbd-macro (kbd "C-@ C-a C-x C-x"))
          )))))

(defun my-copy-line-evil-normal ()
  (interactive)
  (if (region-active-p)
      (progn
        (execute-kbd-macro (kbd "y"))
        (deselect))
    (progn
      (end-of-line)
      ;; Instead of M-e, use (end-of-line)
      ;; Org end of line doesn't take you to the end of a wrapped line
      (execute-kbd-macro (kbd "v ^ y"))
      (end-of-line)
      (execute-kbd-macro (kbd "v ^")))))

;; select line, copy, reselect line
;; (define-key global-map (kbd "M-Y") (kbd "C-a C-e C-a C-@ C-e M-w C-a C-e C-a C-@ C-e"))

;; If M-w has not been changed then this should work normally
;(define-key global-map (kbd "M-Y") (kbd "C-e C-a C-e C-@ C-a M-w"))
(define-key global-map (kbd "M-Y") #'my-copy-line)


;; ;; It's better to use evil
;; (defun my-kleene-star ()
;;   (interactive)
;;   (if (region-active-p)
;;       (progn
;;         (copy-region-as-kill nil nil 'region)
;;         (deselect)
;;         (isearch-mode t)
;;         (execute-kbd-macro (kbd "C-y")))))

(defun my-vim-star ()
  "This is vim's * operator."
  (interactive)
  (if (region-active-p)
      (progn
        (ahs-forward)
        (ahs-backward))))


(defun CP (new-file-name)
  "Creates a copy of the file connected to the current buffer's file with the new name new-file-name."
  (interactive)
  (let ((lcmd `(b cp -a ,(buffer-file-path) ,(concat (buffer-file-dir) "/" new-file-name))))
    (eval lcmd)
    (message (str lcmd))))


(provide 'my-vim)