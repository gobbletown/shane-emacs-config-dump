(defun check-if-fortran ()
  (if (string-equal (detect-language) "fortran")
      (fortran-mode)))

(add-hook 'forth-mode-hook 'check-if-fortran)

(provide 'my-forth)