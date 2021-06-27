(require 'vuiet)

;; https://www.last.fm/api/authentication
;; https://www.last.fm/api/accounts

(defun my-play-artist (name)
  (interactive (list (read-string "artist:")))
  (vuiet-stop)
  (sleep 0.1)
  (vuiet-play-artist name))

;; nadvice - proc is the original function, passed in. do not modify
(defun vuiet-play-artist-around-advice (proc &rest args)
  (vuiet-stop)
  (sleep 0.1)
  (let ((res (apply proc args)))
    ;; (message "vuiet-play-artist returned %S" res)
    res))
(advice-add 'vuiet-play-artist :around #'vuiet-play-artist-around-advice)


;; nadvice - proc is the original function, passed in. do not modify
(defun vuiet-play-around-advice (proc &rest args)
  (vuiet-stop)
  (sleep 0.1)
  (let ((res (apply proc args)))
    ;; (message "vuiet-play returned %S" res)
    res))
(advice-add 'vuiet-play :around #'vuiet-play-around-advice)


(defun vuiet-artist-info-search (artist)
  "Search ARTIST and display info about the selected item.
Similar to `vuiet-artist-info', but search for ARTIST on last.fm
first and then let the user select one artist from the resulting
list of artists.  Vuiet then displays the info about the user
selected artist.  Useful if you don't know the exact name of the
artist."
  (interactive (list (ivy-read "Info for artist: "
                               (mapcar #'car (lastfm-artist-search (read-string "Artist:")))
                               :action #'vuiet-artist-info)))
  (if artist
      (vuiet-artist-info (car (mapcar #'car (lastfm-artist-search artist))))))


;; TODO Find a way to remember vuiet tracks
(define-key vuiet-mode-map (kbd "p") 'vuiet-replay)
(define-key vuiet-mode-map (kbd "n") 'vuiet-next)

(provide 'my-vuiet)