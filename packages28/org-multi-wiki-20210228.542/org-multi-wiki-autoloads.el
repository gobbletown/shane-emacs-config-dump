;;; org-multi-wiki-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "org-multi-wiki" "org-multi-wiki.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from org-multi-wiki.el

(defvar org-multi-wiki-global-mode nil "\
Non-nil if Org-Multi-Wiki-Global mode is enabled.
See the `org-multi-wiki-global-mode' command
for a description of this minor mode.")

(custom-autoload 'org-multi-wiki-global-mode "org-multi-wiki" nil)

(autoload 'org-multi-wiki-global-mode "org-multi-wiki" "\
Toggle Org-Multi-Wiki-Global mode on or off.

If called interactively, enable Org-Multi-Wiki-Global mode if ARG
is positive, and disable it if ARG is zero or negative.  If
called from Lisp, also enable the mode if ARG is omitted or nil,
and toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\\{org-multi-wiki-global-mode-map}

\(fn &optional ARG)" t nil)

(autoload 'org-multi-wiki-add-namespaces "org-multi-wiki" "\
Add entries to `org-multi-wiki-namespace-list'.

This is a convenient function for adding an entry to the namespace list.

NAMESPACES should be a list of entries to add to the
variable. There won't be duplicate namespaces, and hooks for the
variable is run if necessary.

\(fn NAMESPACES)" nil nil)

(autoload 'org-multi-wiki-entry-file-p "org-multi-wiki" "\
Check if FILE is a wiki entry.

If the file is a wiki entry, this functions returns a plist.

If FILE is omitted, the current buffer is assumed.

\(fn &optional FILE)" nil nil)

(defsubst org-multi-wiki-recentf-file-p (filename) "\
Test if FILENAME matches the recentf exclude pattern.

This is not exactly the same as
`org-multi-wiki-entry-file-p'. This one tries to be faster by
using a precompiled regular expression, at the cost of accuracy." (when org-multi-wiki-recentf-regexp (string-match-p org-multi-wiki-recentf-regexp filename)))

(autoload 'org-multi-wiki-in-namespace-p "org-multi-wiki" "\
Check if a file/directory is in a particular namespace.

This checks if the directory is in/on a wiki NAMESPACE, which is
a symbol. If the directory is in/on the namespace, this function
returns non-nil.

By default, the directory is `default-directory', but you can
explicitly give it as DIR.

\(fn NAMESPACE &optional DIR)" nil nil)

(autoload 'org-multi-wiki-entry-files "org-multi-wiki" "\
Get a list of Org files in a namespace.

If NAMESPACE is omitted, the current namespace is used, as in
`org-multi-wiki-directory'.

If AS-BUFFERS is non-nil, this function returns a list of buffers
instead of file names.

\(fn &optional NAMESPACE &key AS-BUFFERS)" nil nil)

(autoload 'org-multi-wiki-follow-link "org-multi-wiki" "\
Follow a wiki LINK.

\(fn LINK)" nil nil)

(autoload 'org-multi-wiki-store-link "org-multi-wiki" "\
Store a link." nil nil)

(autoload 'org-multi-wiki-switch "org-multi-wiki" "\
Set the current wiki to NAMESPACE.

\(fn NAMESPACE)" t nil)

(autoload 'org-multi-wiki-visit-entry "org-multi-wiki" "\
Visit an entry of the heading.

HEADING in the root heading of an Org file to create or look
for. It looks for an existing entry in NAMESPACE or create a new
one if none. A file is determined based on
`org-multi-wiki-escape-file-name-fn', unless you explicitly
specify a FILENAME.

\(fn HEADING &key NAMESPACE FILENAME)" t nil)

(autoload 'org-multi-wiki-create-entry-from-subtree "org-multi-wiki" "\
Create a new entry from the current subtree.

This command creates a new entry in the selected NAMESPACE, from
an Org subtree outside of any wiki.

After successful operation, the original subtree is deleted from
the source file.

\(fn NAMESPACE)" t nil)

(register-definition-prefixes "org-multi-wiki" '("org-multi-wiki-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; org-multi-wiki-autoloads.el ends here
