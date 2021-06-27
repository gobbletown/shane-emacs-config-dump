;;(my/with 'ycmd

(require 'company)
(require 'company-ycmd)
(require 'ycmd)

;; YCM is using company. Company settings, however, belong in the
;; company config file my-company.el.

;; (setq ycmd-server-command '("python" "/home/shane/versioned/git/config/vim/bundles/YouCompleteMe/third_party/ycmd/ycmd"))

;; (setq ycmd-force-semantic-completion t)
;; Semantic completion can also be forced by setting force_semantic: true in the JSON data for the completion request, but you should only do this if the user explicitly requested semantic completion with a keyboard shortcut; otherwise, leave it up to ycmd to decide when to use which engine.

;; The reason why semantic completion isn't always used even when available is because the semantic engines can be slow and because most of the time, the user doesn't actually need semantic completion.

;; Global YCM is probably a bad idea -- But I don't know
;; (add-hook 'after-init-hook #'global-ycmd-mode)

(set-variable 'ycmd-python-binary-path "/usr/bin/python3")
;; (set-variable 'ycmd-python-binary-path "/home/shane/scripts/conda-python")
(setq ycmd-server-command '("python" "/usr/bin/ycmd"))
(set-variable 'ycmd-server-command '("python3" "/usr/bin/ycmd"))
(setq ycmd-server-command (list "/home/shane/scripts/ycmd"))

                                        ; spacemacs will set this for me. I need to find an example file
                                        ;(set-variable 'ycmd-global-config "/home/noxdafox/.emacs.d/ycmd_global_config.py")


;; Debug this
(defun ycmd--create-options-file (hmac-secret)
  "Create a new options file for a ycmd server with HMAC-SECRET.

This creates a new tempfile and fills it with options.  Returns
the name of the newly created file."
  (let ((options-file (make-temp-file "ycmd-options"))
        (options (ycmd--options-contents hmac-secret)))
    (with-temp-file options-file
      (insert (ycmd--json-encode options)))
    options-file))

(company-ycmd-setup)

;;(set 'ycmd-startup-timeout 3)
(set 'ycmd-startup-timeout 10)

(provide 'my-ycm)