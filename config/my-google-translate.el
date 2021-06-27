; a fix
; https://github.com/atykhonov/google-translate/issues/52

(require 'google-translate)

(when (and (string-match "0.11.14"
                        (google-translate-version))
          (>= (time-to-seconds)
              (time-to-seconds
               (encode-time 0 0 0 23 9 2018))))
 (defun google-translate--get-b-d1 ()
   ;; TKK='427110.1469889687'
   (list 427110 1469889687)))