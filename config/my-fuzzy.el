;; This is for things to do with the fuzzy/ directory
;; $NOTES/ws/fuzzy


(defun fuzzy-go-to-tool ()
  (interactive)
  (let ((tool (chomp (sed "s/ #.*//" (fz (cat "$NOTES/ws/fuzzy/tools.txt"))))))
    (if tool
        (sps (concat "ff " (q tool))))))

(defun fuzzy-run-search-function (tool query)
  (interactive (let* ((tool (chomp (sed "s/ #.*//" (fz (cat "$NOTES/ws/fuzzy/search-functions.txt")))))
                      (toolslug (slugify tool))
                      (query (read-string-hist (concat toolslug " query: "))))
                 (list tool query)))
  (if (and tool query)
      (etv (cl-sn (concat tool " " (q query)) :chomp t))))


(provide 'my-fuzzy)