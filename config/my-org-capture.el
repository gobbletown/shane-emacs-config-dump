;; -----

(defservlet* capture/:keys/:contents text/plain () (org-capture-string contents keys))

;; -----

(add-to-list 'org-capture-templates
             '("l" "Capture a link from clipboard" entry (file "~/Dropbox/org/notes.org")
               #'mkm-org-capture/link :empty-lines-after 2 :prepend))


(defun mkm-org-capture/link ()
    "Make a TODO entry with a link in clipboard. Page title is used as task heading."
    (let* ((url-string (s-trim (x-get-clipboard)))
         (pdf (string-suffix-p "pdf" url-string)))
    (unless pdf
      (let ((page-title (org-web-tools--html-title (org-web-tools--get-url url-string))))
        (concat "* TODO "
                page-title
                "\n\t:PROPERTIES:\n\t:URL: "
                url-string
                "\n\t:END:\n\n\s\s- %?")))))

(defun mkm-org/read-entry()
"Read a notes entry with webpage and TODO side-by-side"
(interactive)
(let*  ((url-prop (org-entry-properties (point) "URL")))
  (progn
    (if url-prop
        (let* ((url (cdr (assoc "URL" url-prop))))
          (if (string-match-p (regexp-quote "youtube.com") url)
              (browse-url url)
            (progn
              (org-narrow-to-subtree)
              (delete-other-windows)
              (split-window-right)
              (eww url))))))))

;; -----

(provide 'my-org-capture)