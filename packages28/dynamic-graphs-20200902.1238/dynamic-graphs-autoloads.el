;;; dynamic-graphs-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "dynamic-graphs" "dynamic-graphs.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from dynamic-graphs.el

(autoload 'dynamic-graphs-display-graph "dynamic-graphs" "\
Display graph image and put it dynamic-graphs-mode on.

This is a shortcut for `dynamic-graphs-rebuild-graph' with defaulting
parameters.

All parameters - BASE-FILE-NAME ROOT MAKE-GRAPH-FN and FILTERS - are
optional with sensible defaults.

\(fn &optional BASE-FILE-NAME ROOT MAKE-GRAPH-FN FILTERS)" nil nil)

(autoload 'dynamic-graphs-display-graph-buffer "dynamic-graphs" "\
Make a dynamic graph from a graphviz buffer.

There is no default ROOT
node by default, and `dynamic-graphs-filters' - either default value or a
buffer-local if set, are used as default FILTERS when called
interactively.

\(fn ROOT FILTERS)" t nil)

(register-definition-prefixes "dynamic-graphs" '("dynamic-graphs-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; dynamic-graphs-autoloads.el ends here
