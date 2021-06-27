(require 'markdown-mode)

(setq markdown-fontify-code-blocks-natively t)

(defun md-html-export-to-html ()
  (interactive)
  (md-org-export-to-org)
  (my-org-publish-current-file)
  ;;(let ((fn
  ;;       (my/new-filename-with-extension "html")))
  ;;  (org-html-export-to-html)
  ;;  (find-file fn))
  )

(defun my-md-publish-current-file ()
  (interactive)
  ;; Dont use this. I need to set up projects for this
  ;; (org-publish-current-file)

    (md-html-export-to-html)


  ;;(let ((htmlfn
  ;;        ;; this has to be case insensitive because of MD
  ;;       (replace-regexp-in-string "\\(.*\\)\\.\\(md\\|MD\\)" "\\1.html" (buffer-file-name))))


  ;;  ;; Need a shell script to touch a new file, including making the directories with mkdir -p
  ;;  ;; (replace-regexp-in-string "\\(.*\\)\\.org$" "\\1.html" (buffer-file-name))
  ;;  (set-visited-file-name htmlfn)
  ;;  ;; (save-current-buffer)
  ;;  (save-buffer)
  ;;  (kill-current-buffer)

  ;;  (bl ff-view htmlfn)
  ;;  (kill-window))
  ;;;; Open chrome to this html file
  )

(define-key markdown-mode-map (kbd "C-c M-p") #'my-md-publish-current-file)

(define-key markdown-mode-map (kbd "M-l") nil)
(define-key markdown-mode-map (kbd "M-k") nil)


(use-package markdown-mode
  :custom
  (markdown-hide-markup nil)
  (markdown-bold-underscore t)
  (markdown-italic-underscore t)
  (markdown-header-scaling t)
  (markdown-indent-function t)
  (markdown-enable-math t)
  (markdown-hide-urls nil)
  :custom-face
  ;; (markdown-header-delimiter-face ((t (:foreground "mediumpurple"))))
  ;; (markdown-header-face-1 ((t (:foreground "violet" :weight bold :height 1.0))))
  ;; (markdown-header-face-2 ((t (:foreground "lightslateblue" :weight bold :height 1.0))))
  ;; (markdown-header-face-3 ((t (:foreground "mediumpurple1" :weight bold :height 1.0))))
  ;; (markdown-link-face ((t (:background "#0e1014" :foreground "#bd93f9"))))
  ;; (markdown-list-face ((t (:foreground "mediumpurple"))))
  ;; (markdown-pre-face ((t (:foreground "#bd98fe"))))
  :mode "\\.md\\'")


(defun markdown-get-mode-here ()
  (interactive)
  (xc (sym2str (save-excursion (markdown-get-lang-mode (markdown-code-block-lang))))))

(defun markdown-get-lang-here ()
  (interactive)
  (xc (save-excursion (markdown-code-block-lang))))

(use-package markdown-toc)



;; Fix bug with too much recursion
(defun markdown-match-inline-generic (regex last &optional faceless recurdepth)
  "Match inline REGEX from the point to LAST.
When FACELESS is non-nil, do not return matches where faces have been applied."
  (if (not recurdepth) (setq recurdepth 0))
  (setq recurdepth (1+ recurdepth))
  (if (> 5 recurdepth)
      (when (re-search-forward regex last t)
        (let ((bounds (markdown-code-block-at-pos (match-beginning 1)))
              (face (and faceless (text-property-not-all
                                   (match-beginning 0) (match-end 0) 'face nil))))
          (cond
           ;; In code block: move past it and recursively search again
           (bounds
            (when (< (goto-char (cl-second bounds)) last)
              (markdown-match-inline-generic regex last faceless recurdepth)))
           ;; When faces are found in the match range, skip over the match and
           ;; recursively search again.
           (face
            (when (< (goto-char (match-end 0)) last)
              (markdown-match-inline-generic regex last faceless recurdepth)))
           ;; Keep match data and return t when in bounds.
           (t
            (<= (match-end 0) last)))))
    nil))


;; This allows you go navigate to fragments in the markdown
(defun markdown--browse-url-around-advice (proc url)
  (if (ire-match-p "^#" url)
      (let ((fragmentre (tr "-" "." (s-replace "#" "" url))))
        (next-line)
        (beginning-of-line)
        (re-search-forward fragmentre))
    (let ((res (apply proc (list url))))
      res)))
(advice-add 'markdown--browse-url :around #'markdown--browse-url-around-advice)

;; (defun md-glow ()
;;   (interactive)
;;   (if (and
;;        (major-mode-p 'markdown-mode)
;;        (f-file-p (get-path-nocreate)))
;;       (nw-term (concat "glow " (q (get-path-nocreate)) "; pak"))
;;     (message "not a markdown mode")))

(defun md-glow-vs ()
  (interactive)
  (if (and
       (major-mode-p 'markdown-mode)
       (f-file-p (get-path-nocreate)))
      (nw-term (concat "glow " (q (get-path-nocreate)) " | mnm | vs"))
    (message "not a markdown mode")))


(advice-add 'markdown-syntax-propertize :around #'ignore-errors-around-advice)

;; This must come at the end of the file
(markdown-update-header-faces nil '(1.0 1.0 1.0 1.0 1.0 1.0))

(provide 'my-markdown)