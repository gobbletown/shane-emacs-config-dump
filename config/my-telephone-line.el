;; (load "/home/shane/source/git/config/emacs/packages27/telephone-line-20190127.1523/telephone-line.el")
(require 'telephone-line)

(setq telephone-line-lhs
      '((evil   . (telephone-line-evil-tag-segment))
        (accent . (telephone-line-vc-segment
                   telephone-line-erc-modified-channels-segment
                   telephone-line-process-segment))
        (nil    . (
                   ;; telephone-line-minor-mode-segment
                   telephone-line-buffer-segment))))
;; (setq telephone-line-lhs
;;       ;; '()
;;       )
(setq telephone-line-rhs
        '((nil    . (telephone-line-misc-info-segment))
          (accent . (telephone-line-major-mode-segment))
          (evil   . (telephone-line-airline-position-segment))))





(defset telephone-line-utf-abs-right
  (make-instance 'telephone-line-unicode-separator
                 ;; :char 57522
                 :char ?>
                 :inverse-video nil))
(defset telephone-line-utf-abs-left
  (make-instance 'telephone-line-unicode-separator
                 ;; :char #xe0b0
                 :char ?<
                 ))
(defset telephone-line-utf-abs-hollow-right
  (make-instance 'telephone-line-unicode-separator
                 ;; :char #xe0b3
                 :char ?>))
(defset telephone-line-utf-abs-hollow-left
  (make-instance 'telephone-line-unicode-separator
                 ;; :char #xe0b1
                 :char ?<))



;; Do not use telephone-line. It does not have ascii separators
;; (telephone-line-mode t)

;; To recompile telephone-line, I have to disable the mode, reenable it and reopen the current file

(provide 'my-telephone-line)
