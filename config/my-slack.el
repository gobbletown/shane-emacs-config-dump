;; (el-get-bundle slack)

(use-package slack
  :commands (slack-start)
  :init
  ;; (setq slack-buffer-emojify t)
  (setq slack-buffer-emojify nil) ;; if you want to enable emoji, default nil
  (setq slack-prefer-current-team t)
  :config

  ;; (slack-register-team
  ;;  :name "codelingo"
  ;;  :default t
  ;;  :client-id "e1f1f9d9-1541150511.437"
  ;;  :client-secret "-hBihidfYM8"
  ;;  :token "xoxp-11409744528-11442331975-445295933702-5edccf28394238d92f858964114c58e7"
  ;;  :subscribed-channels '(codelingo codelingo-dev community-building company content errors general )
  ;;  :full-and-display-names t)

  ;; (slack-register-team
  ;;  :name "fmgautonomy"
  ;;  :default t
  ;;  ; :client-id "e1f1f9d9-1541150511.437"
  ;;  ; :client-secret "-hBihidfYM8"
  ;;  :token "xoxs-982323825778-986104469187-987515649985-0133a14f583da05e881f6ff59c54457f91382cdf1577f7c8ecb3e2f8f1b9b4e3"
  ;;  :subscribed-channels '(engineering-autonomy )
  ;;  ; :full-and-display-names t
  ;;  :full-and-display-names nil)

  ;; (slack-register-team
  ;;  :name "Spark-NLP"
  ;;  :default t
  ;;  :client-id "317879417367.1405393639924"
  ;;  :client-secret "c7ceb530873fbf23119cf638e5a13037"
  ;;  :token "jkyk5g1kOUdNbWJpEtb3jbza"
  ;;  :subscribed-channels '(sparknlp)
  ;;  :full-and-display-names nil)

  ;; (slack-register-team
  ;;  :name "petridish"
  ;;  :default t
  ;;  ;; :client-id "205323178372.1181243599569"
  ;;  ;; :client-secret "b37cbf625d85f655fe835f7477393b09"
  ;;  :token "QzRx4d5HKllgbq77trTLPiSY"
  ;;  :subscribed-channels '(events general members)
  ;;  :full-and-display-names nil)

                                        ;(slack-register-team
                                        ; :name "codelingo"
                                        ; :client-id "e1f1f9d9-1541150511.437"
                                        ; :client-secret "cccccccccccccccccccccccccccccccc"
                                        ; :token "xoxp-11409744528-11442331975-445295933702-5edccf28394238d92f858964114c58e7"
                                        ; :subscribed-channels '(codelingo codelingo-dev community-building company content errors general ))

  (evil-define-key 'normal slack-info-mode-map
    ",u" 'slack-room-update-messages)
  (evil-define-key 'normal slack-mode-map
    ",c" 'slack-buffer-kill
    ",ra" 'slack-message-add-reaction
    ",rr" 'slack-message-remove-reaction
    ",rs" 'slack-message-show-reaction-users
    ",pl" 'slack-room-pins-list
    ",pa" 'slack-message-pins-add
    ",pr" 'slack-message-pins-remove
    ",mm" 'slack-message-write-another-buffer
    ",me" 'slack-message-edit
    ",md" 'slack-message-delete
    ",u" 'slack-room-update-messages
    ",2" 'slack-message-embed-mention
    ",3" 'slack-message-embed-channel
    "\C-n" 'slack-buffer-goto-next-message
    "\C-p" 'slack-buffer-goto-prev-message)
  (evil-define-key 'normal slack-edit-message-mode-map
    ",k" 'slack-message-cancel-edit
    ",s" 'slack-message-send-from-buffer
    ",2" 'slack-message-embed-mention
    ",3" 'slack-message-embed-channel))

(setq slack-buffer-emojify nil)
(setq slack-render-image-p nil)

(defun slack-start-and-join ()
  (interactive)
  (call-interactively 'slack-start)
  (call-interactively 'slack-channel-select))

(provide 'my-slack)