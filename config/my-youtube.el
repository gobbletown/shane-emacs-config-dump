(autoload 'helm-youtube "helm-youtube" nil t)
;; (global-set-key (kbd "C-c y") 'helm-youtube)

(defun my/ivy-youtube ()
  (interactive)
  ;; I could try to work out why this does not work. Or I could just switch my browser function to firefox. Things should play instantly
  (let* ((browse-url-generic-program "yt-view"))
    (ivy-youtube)))

(global-set-key (kbd "C-c y") 'my/ivy-youtube) ;; bind hotkey

;;set default browser for you will use to play videos/default generic
;;(setq browse-url-browser-function 'browse-url-generic)
;;(setq browse-url-generic-program "google-chrome-open-url")

;; compromised
;; (helm-youtube-key (quote AIzaSyA1KEHd-sBUxOKR-uv5zeFLzjrF45kDKLY) t)

(setq helm-youtube-key (str2sym (myrc-get "youtube_key")))
(setq ivy-youtube-key (str2sym (myrc-get "youtube_key")))

(setq browse-url-browser-function 'browse-url-generic)

; DO NOT set this here "browse-url-generic-program"

;; (setq browse-url-generic-program "yt-view")
;; (setq browse-url-generic-program "google-chrome")

(provide 'my-youtube)