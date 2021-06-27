(require 'my-context-functions)

(defun fz-syms (prompt collection)
  "This will show documentation because they are symbols"

  (if (stringp collection)
      (setq collection (str2lines collection)))

  (setq collection (mapcar 'str2sym collection))

  ;; I could use fz here too
  (completing-read prompt
                   collection nil t nil nil
                   ;; (when guess
                   ;;   (symbol-name guess))
                   ))

;; (defun major-mode-get-free-cc-bindings (&optional map)
;;   (interactive (list (current-major-mode-map)))

;;   ;; https://emacs.stackexchange.com/questions/964/show-unbound-keys

;;   (if (not map)
;;       (setq map (current-major-mode-map)))

;;   (let ((ms (show-map-as-string map)))
;;     (etv ms)))

(defun select-major-mode-function (&optional map)
  (if (not map)
      (setq map (current-major-mode-map)))

  (let ((ms (show-map-as-string map)))
    (if (sor ms)
        (let* ((funstr
                (fz-syms
                 "select-major-mode-function: "
                 (snc "sed -e '/^ /d' -e '/Prefix Command/d' -e '/^$/d' -e '/^--/d' -e '/^key/d' | rev | s field 1 | rev" ms))))
          (if (sor funstr)
              (let ((fun (str2sym funstr)))
                (if (commandp fun)
                    fun)))))))

(defun run-major-mode-function (&optional map)
  (interactive)

  ;; TODO Figure out how to

  ;; j:goto-function-from-binding
  ;; j:gnus-summary-mode

  (let ((fun (select-major-mode-function map)))
    (if (commandp fun)
        (call-interactively fun))))

(define-key global-map (kbd "M-z") 'run-major-mode-function)
(define-key my-mode-map (kbd "M-z") 'run-major-mode-function)


(defcustom custom-defined-keys nil
  "Custom defined keys"
  :type 'list
  :group 'my-major-mode
  :initialize #'custom-initialize-default)

;; (setq custom-defined-keys nil)

(defun custom-define-key (keymap key def)
  ;; (interactive (let* ((m (showmap--read-symbol "map: " (variable-name-re-p "-map$")))
  ;;                     (k (progn
  ;;                          (save-window-excursion
  ;;                            (save-selected-window
  ;;                              (free-keys "C-c"))
  ;;                            (let ((kp (read-key-sequence-vector "Key: ")))
  ;;                              (kill-buffer "*Free keys*")
  ;;                              kp))))
  ;;                     (d (select-major-mode-function m)))
  ;;                (list m k d)))
  (interactive (list nil nil nil))

  (if (not keymap)
      ;; (setq keymap (current-major-mode-map))
      (setq keymap (showmap--read-symbol "map: " (variable-name-re-p "-map$"))))

  ;; DONE
  ;; I should select a key differently
  ;; I should select from available keys somehow
  ;; From below C-c?
  ;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Key-Binding-Conventions.html
  ;; Sequences consisting of C-c followed by a control charater or a digit are reserved for major modes.
  ;; I have to bind C-c AND another control character
  ;; Suggest C-c C-<*> bindings
  ;; Fuzzy select from these

  ;; major-mode-get-free-cc-bindings

  (if (not key)
      (setq key
            (save-window-excursion
              (save-selected-window
                (free-keys "C-c"))
              (let ((kp (read-key-sequence-vector "Key: ")))
                (kill-buffer "*Free keys*")
                kp))))

  ;; (tv (str key))

  (if (not def)
      (setq def (select-major-mode-function keymap)))

  (let ((keystr (format "%s" (key-description key))))
    (if (not def)
        (setq def (eval `(lambda () (interactive)
                           (message ,(concat keystr " not defined"))
                           (edit-var-elisp 'custom-defined-keys)))))

    ;; If def is empty then create the scaffolding for the function?
    ;; Yes, I need this. Make an empty lambda and then edit the variable

    (let* ((wassym (symbolp def))
           (defquoted (if wassym
                          (eval `'',def)
                        def))
           (dk `(define-key ,(current-major-mode-map) (kbd ,keystr) ,defquoted)))
      (add-to-list 'custom-defined-keys dk)
      (eval dk)
      (custom-set-variables `(custom-defined-keys (quote ,custom-defined-keys)))
      (custom-save-all)
      (if (not wassym)
          (edit-var-elisp 'custom-defined-keys)))))

(define-key global-map (kbd "<help> j") 'custom-define-key)
(define-key my-mode-map (kbd "<help> j") 'custom-define-key)

(defun custom-keys-edit ()
  (interactive)
  (edit-var-elisp 'custom-defined-keys))

(defun custom-keys-goto (do-define-all-keys)
  (interactive "P")

  (if do-define-all-keys
      (dolist (e custom-defined-keys)
        ;; (message (pps e))
        (eval e))
    (j 'custom-keys-goto)))

(defun custom-keys-define-all (&optional goto-custom)
  (interactive "P")

  (if custom-defined-keys
      (dolist (e custom-defined-keys)
        (eval e))))

;; The bindings should be loaded when emacs is loaded
;; (ignore-errors
;;   (custom-keys-define-all))
;; This is where I must load it, because this is where custom.el is loaded
(add-hook-last 'window-setup-hook 'custom-keys-define-all)

(define-key global-map (kbd "<help> J") 'custom-keys-goto)
(define-key my-mode-map (kbd "<help> J") 'custom-keys-goto)

(defun custom-keys-undefine-all (&optional permanent)
  (interactive "P")

  (dolist (e (mapcar
              (lambda (ee)
                (append (-drop-last 1 ee) (list nil)))
              custom-defined-keys))
    (eval e))

  (if permanent
      (progn
        (setq custom-defined-keys nil)
        ;; (custom-set-variables `(custom-defined-keys (quote ,custom-defined-keys)))
        (custom-set-variables '(custom-defined-keys nil))
        (custom-save-all))))

(defun custom-keys-undefine-all-permanent ()
  (interactive)
  (custom-keys-undefine-all t))

(provide 'my-major-mode)
