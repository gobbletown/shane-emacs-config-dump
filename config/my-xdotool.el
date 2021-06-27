(defun xdotool-press-key ()
  (interactive)
  (let ((c (fz (snc (cmd "cat" "$NOTES/ws/xdotool/keys-oneliners.sh")))))
    (if (sor c)
        (sh c))))

(provide 'my-xdotool)