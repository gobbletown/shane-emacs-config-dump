;; even though spacemacs has this, it's necessary to reload it here from melpa

;; (my/add-to-load-path-glob "/home/shane/source/git/config/emacs/packages27/ht-[0-9]*")
;; (load-library "ht")


(never
 ;; For playing around with hash tables in elisp

 (require 'ht)
 (let ((h (ht))
       (tuples '(("example 1\nexample2" "^example [12]$")
                 ("example 2\nexample3" "^example [23]$")
                 ("pi4\npi5" "^pi[45]$"))))
   (cl-loop for tp in tuples do
            (message (pps tp))
            (let ((slug (slugify (car tp))))
              (ht-set h slug (second tp)))
            ;; (buffer-file-name buf)
            )
   (message (pps h))))



(defun ht-test-serialise ()
  (interactive)

  (with-current-buffer (find-file-noselect "/tmp/x")
    (let ((h (make-hash-table)))
      (puthash 'a 0 h)
      (puthash 'b 1 h)
      (insert (format "%s" h))
      (save-buffer)))


  ;; Reading back the hash-table object

  (let ((ret (read (find-file-noselect "/tmp/x"))))
    (kill-buffer "x")
    (message (str ret))))


(provide 'my-ht)