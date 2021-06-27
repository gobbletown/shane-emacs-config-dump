(require 'tabulated-list)

(defun cmd-tabulated-list (&optional csv_fp csv_type)
  "csv_type is kinda like the mode name"
  (interactive)
  (let* ((csv (cat (or csv_fp "/dev/null"))))
    (with-current-buffer (new-buffer-from-string "")
      (insert csv))))

(provide 'my-cmd-tabulated-list)