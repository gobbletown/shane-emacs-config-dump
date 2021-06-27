(require 'gitlab)
(require 'gitlab-pipeline)

(require 'my-myrc)

;; FMG
(setq gitlab-host "https://gitlab.com"
      gitlab-token-id (myrc-get "gitlab_fmg_token"))

;; This doesn't work. Consider remaking this
(defun gitlab-get-job-coverage (repo job-id)
  (let* ((dir (format "%s/coverage/%s/job-%s" (expand-file-name "~") (oref repo :name) job-id))
         (zip (format "%s/artifacts.zip" dir)))
    (delete-directory dir t t)
    (make-directory dir t)
    (gitlab-download (format "projects/%d/jobs/%d/artifacts" (oref repo :gitlab-id) job-id)
                     (write-region (point) (point-max) zip))
    (call-process "/usr/bin/unzip" nil nil nil zip "-d" dir)
    (browse-url-generic (format "file://%s/coverage/index.html" dir))))


;; gitlab-download is a macro that sends an HTTP
;; request to my local Gitlab instance, including
;; my private token in a Private-Token header;
;; its body is executed in a temporary buffer
;; with point intially positioned at the start of
;; the response body.

(require 'gitlab-ci-mode)

(setq gitlab-ci-url "https://gitlab.com")
(setq gitlab-ci-api-token (myrc-get "gitlab_fmg_token"))

(provide 'my-gitlab)