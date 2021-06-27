;;; diff-at-point-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "diff-at-point" "diff-at-point.el" (0 0 0 0))
;;; Generated autoloads from diff-at-point.el

(autoload 'diff-at-point-open-and-goto-hunk "diff-at-point" "\
Open a diff of the repository in the current frame.
Jumping to the file & line.

When SCROLL-RESET is not nil the view re-centers,
otherwise the offset from the window is kept.

\(fn &optional SCROLL-RESET)" t nil)

(autoload 'diff-at-point-goto-source-and-close "diff-at-point" "\
Go to the source and close the current diff buffer.

When SCROLL-RESET is not nil the view re-centers,
otherwise the offset from the window is kept.

\(fn &optional SCROLL-RESET)" t nil)

(register-definition-prefixes "diff-at-point" '("diff-at-point-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; diff-at-point-autoloads.el ends here
