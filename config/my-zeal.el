;; This is a lot like helm-dash
;; I can't store docsets for everything, let alone 2 sets, on my laptop; they simply wont fit

(defset zeal-at-point-zeal-version
  (when (executable-find "zeal")
    (let ((output (with-temp-buffer
                    (call-process "zeal" nil t nil "--version")
                    (buffer-string))))
      (when (string-match "Zeal \\([[:digit:]\\.]+\\)" output)
        (match-string 1 output))))
  "The version of zeal installed on the system.")

(provide 'my-zeal)