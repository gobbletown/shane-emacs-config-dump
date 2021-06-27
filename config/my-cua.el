;; (defun cua-paste (arg)
;;   "Paste last cut or copied region or rectangle.
;; An active region is deleted before executing the command.
;; With numeric prefix arg, paste from register 0-9 instead.
;; If global mark is active, copy from register or one character."
;;   (interactive "P")
;;   (setq arg (cua--prefix-arg arg))
;;   (let ((regtxt (and cua--register (get-register cua--register)))
;; 	(count (prefix-numeric-value arg)))
;;     (cond
;;      ((and cua--register (not regtxt))
;;       (message "Nothing in register %c" cua--register))
;;      (cua--global-mark-active
;;       (if regtxt
;; 	  (cua--insert-at-global-mark regtxt)
;; 	(when (not (eobp))
;; 	  (cua--insert-at-global-mark
;;            (filter-buffer-substring (point) (+ (point) count)))
;; 	  (forward-char count))))
;;      (buffer-read-only
;;       (error "Cannot paste into a read-only buffer"))
;;      (t
;;       (cond
;;        (regtxt
;; 	(cond
;; 	 ;; This being a cons implies cua-rect is loaded?
;; 	 ((consp regtxt) (cua--insert-rectangle regtxt))
;; 	 ((stringp regtxt) (insert-for-yank regtxt))
;; 	 (t (message "Unknown data in register %c" cua--register))))
;;        ((eq this-original-command 'clipboard-yank)
;; 	(clipboard-yank))
;;        ((eq this-original-command 'x-clipboard-yank)
;; 	(x-clipboard-yank))
;;        (t (yank arg)))))))

(require 'cua-base)

(define-key global-map (kbd "<M-f5>") 'cua-paste)

(provide 'my-cua)