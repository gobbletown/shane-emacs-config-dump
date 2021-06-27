(require 'pydoc)

;; This fixed pydoc-at-point
;; vim +/"\"# -\*- coding: utf-8 -\*-" "$MYGIT/config/emacs/config/my-pydoc.el"

(defun pydoc-at-point ()
  "Try to get help for thing at point.
Requires the python package jedi to be installed.

There is no way right now to get to the full module path. This is a known limitation in jedi."
  (interactive)
  (let* ((script (buffer-string))
	       (line (line-number-at-pos))
	       (column (current-column))
	       (tfile (make-temp-file "py-"))
	       (python-script
	        (format
	         "# -*- coding: utf-8 -*-
import jedi
s = jedi.Script(\"\"\"%s\"\"\", %s, %s, path=\"%s\")
gd = s.goto_definitions()

version = [int(x) for x in jedi.__version__.split('.')]

if len(gd) > 0:
    if version[1] == 11:
        script_modules = gd[0]._evaluator.modules
    else:
        script_modules = list(gd[0]._evaluator.module_cache.iterate_modules_with_names())

    if len(script_modules) > 0:
        if version[1] == 11:
            related = '\\n    '.join([smod for smod in script_modules if 'py-' not in smod])
        else:
            related = '\\n    '.join([smod[0] for smod in script_modules if 'py-' not in smod])
    else:
        related = None

    print('''Help on {0}:

NAME
    {3}

{4}

FILE
    {1}::{2}

OTHER MODULES IN THIS FILE
    {5}
'''.format(gd[0].full_name, gd[0].module_path, gd[0].line, gd[0].name, gd[0].docstring(), related))"
	         ;; I found I need to quote double quotes so they
	         ;; work in the script above.
	         (replace-regexp-in-string "\"" "\\\\\"" (replace-regexp-in-string "\\\\" "\\\\\\\\" script))
	         line
	         column
	         tfile)))

    (pydoc-setup-xref (list #'pydoc (thing-at-point 'word))
		                  (called-interactively-p 'interactive))

    (pydoc-with-help-window (pydoc-buffer)
      (with-temp-file tfile
	      (insert python-script))
      (call-process-shell-command (concat "python " tfile)
				                          nil standard-output)
      (delete-file tfile))))