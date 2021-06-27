;; sadly this appears not to work

;; https://emacs.stackexchange.com/questions/24693/make-opening-clickable-filenames-from-help-mode-in-same-window

(defun eab/push-button-on-file-same-window ()
  (interactive)
  (let ((cwc (current-window-configuration))
        (hb (current-buffer))
        (file? (button-get (button-at (point)) 'help-args)))
    (funcall
     `(lambda ()
        (defun eab/push-button-on-file-same-window-internal ()
          (if (> (length ',file?) 1)
              (let ((cb (current-buffer)))
                (set-window-configuration ,cwc)
                (switch-to-buffer cb)
                (kill-buffer ,hb)))))))
  (call-interactively 'push-button)
  (run-with-timer 0.01 nil 'eab/push-button-on-file-same-window-internal))

(provide 'my-help-mode)