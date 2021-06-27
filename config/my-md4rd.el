(require 'md4rd)

;; the access and refresh tokens are set as variables at first login. I
;; then get their values from emacs and set them here.
;; (xc md4rd--oauth-refresh-token)

(try
;; this hangs, unfortunately, and breaks emacs startup. I don't know why.
;; The try apears to prevent this from hanging / failing
(use-package md4rd :ensure t
  :config
  (add-hook 'md4rd-mode-hook 'md4rd-indent-all-the-lines)
  (setq md4rd-subs-active '(emacs lisp+Common_Lisp prolog clojure))
  (setq md4rd--oauth-access-token
        "28049713-Mb0w0iAwItZKPefO8JHmpZ0Zzyc")
  (setq md4rd--oauth-refresh-token
        "28049713-f_CelMeVJ64yTJRYOFc3Kqndh8I")
  (run-with-timer 0 3540 'md4rd-refresh-login))
  )

(defalias 'reddit 'md4rd)

(provide 'my-md4rd)