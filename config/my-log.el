;; Remember:
;; profiler-start
;; profiler-stop
;; profiler-report


;; This is for ELK logs, etc.
(use-package logview :defer t)


;; This is for my own logging - profiling
(defmacro mylog (&rest body)
  ""
  (let ((s (concat "mylog: " (pps body))))
    `(progn
       (message "%s" ,s)
       ,@body)))


;; (si "tabulated-list-format column-size" (max 10 (min 30 (length e))))

(defun si (category input &rest args)
  ;; input may also be nil

  ;; (ignore-errors (shut-up (sn (concat "si +" category " " (cmdl args)) (str input))))
  (ignore-errors (snc (concat "si +" category " " (cmdl args)) (pps input)))
  input)

(defun uncmd (s)
  (str2lines (snc (concat "pl " s))))

(defun my-record (category-and-args-string &optional input)
  (let* ((l (uncmd category-and-args-string))
         (cat (car l) ))
    (si cat input (rest l))))

;; Stream logger. It records timestamps as they come in
;; This isn't properly hooked into emacs yet
;; (defalias 'my-record 'si)



;; TODO Make a function for logging all functions defined within a file



;; (defun mylog-around-advice (proc &rest args)
;;   (message (concat "mylog fun: " (str proc)))
;;   (message (concat "mylog args: " (str args)))
;;   (let ((res (apply proc args)))
;;     res))

(defset funs-to-trace '(glossary-list-relevant-glossaries
                        glossary-add-relevant-glossaries
                        generate-glossary-buttons-manually
                        generate-glossary-buttons-over-region
                        generate-glossary-buttons-over-buffer
                        make-buttons-for-glossary-terms))



;; This is useful, but unfortunately, it does not show in real-time
;; what functions are being run.
;; Perhaps I need a profiler.
(defun my-trace-trace-list ()
  (interactive)
  (cl-loop for f in funs-to-trace do
           (trace-function f)))
(defun my-untrace-trace-list ()
  (interactive)
  (cl-loop for f in funs-to-trace do
           (untrace-function f)))
(defvar my-trace-modeline-indicator " MT"
  "call (my-trace-install-mode) again if this is changed")
(defvar my-trace-mode nil)
;; (make-variable-buffer-local 'my-trace-mode)
;; (put 'my-trace-mode 'permanent-local t)
(defun my-trace-mode (&optional arg)
  ""
  (interactive "P")
  (setq my-trace-mode
        (if (null arg) (not my-trace-mode)
          (> (prefix-numeric-value arg) 0)))

  (if my-trace-mode
      (my-trace-trace-list)
    (my-untrace-trace-list))
  (force-mode-line-update))
(provide 'my-trace-mode)



(never
 (advice-add 'glossary-list-relevant-glossaries :around #'mylog-around-advice)
 (advice-add 'glossary-add-relevant-glossaries :around #'mylog-around-advice)
 (advice-add 'generate-glossary-buttons-manually :around #'mylog-around-advice)
 (advice-add 'generate-glossary-buttons-over-region :around #'mylog-around-advice)
 (advice-add 'generate-glossary-buttons-over-buffer :around #'mylog-around-advice)
 (advice-add 'make-buttons-for-glossary-terms :around #'mylog-around-advice)

 (advice-remove 'glossary-list-relevant-glossaries #'mylog-around-advice)
 (advice-remove 'glossary-add-relevant-glossaries #'mylog-around-advice)
 (advice-remove 'generate-glossary-buttons-manually #'mylog-around-advice)
 (advice-remove 'generate-glossary-buttons-over-region #'mylog-around-advice)
 (advice-remove 'generate-glossary-buttons-over-buffer #'mylog-around-advice)
 (advice-remove 'make-buttons-for-glossary-terms #'mylog-around-advice))

(provide 'my-log)