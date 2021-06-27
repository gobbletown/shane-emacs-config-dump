(require 'awk-ward)

(defun awk-ward--run (program input output-buf)
  "Run Awk PROGRAM with INPUT, writing output to OUTPUT-BUF.

Both PROGRAM and INPUT are paths to files."
  (with-current-buffer (get-buffer-create output-buf)
    (delete-region (point-min) (point-max)))
  (make-process
   :name "awk-ward"
   :buffer output-buf
   :command `(,awk-ward-command ,@awk-ward-options ,program ,input)
   :sentinel #'ignore
   :filter (lambda (process string)
             (with-current-buffer (process-buffer process)
               (insert string)
               (goto-char (point-min))
               (set-marker (process-mark process) (point))))))

(setq awk-ward-options (list "-f"))
(setq awk-ward-command "awk-for-awkward")

(defun awk-ward-cmd (&optional cmd opts)
  (interactive)
  (if (not cmd)
      (setq cmd "awk-for-awkward"))
  (if (not opts)
      (setq opts (list "-f")))

  (let ((awk-ward-program-buffer (concat "*Awk-ward(" cmd ") Program*"))
        (awk-ward-output-buffer (concat "*Awk-ward(" cmd ") Output*"))
        (awk-ward-input-buffer (concat "*Awk-ward(" cmd ") Input*")))

    (awk-ward (or (and (eq major-mode 'awk-mode)
                       (current-buffer))
                  awk-ward-program-buffer)
              (or (and current-prefix-arg
                       (find-file-noselect (read-file-name "Input file: " nil nil t)))
                  awk-ward-input-buffer)
              cmd
              opts)))

(defun awk-ward-sed ()
  (interactive)
  (awk-ward-cmd "sed"))

(provide 'my-awk-ward)