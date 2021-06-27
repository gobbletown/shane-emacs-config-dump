;; TODO
;; - persistent lists i.e. save elisp data to file
;; - buttonise from one of these lists

;; cd "$NOTES"; ln -sf $NOTES/reference-lists/.references

(defcustom reference-lists-file (locate-user-emacs-file "references" ".references")
  "File where references are stored."
  :type 'file
  :group 'reference-lists)

;; %s/reference-lists/reference-lists

(defun reference-lists-load-ref-data ()
  "Read and return saved reference-lists."
  (with-temp-buffer
    (when (file-exists-p reference-lists-file)
      (insert-file-contents reference-lists-file))
    (goto-char (point-max))
    (cond ((= (point) 1)
           nil)
          (t
           (goto-char (point-min))
           (read (current-buffer))))))


(defun reference-lists-load-refs ()
  "Load all refs from disk.

The format of the database is:

(list record-1 record-2 ... record-n)

Each record is:

(list filename refs checksum)

where:

filename: a string identifying a file on the file-system, or the
string \"dir\" for top-level info file.

checksum: a string used to fingerprint the reference-lists file above,
used to check if a file has been modified.

refs:

(list ref-1 ref-2 ... ref-n) or nil

finally refl is:

(list start end ref-string reference-listsd-text)

start:             the buffer position where reference-listsd text start
end:               the buffer position where reference-listsd text ends
ref-string: the text of refl
reference-listsd-text:    the substring of buffer starting from 'start' an ending with 'end' (as above)

example:

'(\"/foo/bar\" ((0 9 \"note\" \"reference-listsd\")) hash-as-hex-string)

"
  (cl-labels ((old-format-p (refl)
                            (not (stringp (cl-first (last refl))))))
    (interactive)
    (let* ((filename             (reference-lists-actual-file-name))
           (all-refs-data (reference-lists-load-ref-data))
           (ref-dump      (assoc-string filename all-refs-data))
           (refs          (reference-lists-refs-from-dump ref-dump))
           (old-checksum         (reference-lists-checksum-from-dump ref-dump))
           (new-checksum         (reference-lists-buffer-checksum))
           (modified-p           (buffer-modified-p)))
      (if (old-format-p ref-dump)
          (reference-lists-load-ref-old-format)
        (when (and (not (old-format-p ref-dump))
                   old-checksum
                   new-checksum
                   (not (string= old-checksum new-checksum)))
          (lwarn '(reference-lists-mode)
                 :warning
                 reference-lists-warn-file-changed-control-string
                 filename))
        (cond
         ((and (null refs)
               reference-lists-use-messages)
          (message "No refs found."))
         (refs
          (save-excursion
            (dolist (refl refs)
              (let ((start             (reference-lists-beginning-of-ref refl))
                    (end               (reference-lists-ending-of-ref    refl))
                    (ref-string (reference-lists-ref-string       refl))
                    (reference-listsd-text    (reference-lists-reference-listsd-text          refl)))
                (reference-lists-create-ref start
                                            end
                                            ref-string
                                            reference-listsd-text))))))
        (set-buffer-modified-p modified-p)
        (font-lock-fontify-buffer)
        (when reference-lists-use-messages
          (message "Refs loaded."))))))



(provide 'my-reference-lists)