;; Need to be able to change this syntax highlighting to be less bright
;; The spacemacs theme seems to be ok

(require 'highlight-thing)
(provide 'my-highlight-thing)

(setq highlight-thing-delay-seconds 0)
(setq highlight-thing-ignore-list '("False" "True"))
(setq highlight-thing-exclude-thing-under-point t)
(setq highlight-thing-case-sensitive-p t)
(setq highlight-thing-prefer-active-region t)

;;(setq highlight-thing-limit-to-region-in-large-buffers-p nil
;;	  highlight-thing-narrow-region-lines 15
;;	  highlight-thing-large-buffer-limit 5000)


;; Disable region highlight
(defun highlight-thing-should-highlight-region-p () nil)
;; Now there is no need for this
;;(setq highlight-thing-large-buffer-limit 5000)

;; I'd like to disable region highlight and have only the current word
;; highlight
;; It's really slow for 
(global-highlight-thing-mode)