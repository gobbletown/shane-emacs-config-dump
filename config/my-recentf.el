(require 'recentf)
(require 'my-utils)
(provide 'my-recentf)

;; Find files faster with the recent files package -- https://www.masteringemacs.org/article/find-files-faster-recent-files-package

;; Every 5 mins, do this silently!
(timer 300 (df quiet-recentf-save-list (my/shut-up (recentf-save-list))))
;; (cl-timer :s 300 :c 'recentf-save-list)


(setq helm-recentf-fuzzy-match nil)


;; get rid of `find-file-read-only' and replace it with something
;; more useful.

;; vim +/"'helm-recentf)" (concat emacsdir "/spacemacs-extra-config.el"

;; enable recent files mode.
(recentf-mode t)

;; 50 files ought to be enough.
(setq recentf-max-saved-items 50)

(defun ido-recentf-open ()
  "use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "find recent file: " recentf-list))
      (message "opening file...")
    (message "aborting")))

;; (global-set-key (kbd "C-x C-r") 'ido-recentf-open)