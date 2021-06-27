(defun myrc-set (key value)
  (interactive (let* ((key (read-string-hist (concat "myrc-set key: ")))
                      (value (read-string-hist (concat "myrc-set " (q key) " value: "))))
                 (list key value)))
  (cl-sn (concat "myrc-set " (q key) " " (q value))
         :chomp t :b_output-return-code t))

;; newvalue is "on" or "off" or nil
(defun toggle-myrc (option &optional newvalue quiet)
  (interactive (list (fz toggle-myrc-keys)))
  (if option
      (let* ((oldstate (equalp "0" (cl-sn (concat "upd myrc-test " (q option)) :chomp t :b_output-return-code t)))
             (newstate (if (interactive-p)
                           (cl-sn (concat "myrc-toggle " (q option)) :chomp t :b_output-return-code t)
                         (if (and newvalue (not (eq oldstate (equalp "on" newvalue))))
                             (progn
                               (cl-sn (concat "myrc-set " (q option) " " (if (equalp "on" newvalue)
                                                                             "on"
                                                                           "off"))
                                      :chomp t :b_output-return-code t)
                               (not oldstate))
                           oldstate))))
        (if (not quiet)
            (if newstate
                (message (concat option " enabled"))
              (message (concat option " disabled"))))
        newstate)))

(defun myrc-get (key)
  (if (and key (not (string-blank-p key)))
      (snc (concat "cat $HOME/.myrc.yaml | yq -r '." key "'"))))

(defun myrc-test (key)
  (let ((v (chomp (myrc-get key))))
    (and v (string-equal v "true"))))

;; (memoize-orig 'myrc-test)
;; (memoize-restore 'myrc-test)

;; Why does the memoization not work?
;; It only memoizes when the result is truthy
(myrc-test "auto_flyspell_flycheck")

(provide 'my-myrc)