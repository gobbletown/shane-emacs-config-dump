(require 'sql)

;; Like format but quotes string arguments
;; This would be nice. It would be easy to achieve in racket
;; (defmacro formatq (&rest body)
;;   "Do not return anything."
;;   ;; body
;;   `(progn (,@body) nil))

(defun sql-mode-get-port ()
  (let ((p sql-port))
    (if (eq p 0)
        (setq p (string-to-int (chomp (cut (scrape " [0-9]+" sql-buffer) :d " " :f 2)))))
    p))

(defun sql-mode-sps-tui ()
  (interactive)
  (if (major-mode-p 'sql-interactive-mode)
      (cond ((string-equal "mysql" sql-product)
             (sps (format "mycli -u %s --pass %s %s" (q sql-user) (q sql-password) (q sql-database))))
            ((string-equal "postgres" sql-product)
             ;; (sps (format "pgcli -u %s -W %s -d %s" (q sql-user) (q sql-password) (q sql-database)))
             (sps
              (format
               "pgcli -h %s -p %s -U %s -W -d %s; pak"
               (q sql-server)
               (q (sql-mode-get-port))
               (q sql-user)
               ;; (q sql-password)
               (q sql-database)))))
    (message "need to be in sql-mode")))

;; export PGPASSWORD=$POSTGRES_PASSWORD
;; - psql -h "postgres" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "SELECT 'OK' AS status;"
(defun sql-mode-sps-cli ()
  (interactive)
  (if (major-mode-p 'sql-interactive-mode)
      (cond ((string-equal "mysql" sql-product)
             ;; (zrepl (format "mysql --user=%s --password=%s %s" (q sql-user) (q sql-password) (q sql-database)))
             (zreplcm (format "mysql --user=%s --password=%s %s" (q sql-user) (q sql-password) (q sql-database))))
            ((string-equal "postgres" sql-product)
             (sps ;; (tv (format "psql -U %s -W %s -d %s" (q sql-user) (q sql-password) (q sql-database)))
              (format
               ;; "psql -U %s -W %s -d %s"
               "psql -h %s -p %s -U %s -W -d %s; pak"
               (q sql-server)
               (q (sql-mode-get-port))
               (q sql-user)
               ;; (q sql-password)
               (q sql-database)))))
    (message "need to be in sql-mode")))

(define-key sql-interactive-mode-map (kbd "M-i") 'sql-mode-sps-cli)
(define-key sql-interactive-mode-map (kbd "M-o") 'sql-mode-sps-tui)

(provide 'my-sql-mode)