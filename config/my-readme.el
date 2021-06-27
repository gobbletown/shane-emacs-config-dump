(defun go-to-readme ()
  (interactive)
  (let* ((dir
          (if (>= (prefix-numeric-value current-prefix-arg) 4)
              (vc-get-top-level)
            (my/pwd)))
         (sel (fz (chomp (sn "find-readme-here | sed 's/^\\.\\///'" nil dir)))))
    (if sel
        (e (concat dir "/" sel)))))

(define-key global-map (kbd "H-R") 'go-to-readme)

(provide 'my-readme)