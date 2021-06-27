(require 'helm-gtags)
(require 'ggtags)

(define-key helm-gtags-mode-map (kbd "M-.") nil)
(define-key ggtags-mode-map (kbd "M-.") nil)
(define-key ggtags-mode-map (kbd "M-]") nil)
(define-key ggtags-mode-map (kbd "M-*") nil)

(use-package ggtags
  :ensure t
  :config
  (add-hook 'c-mode-common-hook
            (lambda ()
              (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
                (ggtags-mode 1)))))

(defun ggtags-process-string-around-advice (proc &rest args)
  (ignore-errors
    (let ((res (apply proc args)))
      res)))
(advice-add 'ggtags-process-string :around #'ggtags-process-string-around-advice)

(provide 'my-gtags)