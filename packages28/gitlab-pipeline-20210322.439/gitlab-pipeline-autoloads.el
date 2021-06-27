;;; gitlab-pipeline-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "gitlab-pipeline" "gitlab-pipeline.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from gitlab-pipeline.el

(autoload 'gitlab-pipeline-show-sha "gitlab-pipeline" "\
Gitlab-pipeline-show-sha-at-point (support magit buffer)." t nil)

(autoload 'gitlab-pipeline-job-trace-at-point "gitlab-pipeline" "\
Gitlab pipeline job trace at point." t nil)

(autoload 'gitlab-pipeline-job-cancel-at-point "gitlab-pipeline" "\
Gitlab pipeline job cancel at point." t nil)

(register-definition-prefixes "gitlab-pipeline" '("gitlab-pipeline-host"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; gitlab-pipeline-autoloads.el ends here
