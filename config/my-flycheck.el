(require 'flycheck)

(defun flycheck-show-messages-function (errors)
  "Display ERRORS, using a graphical tooltip on GUI frames."
  (when errors
    (if (display-graphic-p)
        (let ((message (mapconcat #'flycheck-error-format-message-and-id
                                  errors "\n\n"))
              (line-height (car (window-line-height))))
          ;; (pos-tip-show message nil nil nil flycheck-pos-tip-timeout
          ;;               flycheck-pos-tip-max-width nil
          ;;               ;; Add a little offset to the tooltip to move it away
          ;;               ;; from the corresponding text in the buffer.  We
          ;;               ;; explicitly take the line height into account because
          ;;               ;; pos-tip computes the offset from the top of the line
          ;;               ;; apparently.
          ;;               nil (and line-height (+ line-height 5)))
          )
      ;; (funcall flycheck-pos-tip-display-errors-tty-function errors)
      )))

;; This shows the column
;; (setq flycheck-display-errors-function 'flycheck-show-messages-function)
(setq flycheck-display-errors-function 'flycheck-pos-tip-error-messages)
(setq flycheck-display-errors-function nil)

;; (defun flycheck-display-error-messages-unless-error-buffer (errors)
;;   (unless (get-buffer-window flycheck-error-list-buffer)
;;     (flycheck-display-error-messages errors)))

;; (setq flycheck-display-errors-function #'flycheck-display-error-messages-unless-error-buffer)

;; (define-key flycheck-mode-map (kbd "M-P") 'flycheck-previous-error)
;; (define-key flycheck-mode-map (kbd "M-N") 'flycheck-next-error)

(define-key flycheck-mode-map (kbd "M-P") nil)
(define-key flycheck-mode-map (kbd "M-N") nil)

(defun flycheck-error-list-next-error-view ()
  (interactive)
  (save-excursion
    (call-interactively 'flycheck-error-list-next-error))
  (next-line-nonvisual))

;; (define-key flycheck-mode-map (kbd "M-L") 'flycheck-list-errors)
;; (define-key flycheck-mode-map (kbd "M-L") nil)
;; (define-key flycheck-mode-map (kbd "M-l M-L") nil)

(use-package flycheck
  :defer 2
  :diminish
  :init (global-flycheck-mode)
  :custom
  (flycheck-display-errors-delay .3)
  (flycheck-stylelintrc "~/.stylelintrc.json"))


;; ;; :modes () doesn't work
;;(flycheck-define-checker github-super-linter
;;  "GitHub's super linter"
;;  :command ("super-linter"
;;            ".")
;;  :error-parser flycheck-parse-checkstyle
;;  :error-filter flycheck-dequalify-error-ids
;;  :modes () ;; (go-mode yaml-mode terraform-mode markdown-mode dockerfile-mode sh-mode xml-mode json-mode ruby-mode javascript-mode)
;;  )
;;
;;;; It's driving me kinda crazy the way it runs on everything!
;;;; Disable until I can make it more efficient
;;(add-to-list 'flycheck-checkers 'github-super-linter)
;; (remove-from-list 'flycheck-checkers 'github-super-linter)


(flycheck-define-checker tflint
  "Terraform linter tflint"
  :command ("tflint"
            source-inplace)
  :error-parser flycheck-parse-checkstyle
  :error-filter flycheck-dequalify-error-ids
  :modes (terraform-mode))

(add-to-list 'flycheck-checkers 'tflint)


;; I couldn't find a way to permanently remove flycheck-haskell
;; (add-to-list 'flycheck-disabled-checkers 'haskell-stack-ghc)

(provide 'my-flycheck)