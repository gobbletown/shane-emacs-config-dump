(require 'my-myrc)

(defset toggle-scripts (glob "toggle-*" "$SCRIPTS"))

(defset toggle-myrc-keys (str2lines (cl-sn "cat $NOTES/myrc.yaml | sed -n \"/^[a-z].*: \\(on\\|off\\)$/p\" | cut -d : -f1" :chomp t)))

;; Lambda for inverting a predicate
(defmacro lmv (pred)
  `(lambda (v) (not (,pred v))))

;; This is the only one it seems
(defun toggle-my-test ()
  t)

;; I should probably differentiate between interactive (commands) and non-interactive toogle-functions
;; There are non-currently, it seems
;; TODO Fix apropos-function
;; (defset toggle-functions nil)
(defset toggle-functions (-filter (lmv commandp) (my-apropos-function "^toggle-.*")))
(defset toggle-commands ;; (-filter 'commandp (my-apropos-function "^toggle-.*"))
  '(toggle-draw-glossary-buttons-timer

    ;; TODO Make toggle commands use the toggle-text-contrast style -- 0 for query
    ;; toggle-text-contrast
    ))
(defset toggle-modes '(selectrum-mode
                       my-trace-mode
                       ;; visual-line-mode
                       ))
(defset toggle-values '(openwith-confirm-invocation
                        ;; my-disable-lsp
                        ;; my-do-cider-auto-jack-in
                        my-url-cache-enabled
                        my-url-cache-update
                        ;; flyspell-flycheck-enabled
                        glossary-keep-tuples-up-to-date
                        eww-use-chrome
                        eww-racket-doc-only-www
                        eww-use-rdrview
                        eww-use-tor
                        eww-do-fontify-pre
                        eww-update-ci
                        sh-update
                        ;; eww-no-external-handler
                        ))


(defun toggle-script-current-status (script)
  (toggle-script script))

(defun toggle-myrc-current-status (key)
  (toggle-myrc key nil t))


(defun fz-toggle ()
  (interactive)
  (let* ((sel
          (fz
           (append
            (mapcar (lambda (script) (concat "script " script " " (str (toggle-script-current-status script)))) toggle-scripts)
            (mapcar (lambda (key) (concat "myrc " key " " (str (toggle-myrc-current-status key)))) toggle-myrc-keys)
            ;; (mapcar (lambda (func) (concat "func " (sym2str func))) toggle-functions)
            (mapcar (lambda (c) (concat "cmd " (sym2str c))) toggle-commands)
            (mapcar (lambda (sym) (concat "var " (sym2str sym))) toggle-values)
            (mapcar (lambda (mode) (concat "mode " (sym2str mode))) toggle-modes))))
         (spl (s-split " " sel))
         (type (car spl))
         (name (nth 1 spl)))
    ;; (never
    ;;  (cond
    ;;   ((string-match-p "myrc: " type)
    ;;    (toggle-myrc r nil t))))
    ))


;; TODO Create rc toggles for these
;; (str2lines (cl-sn "cat $NOTES/myrc.yaml | sed -n \"/^[a-z].*: \\(on\\|off\\)$/p\" | cut -d : -f1" :chomp t))

;; newvalue is "0" or "1" or nil
(defun toggle-script (script &optional newvalue detach)
  (interactive (list (fz (glob "toggle-*" "$SCRIPTS") nil nil "toggle script: ")))
  (if script
      (let* ((status (cl-sn
                      (if newvalue
                          (concat script " " newvalue)
                        script)
                      :detach detach :chomp t :b_output-return-code t)))
        (if (interactive-p)
            (cond ((string-equal status "1")
                   (cl-sn (concat script " 1") :chomp t :detach t)
                   (message (concat script " on")))
                  ((string-equal status "0")
                   (cl-sn (concat script " 0") :chomp t :detach t)
                   (message (concat script " off")))
                  ;; toggle it
                  ;; ((string-equal status "2")
                  ;;  (cl-sn (concat script " 0") :chomp t)
                  ;;  (message (concat script " off")))
                  )
          (equalp status "0")))))

;; TODO 
(defun toggle-buttoncloud ()
  (interactive)

  ;; Put into lines, then sort lines
  (with-output-to-temp-buffer "*button cloud*"
    (with-current-buffer "*button cloud*"
      (setq-local imenu-create-index-function #'button-cloud-create-imenu-index)
      (cl-loop for c in toggle-modes do
               (insert-button (concat (pcre-replace-string "^toggle-" "" (sym2str c)) "(m)")
                              'type
                              (if (eval c)
                                  'on-button
                                'off-button)
                              'action
                              (eval
                               `(lambda (b)
                                  (if (eval ,c)
                                      (,c -1)
                                    (,c 1))
                                  ;; (call-interactively ',c)
                                  (if (eval ,c)
                                      (button-put b 'type 'on-button)
                                    (button-put b 'type 'off-button)))))
               (insert "\n"))

      (cl-loop for c in toggle-commands do
               (insert-button (concat (pcre-replace-string "^toggle-" "" (sym2str c)) "(c)")
                              'type
                              (if (funcall c)
                                  'on-button
                                'off-button)
                              'action
                              (eval
                               `(lambda (b)
                                  (call-interactively ',c)
                                  (if (,c)
                                      (button-put b 'type 'on-button)
                                    (button-put b 'type 'off-button)))))
               (insert "\n"))

      (cl-loop for v in toggle-values do
               (insert-button (concat (sym2str v) "(v)")
                              'type
                              (if (eval v)
                                  'on-button
                                'off-button)
                              'action
                              (eval
                               `(lambda (b)
                                  (kill-local-variable ,v)
                                  (setq ,v (not ,v))
                                  (if ,v
                                      (button-put b 'type 'on-button)
                                    (button-put b 'type 'off-button)))))
               (insert "\n"))

      (cl-loop for s in toggle-scripts do
               (insert-button (concat s "(s)")
                              'type
                              (if (toggle-script s)
                                  'on-button
                                'off-button)
                              'action
                              (eval
                               `(lambda (b)
                                  (let* ((currentstatus (toggle-script ,s))
                                         (status (toggle-script ,s (if currentstatus
                                                                       "0"
                                                                     "1"))))
                                    (if status
                                        (button-put b 'type 'on-button)
                                      (button-put b 'type 'off-button))))))
               (insert "\n"))

      (cl-loop for r in toggle-myrc-keys do
               (insert-button (concat r "(r)")
                              'type
                              (if (toggle-myrc r nil t)
                                  'on-button
                                'off-button)
                              'action
                              (eval
                               `(lambda (b)
                                  (let* ((currentstatus (toggle-myrc ,r nil t))
                                         (status (toggle-myrc ,r (if currentstatus
                                                                     "off"
                                                                   "on"))))
                                    (if status
                                        (button-put b 'type 'on-button)
                                      (button-put b 'type 'off-button))))))
               (insert "\n"))

      (never
       (cl-loop for s in toggle-scripts collect s)
       (cl-loop for f in toggle-functions collect f)
       (cl-loop for f in toggle-modes collect f))

      ;; Sort-lines breaks the buttons if they are not text buttons
      ;; Text buttons suffer from global-hl-lines mode taking precedence
      ;; (sort-lines nil (point-min) (point-max))
      (shut-up (replace-string "\n" " " nil (point-min) (point-max)))
      (visual-line-mode 1)))
  ;; Not sure how to integrate toggle-commands yet

  ;; Types of button specifiers
  ;; "caption" function
  ;; var
  ;; function
  ;; getter setter
  ;; "script in path"

  ;; (create-buttoncloud `(("yo" . (lambda (b) (message "yo")))
  ;;                       ("hi" . (lambda (b) (flash)))
  ;;                       ("hi1" . (lambda (b) (beep)))
  ;;                       ("toggle me" . (lambda (b) (beep)
  ;;                                        (let ((bt (button-get b 'type)))
  ;;                                          (if (eq bt 'on-button)
  ;;                                              (button-put b 'type 'off-button)
  ;;                                            (button-put b 'type 'on-button)))))
  ;;                       ;; ( "toggle me 2" . (deftogglebuttonl
  ;;                       ;;                     (message "enabled")
  ;;                       ;;                     (message "disabled")))
  ;;                       ("hi2" . (lambda (b) (sn "tmux run -b \"a beep\"")))
  ;;                       ;; ("hi3" . flash)
  ;;                       ;; ("hi4" . flash)
  ;;                       )
  ;;                     nil
  ;;                     ;; t
  ;;                     nil)
  )

;; (define-key global-map (kbd "H--") 'toggle-buttoncloud)
;; (define-key global-map (kbd "M-l M-t") nil)
;; (define-key global-map (kbd "M-m M-t") nil)
(define-key global-map (kbd "M-c") 'toggle-buttoncloud)
(define-key my-mode-map (kbd "M-c") 'toggle-buttoncloud)
(define-key global-map (kbd "H-_") 'toggle-script)

(defun toggle-imenu ()
  (interactive)
  ;; (call-interactively 'toggle-buttoncloud)
  ;; (my-helm-imenu)
  )

(provide 'my-toggle-scripts)