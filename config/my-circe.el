(require 'circe)


(setq circe-network-options
      '(("Freenode"
         :tls t
         :nick "libertyprimebot"
         :sasl-username "libertyprimebot"
         :sasl-password "zeD3pe0QuaghooPhaeNahseu8eighu"
         :channels ("#bottest")
         )))


;; (lambdabot-hoogle-query "Int -> [a] -> [a]")
(defun lambdabot-hoogle-query (query)
  (if (get-buffer "irc.freenode.net:6697")
      (switch-to-buffer "irc.freenode.net:6697")
    (circe "Freenode"))
  (circe-command-JOIN "#haskell")

  ;; if the line is empty (on a free repl)
  (if (and (looking-at-p "$")
           (not (thing-at-point 'line)))
      (progn
        (insert (concat "/msg lambdabot @hoogle " query))
        (ekm "C-m")
        (switch-to-buffer "lambdabot")))

                                        ; (sleep 0 100)
                                        ; (sleep 0 500)
  (sleep 3)
  ;; Save the response to an outside variable lambdabot-response
  ;; (bp awk1 | tac | sed -n "2,/^>/{s/^<lambdabot> //;p}" | tac | sed 1d | ds -s lambdabot-response (buffer-contents))
  ;; Doing it manually I would need to use the clipboard
  ;; (ekm "M-> C-SPC")
  ;; (search-backward-regexp "^> @ho")

  (let ((cmd "awk1 | tac | sed -n \"2,/^>/{s/^<lambdabot> //;s/\\\\s*\\\\[\\\\d\\\\+:\\\\d\\\\+\\\\]$//;p}\" | tac | sed 1d | ds -s lambdabot-response"))
    (sh-notty cmd (buffer-contents) "/" nil t ))

  ;; (bp awk1 | tac | sed -n "2,/^>/{s/^<lambdabot> //;s/\\s*\\[\\d\\+:\\d\\+\\]$//;p}" | tac | sed 1d | ds -s lambdabot-response (buffer-contents))
  )


(defun rudybot-doc-query (query)
  (if (get-buffer "irc.freenode.net:6697")
      (switch-to-buffer "irc.freenode.net:6697")
    (circe "Freenode"))
  (circe-command-JOIN "#racket")

  ;; if the line is empty (on a free repl)
  (if (and (looking-at-p "$")
           (not (thing-at-point 'line)))
      (progn
        (insert (concat "/msg rudybot doc " query))
        (ekm "C-m")
        (switch-to-buffer "rudybot")))

                                        ; (sleep 0 100)
                                        ; (sleep 0 500)
  (sleep 3)
  ;; Save the response to an outside variable lambdabot-response
  ;; (bp awk1 | tac | sed -n "2,/^>/{s/^<lambdabot> //;p}" | tac | sed 1d | ds -s lambdabot-response (buffer-contents))
  ;; Doing it manually I would need to use the clipboard
  ;; (ekm "M-> C-SPC")
  ;; (search-backward-regexp "^> @ho")

  (let ((cmd "awk1 | tac | sed -n \"2,/^>/{s/^<rudybot> //;s/\\\\s*\\\\[\\\\d\\\\+:\\\\d\\\\+\\\\]$//;p}\" | tac | sed 1d | ds -s rudybot-response"))
    (sh-notty cmd (buffer-contents) "/" nil t ))

  ;; (bp awk1 | tac | sed -n "2,/^>/{s/^<lambdabot> //;s/\\s*\\[\\d\\+:\\d\\+\\]$//;p}" | tac | sed 1d | ds -s lambdabot-response (buffer-contents))
  )


(provide 'my-circe)