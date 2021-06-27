(defun dired-google-drive ()
  (interactive)
  (if (not (< 0 (length (snc "ls ~/GoogleDrive/"))))
      (snc "unbuffer mount-google-drive"))
  (dired "~/GoogleDrive"))

(provide 'my-gcs)