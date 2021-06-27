;;; seml-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "seml-mode" "seml-mode.el" (0 0 0 0))
;;; Generated autoloads from seml-mode.el

(autoload 'seml-to-string "seml-mode" "\
Return formated string from seml SEXP.

\(fn SEXP)" nil nil)

(autoload 'seml-pp "seml-mode" "\
Output pretty-printed representation of seml SEXP.
Output to STREAM, or value of `standard-output'
When RETURN-P is non-nil, return `pp' string.

This function is seml version of `pp'.

\(fn SEXP &optional STREAM RETURN-P)" nil nil)

(autoload 'seml-xpath "seml-mode" "\
Get element at XPATH like specification from seml SEXP.
When WITHOUT-TOP is nonnil, return SEML sexp without top tag.
XPATH is now supported below forms
- '(top html body pre)

\(fn XPATH SEXP &optional WITHOUT-TOP)" nil nil)

(function-put 'seml-xpath 'lisp-indent-function '1)

(autoload 'seml-xpath-single "seml-mode" "\
Get one element at XPATH like specifiction from seml SEXP.
Supported XPATH more information, see `seml-xpath'.

When WITHOUT-TOP is non-nil, remove root tag.

\(fn XPATH SEXP &optional WITHOUT-TOP)" nil nil)

(function-put 'seml-xpath-single 'lisp-indent-function '1)

(autoload 'seml-xpath-without-top "seml-mode" "\
Call `seml-xpath' with without-top option (and call with XPATH SEXP).

\(fn XPATH SEXP)" nil nil)

(function-put 'seml-xpath-without-top 'lisp-indent-function '1)

(autoload 'seml-xpath-single-without-top "seml-mode" "\
Call `seml-xpath-single' with without-top option (and call with XPATH SEXP).

\(fn XPATH SEXP)" nil nil)

(function-put 'seml-xpath-single-without-top 'lisp-indent-function '1)

(autoload 'seml-htmlize "seml-mode" "\
Return seml sexp formated CODESTR by Emacs fontlock on MAJORMODE.
optional:
  - NOINDENTP is non-nil, do not indent the entire buffer.
  - FORMATFN is function, executed before indent.

\(fn MAJORMODE CODESTR &optional NOINDENTP FORMATFN)" nil nil)

(autoload 'seml-import "seml-mode" "\
Import external seml file at `seml-import-dir'/PATH.

\(fn PATH)" nil nil)

(autoload 'seml-expand-url "seml-mode" "\
Return expanded url base at BASEURL to PATH.

\(fn PATH BASEURL)" nil nil)

(autoload 'seml-encode-region-from-html "seml-mode" "\
Return SEML sexp encoded from region from START to END.

\(fn START END)" t nil)

(autoload 'seml-encode-string-from-html "seml-mode" "\
Return SEML sexp encoded from HTML STR.

\(fn STR)" nil nil)

(autoload 'seml-encode-buffer-from-html "seml-mode" "\
Return SEML sexp encoded from HTML BUF.
If omit BUF, use `current-buffer'.

\(fn &optional BUF)" nil nil)

(autoload 'seml-encode-file-from-html "seml-mode" "\
Return SEML sexp encoded from html file located in FILEPATH.

\(fn FILEPATH)" nil nil)

(autoload 'seml-encode-region-from-seml "seml-mode" "\
Return HTML string from buffer region at START to END.
If gives DOCTYPE, concat DOCTYPE at head.

\(fn START END &optional DOCTYPE)" nil nil)

(autoload 'seml-encode-sexp-from-seml "seml-mode" "\
Return HTML decoded from seml SEXP.
If gives DOCTYPE, concat DOCTYPE at head.

\(fn SEXP &optional DOCTYPE)" nil nil)

(autoload 'seml-encode-string-from-seml "seml-mode" "\
Return HTML string decode from seml STR.
If gives DOCTYPE, concat DOCTYPE at head.

\(fn STR &optional DOCTYPE)" nil nil)

(autoload 'seml-encode-buffer-from-seml "seml-mode" "\
Return HTML string decode from BUF.
If gives DOCTYPE, concat DOCTYPE at head.

\(fn &optional BUF DOCTYPE)" nil nil)

(autoload 'seml-encode-file-from-seml "seml-mode" "\
Return HTML string decoded from seml file located in FILEPATH.
If gives DOCTYPE, concat DOCTYPE at head.

\(fn FILEPATH &optional DOCTYPE)" nil nil)

(autoload 'seml-replace-region-from-html "seml-mode" "\
Replace buffer string HTML to SEML in BEG to END..

\(fn BEG END)" t nil)

(autoload 'seml-replace-region-from-seml "seml-mode" "\
Replace buffer string SEML to HTML in BEG to END.

\(fn BEG END)" t nil)

(autoload 'seml-mode "seml-mode" "\
Major mode for editing SEML (S-Expression Markup Language) file.

\(fn)" t nil)

(add-to-list 'auto-mode-alist '("\\.seml\\'" . seml-mode))

(add-to-list 'interpreter-mode-alist '("seml" . seml-mode))

(register-definition-prefixes "seml-mode" '("seml-" "with-seml-elisp"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; seml-mode-autoloads.el ends here
