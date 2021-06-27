(require 'company-plsense)

(add-to-list 'company-backends 'company-plsense)
(add-hook 'perl-mode-hook 'company-mode)
(add-hook 'cperl-mode-hook 'company-mode)


(defun check-if-prolog ()
  (if (string-equal (detect-language t) "prolog")
      (prolog-mode)))

(add-hook 'perl-mode-hook 'check-if-prolog)

(provide 'my-perl)