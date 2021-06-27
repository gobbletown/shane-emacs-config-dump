(provide 'my-ido)

;; [[https://www.masteringemacs.org/article/introduction-to-ido-mode][Introduction to Ido Mode - Mastering Emacs]]

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(setq ido-use-filename-at-point 'guess)
(setq ido-create-new-buffer 'always)
(setq ido-file-extensions-order '(".org" ".txt" ".py" ".emacs" ".xml" ".el" ".ini" ".cfg" ".cnf"))

(defun find-file-at-point-around-advice (proc &rest args)
  (let* ((completing-read-function 'ido-completing-read+)
         (res (apply proc args)))
    res))
(advice-add 'find-file-at-point :around #'find-file-at-point-around-advice)
;; (advice-add 'ffap-list-directory :around #'find-file-at-point-around-advice)
;; (advice-remove 'ffap-list-directory #'find-file-at-point-around-advice)
