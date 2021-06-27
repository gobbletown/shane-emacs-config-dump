;;; comment-tags-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "comment-tags" "comment-tags.el" (0 0 0 0))
;;; Generated autoloads from comment-tags.el

(autoload 'comment-tags-list-tags-buffer "comment-tags" "\
List all tags in the current buffer." t nil)

(autoload 'comment-tags-find-tags-buffer "comment-tags" "\
Complete tags in the current buffer and jump to line." t nil)

(autoload 'comment-tags-list-tags-buffers "comment-tags" "\
List tags for all open buffers." t nil)

(autoload 'comment-tags-next-tag "comment-tags" "\
Jump to next comment-tag from point." t nil)

(autoload 'comment-tags-previous-tag "comment-tags" "\
Jump to previous comment-tag from point." t nil)

(autoload 'comment-tags-mode "comment-tags" "\
Highlight and navigate comment tags.

If called interactively, enable Comment-Tags mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "comment-tags" '("comment-tags-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; comment-tags-autoloads.el ends here
