;; There is no need for my-magit-mode, because magit-mode exists
;; (define-derived-mode magit-mode special-mode "Magit"
;;   "Parent major mode from which Magit major modes inherit.")


;; This mode is for all of magit
;; There might be a time I want to define bindings that work in all of magit

(defvar my-magit-mode-map (make-sparse-keymap)
  "Keymap for `my-magit-mode'.")

(define-minor-mode my-magit-mode
  "A minor mode so that my key settings override annoying major modes."
  ;; If init-value is not set to t, this mode does not get enabled in
  ;; `fundamental-mode' buffers even after doing \"(global-my-mode 1)\".
  ;; More info: http://emacs.stackexchange.com/q/16693/115
  :init-value t
  :lighter " my-magit-mode"
  :keymap my-magit-mode-map)

;; We don't want a global mode
;; (define-globalized-minor-mode global-my-magit-mode my-magit-mode my-magit-mode)

;; (define-key my-magit-mode-map (kbd "M-e") #'org-agenda)

(provide 'my-magit-mode)