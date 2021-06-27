(require 'emojify)

(defun emoji-github ()
  "List of GitHub's emoji."
  (interactive)
  (switch-to-buffer emoji-github--buffer-name)
  (with-current-buffer emoji-github--buffer-name
    (emoji-github-mode)))

;; I think that this turns things like markdown style emojis into unicode 
(use-package emojify
  :config
  (progn
    (setq emojify-display-style 'unicode)
    (setq emojify-emoji-set "emojione-v2.2.6"))
  ;; (if (display-graphic-p)
  ;;     (setq emojify-display-style 'image))
  :init (global-emojify-mode 1))


(provide 'my-emojify)