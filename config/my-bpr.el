(require 'bpr)

(provide 'my-bpr)

;; Set global config for bpr.
;; Variables below are applied to all processes.
(setq bpr-colorize-output t)
(setq bpr-close-after-success t)


;; define function for running desired process
(defun run-tests ()
  "Spawns 'grunt test' process"
  (interactive)
  ;; Set dynamic config for process.
  ;; Variables below are applied only to particular process
  (let* ((bpr-scroll-direction -1))
    (bpr-spawn "grunt test --color")))


(defun my/bpr/make ()
  "Spawns 'grunt test' process"
  (interactive)
  ;; Set dynamic config for process.
  ;; Variables below are applied only to particular process
  (let* ((bpr-scroll-direction -1))
    (bpr-spawn "make")))


(define-prefix-command 'my-prefix-m-dash)
(global-set-key (kbd "M--") 'my-prefix-m-dash)

;; Require appears to not work. Maybe I should use load
(require 'my-prefixes)