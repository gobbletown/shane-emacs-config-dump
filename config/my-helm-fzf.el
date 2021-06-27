(require 'helm-fzf)

;; Show dotfiles
;; export FZF_DEFAULT_COMMAND="find -L"
;; ag --hidden --ignore .git -f -g ""

;; TODO Implement maxdepth, I will need to learn how to configure helm in more detail
;; $MYGIT/jkitchin/jkitchin.github.com/org/2015/02/03/helm-and-prefix-functions.org
(defun helm-fzf-d2 (directory &optional init)
  (interactive "D")
  (let ((default-directory directory))
    (helm :sources '(helm-fzf-source-d2)

          :buffer "*helm-fzf*"
          :input init)))

(defun helm-fzf (directory &optional init)
  (interactive "D")
  (let ((default-directory directory))
    (helm :sources '(helm-fzf-source)

          :buffer "*helm-fzf*"
          :input init)))

(defun helm-fzf--do-candidate-process-d2 ()
  (let* ((cmd-args (-filter 'identity (list helm-fzf-executable-d2
                                            "--tac"
                                            "--no-sort"
                                            "-f"
                                            helm-pattern)))
         (proc (apply 'start-file-process "helm-fzf" helm-buffer cmd-args)))
    (prog1 proc
      (set-process-sentinel
       (get-buffer-process helm-buffer)
       #'(lambda (process event)
         (helm-process-deferred-sentinel-hook
          process event (helm-default-directory)))))))

(defset helm-fzf-source-d2
  (helm-build-async-source "fzf"
    :candidates-process 'helm-fzf--do-candidate-process-d2
    :filter-one-by-one 'identity
    ;; Don't let there be a minimum. it's annoying
    :requires-pattern 0
    :action 'helm-find-file-or-marked
    :candidate-number-limit 9999))

;; TODO Make it so 2 prefixes M-u M-u will give it a maxdepth of 2
(defun my-helm-fzf (&optional top depth)
  (interactive)
  (let ((dir (if (or top (equalp current-prefix-arg '(4)))
                 (vc-get-top-level)
               (my/pwd))))
    (if (equalp current-prefix-arg '(16))
        (progn
          (helm-fzf-d2 dir
                       (if (selectionp)
                           (concat "'" (selection)))
                       ;; (concat "'" (default-search-string))
                       ))
      (helm-fzf dir
                (if (selectionp)
                    (concat "'" (selection)))
                ;; (concat "'" (default-search-string))
                ))))

(defun my-helm-fzf-top ()
  (interactive)
  (my-helm-fzf t))

;; (setq helm-fzf-executable (sh-notty "alt -q fzf"))
(setq helm-fzf-executable "helm-fzf.sh")
(setq helm-fzf-executable-d2 "helm-fzf-d2.sh")

;; (setq helm-fzf-executable (sh-notty "/home/shane/scripts/fzf"))

(provide 'my-helm-fzf)