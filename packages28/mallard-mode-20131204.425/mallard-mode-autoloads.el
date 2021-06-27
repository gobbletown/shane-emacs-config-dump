;;; mallard-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "mallard-mode" "mallard-mode.el" (0 0 0 0))
;;; Generated autoloads from mallard-mode.el

(autoload 'mallard-mode "mallard-mode" "\
A major mode for editing Mallard files.

To start mallard-mode, either open a file with the `.page' or `.page.stub'
file extension, or run `M-x mallard-mode' to enable it for the current
buffer. Once enabled, mallard-mode loads the RELAX NG schema for Mallard,
sets appropriate indentation rules, and enables automatic line wrapping.

mallard-mode inherits commands and key bindings from `nxml-mode'.
In addition, it defines a number of commands and key bindings that integrate
it with the `yelp-check' utility in order to provide maximum comfort when
editing Mallard pages. These commands are as follows:

\\[mallard-comments] or `M-x mallard-comments' displays editorial comments.
\\[mallard-hrefs] or `M-x mallard-hrefs' displays broken external links.
\\[mallard-status] or `M-x mallard-status' displays the current status.
\\[mallard-validate] or `M-x mallard-validate' validates the current buffer.
`M-x mallard-version' displays the version of this major mode.

You can customize the behavior of some of these commands by running the
`M-x customize-mode' command.

\(fn)" t nil)

(add-to-list 'auto-mode-alist '("\\.page\\'" . mallard-mode))

(add-to-list 'auto-mode-alist '("\\.page\\.stub\\'" . mallard-mode))

(register-definition-prefixes "mallard-mode" '("mallard-"))

;;;***

;;;### (autoloads nil nil ("mallard-mode-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; mallard-mode-autoloads.el ends here
