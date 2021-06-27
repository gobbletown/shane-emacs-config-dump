(never
 (require 'tls)

 ;; This is very old, before gnutls
 (require 'starttls)

 ;; By default, Emacs 26 directly uses the GnuTLS library, so
 ;; the gnutls-cli command won't be executed.

 (require 'gnutls)
 ;; (add-to-list 'gnutls-trustfiles "/usr/local/etc/openssl/cert.pem")

 (setq tls-program
       ;; Defaults:
       ;; '("gnutls-cli --insecure -p %p %h"
       ;;   "gnutls-cli --insecure -p %p %h --protocols ssl3"
       ;;   "openssl s_client -connect %h:%p -no_ssl2 -ign_eof")
       '("gnutls-cli -p %p %h"
         "openssl s_client -connect %h:%p -no_ssl2 -no_ssl3 -ign_eof"))

 (setq tls-program
       '("gnutls-cli --insecure --x509cafile %t -p %p %h" "gnutls-cli --x509cafile %t -p %p %h --protocols ssl3"))

 (setq tls-program
       '("gnutls-cli --x509cafile %t -p %p %h" "gnutls-cli --x509cafile %t -p %p %h --protocols ssl3")))

;; Emacs these days uses a builtin
;; I'm not sure how to enable usage of the external gnutls-cli tool

;; cd "$HOME/local/emacs28/share/emacs/28.0.50/lisp"; ead -i -z "continue connecting"

;; This makes it so mitmproxy doesn't impede emacs from using https
(defun nsm-query-user (message status)
  (let ((buffer (get-buffer-create "*Network Security Manager*"))
        (cert-buffer (get-buffer-create "*Certificate Details*"))
        (certs (plist-get status :certificates))
        (accept-choices
         '((?a "always" "Accept this certificate this session and for all future sessions.")
           (?s "session only" "Accept this certificate this session only.")
           (?n "no" "Refuse to use this certificate, and close the connection.")
           (?d "details" "See certificate details")))
        (details-choices
         '((?b "backward page" "See previous page")
           (?f "forward page" "See next page")
           (?n "next" "Next certificate")
           (?p "previous" "Previous certificate")
           (?q "quit" "Quit details view")))
        (done nil))
    (save-window-excursion
      ;; First format the certificate and warnings.
      (pop-to-buffer buffer)
      (erase-buffer)
      (let ((inhibit-read-only t))
        (when status
          (insert (nsm-format-certificate status)))
        (insert message)
        (goto-char (point-min))
        ;; Fill the first line of the message, which usually
        ;; contains lots of explanatory text.
        (fill-region (point) (line-end-position))
        ;; If the window is too small, add navigation options.
        (when (> (line-number-at-pos (point-max)) (window-height))
          (setq accept-choices
                (append accept-choices
                        '((?b "backward page" "See previous page")
                          (?f "forward page" "See next page"))))))
      ;; Then ask the user what to do about it.
      (unwind-protect
          (let* ((pems (cl-loop for cert in certs
                                collect (gnutls-format-certificate
                                         (plist-get cert :pem))))
                 (cert-index 0)
                 show-details answer buf)
            (while (not done)
              (setq answer
                    '(?a "always" "Accept this certificate this session and for all future sessions.")
                    ;; (if show-details
                    ;;     (read-multiple-choice "Viewing certificate:"
                    ;;                           details-choices)
                    ;;   (read-multiple-choice "Continue connecting?"
                    ;;                         accept-choices))
                    )
              (setq buf (if show-details cert-buffer buffer))

              (cl-case (car answer)
                (?q
                 ;; Exit the details window.
                 (set-window-buffer (get-buffer-window cert-buffer) buffer)
                 (setq show-details nil))

                (?d
                 ;; Enter the details window.
                 (set-window-buffer (get-buffer-window buffer) cert-buffer)
                 (with-current-buffer cert-buffer
                   (read-only-mode -1)
                   (insert (nth cert-index pems))
                   (goto-char (point-min))
                   (read-only-mode))
                 (setq show-details t))

                (?b
                 ;; Scroll down.
                 (with-selected-window (get-buffer-window buf)
                   (with-current-buffer buf
                     (ignore-errors (scroll-down)))))

                (?f
                 ;; Scroll up.
                 (with-selected-window (get-buffer-window buf)
                   (with-current-buffer buf
                     (ignore-errors (scroll-up)))))

                (?n
                 ;; "No" or "next certificate".
                 (if show-details
                     (with-current-buffer cert-buffer
                       (read-only-mode -1)
                       (erase-buffer)
                       (setq cert-index (mod (1+ cert-index) (length pems)))
                       (insert (nth cert-index pems))
                       (goto-char (point-min))
                       (read-only-mode))
                   (setq done t)))

                (?a
                 ;; "Always"
                 (setq done t))

                (?s
                 ;; "Session only"
                 (setq done t))

                (?p
                 ;; Previous certificate.
                 (with-current-buffer cert-buffer
                   (read-only-mode -1)
                   (erase-buffer)
                   (setq cert-index (mod (1- cert-index) (length pems)))
                   (insert (nth cert-index pems))
                   (goto-char (point-min))
                   (read-only-mode)))))
            ;; Return the answer.
            (cadr answer))
        (kill-buffer cert-buffer)
        (kill-buffer buffer)))))

(provide 'my-tls)