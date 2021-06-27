(require 'tabulated-list)
(require 'tablist)
(require 'my-tablist)

;; list of tablist modes
;; 'buffer-menu
;; bluetooth-list-devices

(defset list-of-tlm
  '(buffer-menu
    bluetooth-list-devices))

(defun run-tlm (tlmcmd &optional pak)
  (interactive (list (fz list-of-tlm
                         nil nil "run-tlm: ")))
  (call-interactively (str2sym tlmcmd)))

(define-key global-map (kbd "H-F") 'run-tlm)

(defset my-tablist-modes-cmds-or-paths
  '(
    ;; "arp -a | spaces2tabs | tsv2csv"
    "arp"
    "prompts"
    "subnetscan"
    "ports"
    "aws-policies"
    "aws-users"
    "mygit")
  "A list of commands or csv paths to create tablist minor modes for")

(defset my-tablist-mode-tuples
  '(("list-venv-dirs-csv" . ("venv" t "30 40 20"))
    ("n-list-open-ports" . ("ports" t))
    ("mygit-tablist" . ("mygit" t))
    ("list-current-subnet-computers-details" . ("subnetscan" t))
    ("arp-details" . ("arp" t "20 20 20 20 20 20"))
    ("list-aws-iam-policies-csv" . ("aws-policies" t "30 80"))
    ("oci prompts-details -csv" . ("prompts" t "30 30 20 10 15 15 15 10"))
    ("upd list-aws-iam-users-csv" . ("aws-users" t "20 60 20"))))

(defset my-tablist-modes
  (cl-loop for cmd in my-tablist-modes-cmds-or-paths collect (eval `(defcmdmode ,cmd "tablist"))))

(defun my-start-tablist ()
  (interactive)
  (let* ((sh-update (>= (prefix-numeric-value current-global-prefix-arg) 16))
         (tlname (fz (mapcar 'car my-tablist-mode-tuples) nil nil "start tablist: "))
         (args
          (if (sor tlname)
              (assoc tlname my-tablist-mode-tuples)
            ;; (cdr (assoc tlname my-tablist-mode-tuples))
            )))
    (apply 'create-tablist args)))
(define-key my-mode-map (kbd "H-\\") 'my-start-tablist)


;; TODO Become good at building tablist modes
;; server-command-tuples



;; Define the modes independently of the detection mechanism
;; The detection mechanism should be an explicit selection of the mode on the command-line and perhaps an alist-pattern system

;; TODO Create a list of the modes when defining them so I can pattern match

;; TODO Find a way to query these tabulated lists using the keys
;; I need this in case I start generating new columns

(defun arp-tablist-get-ip ()
  (snc "rosie grep -o subs net.ipv4" (second (vector2list (tabulated-list-get-entry )))))

(defun arp-tablist-ping ()
  (interactive)
  (sps (concat "ping " (q (arp-tablist-get-ip)) " || pak")))

(defun arp-tablist-nmap-os-detect (&optional ip)
  (interactive)
  (setq ip (or ip (arp-tablist-get-ip)))
  (sps (concat "msudo nmap -O " (q ip) " 2>&1 | vs")))

(defun arp-tablist-nmap-ports (&optional ip)
  (interactive)
  (setq ip (or ip (arp-tablist-get-ip)))
  (sps (concat "nmap -sT " (q ip) " 2>&1 | vs")))

(defun arp-tablist-ssh ()
  (interactive)
  (sps (concat "zrepl ssh " (q (arp-tablist-get-ip)))))


(define-key arp-tablist-mode-map (kbd "p") 'arp-tablist-ping)
(define-key arp-tablist-mode-map (kbd "s") 'arp-tablist-ssh)
(define-key arp-tablist-mode-map (kbd "N") 'arp-tablist-nmap-ports)
(define-key arp-tablist-mode-map (kbd "O") 'arp-tablist-nmap-os-detect)


(defun mygit-tablist-get-url ()
  (snc "xurls" (str (vector2list (tabulated-list-get-entry )))))

(defun mygit-tablist-gc ()
  (interactive)
  ;; (sps (concat "zrepl gc " (q (mygit-tablist-get-url))))
  (gc (mygit-tablist-get-url)))

(define-key mygit-tablist-mode-map (kbd "RET") 'mygit-tablist-gc)


(defun prompts-tablist-get-fp ()
  (umn (concat "$PROMPTS/" (str (car (vector2list (tabulated-list-get-entry)))))))

(defun prompts-tablist-o ()
  (interactive)
  (e (prompts-tablist-get-fp)))

(define-key prompts-tablist-mode-map (kbd "RET") 'prompts-tablist-o)

(defun aws-remove-user-policy (id)
  (interactive (list (tabulated-list-get-id)))

  )

(defun aws-create-user (name)
  (interactive (list (read-string-hist "New user name: ")))
  (snc (concat "aws iam create-user --user-name " name))
  (if (major-mode-p 'tabulated-list-mode)
      (revert-buffer)))

(defun aws-delete-user (name)
  (interactive (list (or (sor (str (tabulated-list-get-id)))
                         (read-string-hist "Delete user name: "))))
  (if (yn (concat "Delete " name "?"))
      (progn
        (snc (concat "aws iam delete-user --user-name " name))
        (if (major-mode-p 'tabulated-list-mode)
            (revert-buffer)))))

(defun aws-add-policy-to-user (name)
  (interactive (list (or (sor (str (tabulated-list-get-id)))
                         (read-string-hist "Add policy to user: "))))
  (let ((policy (fz (snc "list-aws-iam-policies-csv | sed 1d | cut -d , -f 2 | uq -l"))))
    (snc (concat "oci aws iam attach-user-policy --user-name " name " --policy-arn \"" policy "\""))
    (if (major-mode-p 'tabulated-list-mode)
        (revert-buffer))))

(defun aws-remove-policy-from-user (name)
  (interactive (list (or (sor (str (tabulated-list-get-id)))
                         (read-string-hist "Remove policy from user: "))))
  (let ((policy (fz (snc "list-aws-iam-policies-csv | sed 1d | cut -d , -f 2 | uq -l"))))
    (snc (concat "oci aws iam detach-user-policy --user-name " name " --policy-arn \"" policy "\""))
    (if (major-mode-p 'tabulated-list-mode)
        (revert-buffer))))

(define-key aws-users-tablist-mode-map (kbd "d") 'aws-delete-user)
(define-key aws-users-tablist-mode-map (kbd "c") 'aws-create-user)
(define-key aws-users-tablist-mode-map (kbd "a") 'aws-add-policy-to-user)
(define-key aws-users-tablist-mode-map (kbd "r") 'aws-remove-policy-from-user)

(defun server-suggest-subnet-scan (hn)
  (interactive (list tablist-selected-id))
  (if tablist-selected-id
      (server-suggest tablist-selected-id)))

(define-key subnetscan-tablist-mode-map (kbd "'") 'server-suggest-subnet-scan)


(defun kill-port (port)
  (interactive (read-string "kill-port: "))
  (snc (cmd "kill-port" (str port))))


(defun ports-tablist-kill-port (&optional port)

  )

(define-key ports-tablist-mode-map (kbd "k") 'arp-tablist-nmap-ports)



(provide 'my-tablist-modes)