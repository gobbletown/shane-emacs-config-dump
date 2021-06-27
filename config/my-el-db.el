;; This is taken from elfeed
;; e:$EMACSD/packages28/elfeed-20210309.2323/elfeed-db.el

;; This is a database for me to store elisp

(defset my-db-directory "~/.my-el-db")

(defvar my-db nil
  "The core database for my.")

(defvar my-db-version
  ;; If records are avaiable (Emacs 26), use the newer database format
  (if (functionp 'record)
      4
    "0.0.3")
  "The database version this version of my-db expects to use.")

(defun my-db-load ()
  "Load the database index from the filesystem."
  (let ((index (expand-file-name "index" my-db-directory))
        (enable-local-variables nil))   ; don't set local variables from index!
    (if (not (file-exists-p index))
        (setf my-db (my-db--empty))
      ;; Override the default value for major-mode. There is no
      ;; preventing find-file-noselect from starting the default major
      ;; mode while also having it handle buffer conversion. Some
      ;; major modes crash Emacs when enabled in large buffers (e.g.
      ;; org-mode). This includes the my index, so we must not let
      ;; this happen.
      (cl-letf (((default-value 'major-mode) 'fundamental-mode))
        (with-current-buffer (find-file-noselect index :nowarn)
          (goto-char (point-min))
          (setf my-db (read (current-buffer)))
          (kill-buffer))))
    ;; Perform an upgrade if necessary and possible
    ;; (unless (equal (plist-get my-db :version) my-db-version)
    ;;   (ignore-errors
    ;;     (copy-file index (concat index ".backup")))
    ;;   (message "Upgrading my index ...")
    ;;   ;; j:elfeed-db-upgrade
    ;;   (setf my-db (my-db-upgrade my-db))
    ;;   (message "my index upgrade complete."))
    (setf my-db-feeds (plist-get my-db :feeds)
          my-db-entries (plist-get my-db :entries)
          my-db-index (plist-get my-db :index)
          ;; Internal function use required for security!
          (avl-tree--cmpfun my-db-index) #'my-db-compare)))

(defun my-db-ensure ()
  "Ensure that the database has been loaded."
  (when (null my-db) (my-db-load)))

(defun my-db-save ()
  "Write the database index to the filesystem."
  (my-db-ensure)
  (setf my-db (plist-put my-db :version my-db-version))
  (mkdir my-db-directory t)
  (let ((coding-system-for-write 'utf-8))
    (with-temp-file (expand-file-name "index" my-db-directory)
      (let ((standard-output (current-buffer))
            (print-level nil)
            (print-length nil)
            (print-circle nil))
        (princ (format ";;; my Database Index (version %s)\n\n"
                       my-db-version))
        (when (eql my-db-version 4)
          ;; Put empty dummy index in front
          (princ ";; Dummy index for backwards compatablity:\n")
          (prin1 (my-db--dummy))
          (princ "\n\n;; Real index:\n"))
        (prin1 my-db)
        :success))))

(provide 'my-el-db)