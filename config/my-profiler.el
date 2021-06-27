;; e:$HOME/local/emacs28/share/emacs/28.0.50/lisp/profiler.el.gz

(defun profiler-report-header-line-format (fmt &rest args)
  (let* ((header (apply #'profiler-format fmt args))
	 (escaped (replace-regexp-in-string "%" "%%" header)))
    escaped))

(cl-defun profiler-report-render-calltree-1
    (profile &key reverse (order 'descending))
  (let ((calltree (profiler-calltree-build
                   (profiler-profile-log profile)
                   :reverse reverse)))
    (setq header-line-format
	        (cl-ecase (profiler-profile-type profile)
	          (cpu
	           (profiler-report-header-line-format
	            profiler-report-cpu-line-format
	            "Function" (list "CPU (samples)" "%")))
	          (memory
	           (profiler-report-header-line-format
	            profiler-report-memory-line-format
	            "Function" (list "Memory (Bytes)" "%")))))
    ;; (setq header-line-format (propertize header-line-format 'face 'iedit-occurrence))
    (let ((predicate (cl-ecase order
		                   (ascending #'profiler-calltree-count<)
		                   (descending #'profiler-calltree-count>))))
      (profiler-calltree-sort calltree predicate))
    (let ((inhibit-read-only t))
      (erase-buffer)
      (profiler-report-insert-calltree-children calltree)
      (goto-char (point-min))
      (profiler-report-move-to-entry))))

;; (frame-width)
(defset profiler-report-cpu-line-format
  `((,(- (frame-width) 25) left)
    (24 right ((19 right)
               (5 right)))))

(defset profiler-report-memory-line-format
  `((,(- (frame-width) 25) left)
    (24 right ((19 right profiler-format-number)
	             (5 right)))))

(provide 'my-profiler)