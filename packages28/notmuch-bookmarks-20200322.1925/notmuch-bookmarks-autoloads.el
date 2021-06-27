;;; notmuch-bookmarks-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "notmuch-bookmarks" "notmuch-bookmarks.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from notmuch-bookmarks.el

(autoload 'notmuch-bookmarks-edit-name "notmuch-bookmarks" "\
Edit the name of notmuch bookmark BOOKMARK.
If BOOKMARK is nil, use current buffer's bookmark.

\(fn &optional BOOKMARK)" t nil)

(autoload 'notmuch-bookmarks-edit-query "notmuch-bookmarks" "\
Edit the query of notmuch bookmark BOOKMARK.
If BOOKMARK is nil, use current buffer's bookmark.
If CALLED-INTERACTIVELY, visit the new bookmark after editing.

\(fn &optional BOOKMARK CALLED-INTERACTIVELY)" t nil)

(autoload 'notmuch-bookmarks-set-search-type "notmuch-bookmarks" "\
Set the search type (tree or search) of notmuch bookmark BOOKMARK.
If BOOKMARK is nil, use current buffer's bookmark.
If CALLED-INTERACTIVELY, visit the new bookmark after editing.

\(fn &optional BOOKMARK CALLED-INTERACTIVELY)" t nil)

(defvar notmuch-bookmarks-mode nil "\
Non-nil if Notmuch-Bookmarks mode is enabled.
See the `notmuch-bookmarks-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `notmuch-bookmarks-mode'.")

(custom-autoload 'notmuch-bookmarks-mode "notmuch-bookmarks" nil)

(autoload 'notmuch-bookmarks-mode "notmuch-bookmarks" "\
Add notmuch specific bookmarks to the bookmarking system.

If called interactively, enable Notmuch-Bookmarks mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "notmuch-bookmarks" '("notmuch-bookmarks-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; notmuch-bookmarks-autoloads.el ends here
