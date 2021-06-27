(defun ssh-agency-private-key-p (keyfile)
  "Return non-nil if KEYFILE designates a private key."
  (if (f-file-p keyfile)
      (with-temp-buffer
        (insert-file-contents-literally keyfile)
        (goto-char 1)
        (looking-at-p "\\`.*BEGIN.*PRIVATE KEY.*$"))))

(defun ssh-list-keys ()
  (--filter (and (string-match-p "/[^.]+$" it) (ssh-agency-private-key-p it))
            (append (file-expand-wildcards (expand-file-name "~/.ssh/id*"))
                    (file-expand-wildcards (expand-file-name "~/.ssh/ids/*")))))

(defcustom ssh-agency-keys
  (ssh-list-keys)
  "A list of key files to be added to the agent.

`nil' indicates the default for `ssh-add' which is ~/.ssh/id_rsa,
~/.ssh/id_dsa, ~/.ssh/id_ecdsa, ~/.ssh/id_ed25519 and
~/.ssh/identity."
  :group 'ssh-agency
  :type '(choice (repeat (file :must-match t))
                 (const nil :tag "ssh-add's default")))
(setq ssh-agency-keys (ssh-list-keys))

;; ssh-agency, internally, uses its version of the =ssh-agency-private-key-p= function, which is broken
;; But we still have our version
(require 'ssh-agency)

(provide 'my-ssh)