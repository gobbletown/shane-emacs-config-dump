(require 'my-utils)

;; Need functions for listing music file types
(defvar music-extensions '(mp4 m4a webm mkv mp3))

(defun random-playlist ()
  (interactive)
  (mu (snc
       (concat
        (cmd
         "cd"
         "$DUMP$NOTES/ws/youtube")
        "; "
        (cmd
         "play-here-rand")))))

(defun everynoise ()
  (interactive)
  (eww "https://everynoise.com/"))
(defalias 'random-music 'everynoise)

;; (syms2str music-extensions)
;; (list2str music-extensions)

(defun kill-music ()
  (interactive)
  ;; (shut-up (eval `(bd kill-music)))
  (vuiet-stop)
  (sh-notty "kill-music")
  ;; Do this because play-song may be on repeat
  (sh-notty "killall vlc")
  ;; (b kill-music)
  ;; (shut-up (eval `(bd killall play-song play-yt-playlist)))
  )

(defun play-video-path (fp &optional window-function external-cmd)
  (kill-music)
  (if (not window-function)
      (setq window-function 'sps))
  (if (not (sor external-cmd))
      (setq external-cmd "play-video"))
  (shut-up
    (let ((use-tty-str (if use-tty "export USETTY=y; " "")))
      (eval `(,window-function (concat use-tty-str external-cmd " " (q fp)) "-d")))))

(defun play-youtube-url (url &optional window-function)
  (play-video-path url window-function "yt -v"))

;; pm should happen immediately

(defun play-movie (path &optional term-and-transcript use-tty)
  (setq path (umn path))
  (kill-music)
  (let ((use-tty-str (if use-tty "export USETTY=y; " ""))
        ;; It make be an org link, which starts with a double quote
        (play-function (if (re-match-p "\\bhttp" path)
                           'play-youtube-url
                         'play-video-path)))
    (if term-and-transcript
        (progn
          (eval `(,play-function path 'spv))
          (sleep 0.1)
          (sph (concat "readsubs " (q path)) "-d"))
      (eval `(,play-function path))))
  nil)
(defun pm (path &optional term-and-transcript)
  (play-movie path term-and-transcript t))
(defalias 'play-video 'play-movie)
;; v should split and ask how
(defalias 'v 'play-movie)


(defun play-movie-with-transcript (path)
  (interactive (list (read-string-hist "youtube url: ")))
  (play-movie path t))
(defalias 'pmt 'play-movie-with-transcript)

(defun play-song (path &optional loop)
  ;; (bd play-song (e/q path))
  ;; (my/copy (str `(bd play-song ,(e/q (umn path)))))

  ;; (setq path (e/q (umn path))) ;; DO NOT quote. It's not needed
  (setq path (umn path))
  ;; (eval `(bd play-song ,"$DUMP/torrents/50000 MIDI FILES/By ARTIST/crash_test_dummies/mmm_mmm_mmm_mmm.mid"))
  ;; (my/copy (str `(bd play-song ,(e/q (umn path)))))
  ;; (eval `(bd play-song ,path))

  ;; (kill-music)

  (if loop
      (shut-up (eval `(bd play-song -l ,path)))
    (shut-up (eval `(bd play-song ,path))))
  nil)
(defalias 'ps 'play-song)

;; (defun dosoemthing ()
;;   "docstring"
;;   (message "hho"))

(defun play-playlist (path)
  ;; (bd play-yt-playlist (e/q path))
  ;; (kill-music)
  ;; (shut-up (eval `(bd killall play-song play-yt-playlist)))
  (shut-up (eval ` (bd play-yt-playlist ,(e/q path))))
  nil)

(defun get-yt-playlist (path)
  (interactive (list (read-string "path:")))

  (if (string-empty-p path) (setq path "[[https://www.youtube.com/playlist?list=PLGYGe2PKknX2kydiv28aq8dBXBWeJfxgg][The Lion King 2019 soundtrack - YouTube]]"))

  ;; (kill-music)
  ;; (shut-up (eval `(bd killall play-song play-yt-playlist)))

  (let ((result (e/chomp (sh-notty (concat "ci yt-list-playlist-urls " (e/q path))))))
    (if (called-interactively-p 'any)
        ;; (message result)
        (new-buffer-from-string result)
      result)))

(defun get-yt-playlist-json (path)
  (interactive (list (read-string "path:")))

  (if (string-empty-p path) (setq path "[[https://www.youtube.com/playlist?list=PLGYGe2PKknX2kydiv28aq8dBXBWeJfxgg][The Lion King 2019 soundtrack - YouTube]]"))

  (let ((result (e/chomp (sh-notty (concat "ci yt-playlist-json " (e/q path))))))
    (if (called-interactively-p 'any)
        ;; (message result)
        (new-buffer-from-string result)
      result)))
;; (commandp 'get-yt-playlist)

;; (get-yt-playlist "https://www.youtube.com/watch?v=LKaXY4IdZ40&list=OLAK5uy_n3E9OXkjyio72CwFeYhbHGJXRo3zsMxQc")
;; (tvipe (oc (get-yt-playlist "[[https://www.youtube.com/playlist?list=PLGYGe2PKknX2kydiv28aq8dBXBWeJfxgg][The Lion King 2019 soundtrack - YouTube]]")))
;; (oc (get-yt-playlist "[[https://www.youtube.com/playlist?list=PLGYGe2PKknX2kydiv28aq8dBXBWeJfxgg][The Lion King 2019 soundtrack - YouTube]]"))

(defun org-clink-urls (ms)
  (interactive)

  ;; (list2string (cl-loop for buf in (string2list ms) collect (sh-notty "oc" buf)))
  (sh-notty "oc" ms)

  ;; (string2list ms)
  )

(defalias 'oc 'org-clink-urls)

(defun lion-king-2019 ()
  (interactive)
  (play-playlist "[[https://www.youtube.com/playlist?list=PLGYGe2PKknX2kydiv28aq8dBXBWeJfxgg][The Lion King 2019 soundtrack - YouTube]]"))

(defun daft-punk-discovery ()
  (interactive)
  (play-playlist "[[https://www.youtube.com/playlist?list=OLAK5uy_lMA_iEf3aqk5YSDsnrPKojXegOiecSF94][Discovery - YouTube]]"))

(defun swordfish-ost ()
  (interactive)
  (play-playlist "[[https://www.youtube.com/playlist?list=OLAK5uy_mPdRDb_IJmG3DDeOlSwI5_rKKtAEZogys][Swordfish The Album (Original Motion Picture Soundtrack) - YouTube]]"))

;; (get-yt-playlist "[[https://www.youtube.com/playlist?list=OLAK5uy_mPdRDb_IJmG3DDeOlSwI5_rKKtAEZogys][Swordfish The Album (Original Motion Picture Soundtrack) - YouTube]]")

(defun brother-bear ()
  (interactive)
  (play-playlist "[[https://www.youtube.com/playlist?list=PLA8VHLKYzqTsKkpZ1SeJ1HmcGH6qHZTlt][Brother Bear OST - YouTube]]"))

(defun clubbed-to-death ()
  (interactive)
  (play-playlist "[[https://www.youtube.com/watch?v=pFS4zYWxzNA][clubbed to death - Matrix soundtrack - YouTube]]"))

(defun furious-angels ()
  (interactive)
  ;; (bld play-song "$DUMP$HOME/notes/ws/music/furious-angels/Rob Dougan - Furious Angels-jtAmFKaThNE.m4a")
  (bld play-song "[[https://www.youtube.com/watch?v=PJ8vJ2Qjuuc][Furious Angels - Rob Dougan - YouTube]]"))

(defun mus-epic1 ()
  (interactive)
  (bld play-song "[[https://www.youtube.com/watch?v=8oXo_QsxtDM][The Best of Epic Music August 2018 | Epic Powerful & Heroic Music Mix - YouTube]]"))

;; This backgrounds immediately but doesn't keep history of played song
;; (defun search-play-yt (query)
;;   (interactive (list (read-string-hist "yt play-song: ")))
;;   "Search on youtube and play thing."
;;   (bld yt -a -p (concat "ytsearch1:" query)))

(defun ytsearch (query)
  (if (string-match-p "\\bhttps?:" query)
      (setq query (chomp (sh/xurls query)))
    (cl-sn (concat "yt-search " (q query)) :chomp t)))

(defun search-play-yt (query-or-url &optional audioonly)
  (interactive (list (read-string-hist "yt play-song: " (my/selected-text))))

  (kill-music)
  (if (string-match-p "\\bhttps?:" query-or-url)
      (setq query-or-url (chomp (sh/xurls query-or-url)))
    (setq query-or-url (ytsearch query-or-url)))

  ;; (tv query-or-url)

  (if audioonly
      (my/shut-up (cl-sn (concat "play-song " (q query-or-url)) :detach t :chomp t))
    (sps (concat "yt -tty -v " (q query-or-url)) "-d")))

;; (defun search-play-yt (query)
;;   (interactive (list (read-string-hist "yt play-song: ")))
;;   (let ((url (cl-sn (concat "yt-search " query) :chomp t)))
;;     (play-song url))
;;   ;; (cl-sn (etv (concat "play-song " (q (concat "$(yt-search " query ")")))) :detach t :chomp t)
;;   )
(defalias 'yt 'search-play-yt)

(defun yta (query-or-url)
  (interactive (list (read-string-hist "yt play-song: ")))

  (yt query-or-url t))
(defalias 'ya 'yta)

(defun search-play-yt-transcript (query-or-url &optional lang)
  (interactive (list (read-string-hist "youtube query-or-url: " (my/selected-text))))

  (kill-music)
  (if (string-match-p "\\bhttps?:" query-or-url)
      (setq query-or-url (chomp (sh/xurls query-or-url)))
    (setq query-or-url (ytsearch query-or-url)))

  (if (not lang)
      (setq lang "en"))

  (spv (concat "yt -tty -v " (q query-or-url)) "-d")
  (sleep 0.1)
  ;; readsubs can't have unbuffer before it. it cats out
  ;; keep the cat here to A) help remember that B) prevent from thinking its a tty

  ;; readsubs was breaking make-sub-fp
  ;; I still do not know why
  ;; (sph (concat "readsubs -l " (q lang) " " (q query-or-url) " | cat | pavs") "-d")
  ;; (sph (concat "make-sub-fp " (q query-or-url)) "-d")
  ;; (sph (concat "oci readsubs " (q query-or-url) " | pavs") "-d")
  (rst query-or-url))

;; (defun search-play-yt (query)
;;   (interactive (list (read-string-hist "yt play-song: ")))
;;   (let ((url (cl-sn (concat "yt-search " query) :chomp t)))
;;     (play-song url))
;;   ;; (cl-sn (etv (concat "play-song " (q (concat "$(yt-search " query ")")))) :detach t :chomp t)
;;   )
(defalias 'ytt 'search-play-yt-transcript)

(defun ytt-fr (query)
  (interactive (list (read-string-hist "youtube query: ")))
  (ytt query "fr"))

(defun ytt-it (query)
  (interactive (list (read-string-hist "youtube query: ")))
  (ytt query "it"))

(defun readsubs (url &optional do-etv)
  (interactive (list (read-string-hist "yt query: ")))

  (if (re-match-p "^\\[\\[http" url)
      (setq url (chomp (snc "xurls" url))))

  (if (and (not (re-match-p "^http" url))
           (sor url))
      (setq url (ytsearch url)))

  (setq do-etv
        (or
         do-etv
         (interactive-p)))

  (let ((transcript (cl-sn (concat "oci readsubs " (q url) " | cat") :chomp t)))
    (if do-etv
        ;; (etv transcript)
        (tvs transcript)
      transcript)))
(defalias 'rs 'readsubs)

(defun rst (url)
  (interactive (list (read-string-hist "yt query: ")))
  (tvs (readsubs url)))

(defun readsubs-fr (url)
  (interactive (read-string-hist "yt query: "))
  (cl-sn (concat "oci readsubs.bak -l fr " (q url) " | cat") :chomp t))

(defun mus-epic ()
  (interactive)
  "Search for epic music and play it."
  (search-play-yt "epic music"))

;; (defun neverending-story ()
;;   (interactive)
;;   (bld yt -a -p "https://www.youtube.com/watch?v=heHdOTt_iGc&t"))

(defun elements-of-life ()
  (interactive)
  (play-song "[[https://www.youtube.com/watch?v=V9HKtPVms_Y][Tiesto elements of Life - YouTube]]"))

(defun prince-of-egypt-reprise ()
  (interactive)
  (play-song "https://www.youtube.com/watch?v=E1rEmAQJ7EQ&t=415"))

(defun neverending-story ()
  (interactive)
  (bld play-song "[[https://www.youtube.com/watch?v=heHdOTt_iGc&t][The Neverending Story (1984)  Soundtrack  - YouTube]]"))

(defun blink182 ()
  (interactive)
  (bld play-song "[[https://www.youtube.com/watch?v=lic0oCDMfwk][blink-182 - Bored To Death (Official Video) - YouTube]]"))

(defun flight-of-the-valkeries ()
  (interactive)
  (bld play-song "[[https://www.youtube.com/watch?v=3YOYlgvI1uE][Wilhelm Richard Wagner-Flight of the Valkyries - YouTube]]"))

;; [[https://www.youtube.com/watch?v=sAebYQgy4n4][Maroon 5 - Makes Me Wonder (Official Music Video) - YouTube]]

(defun dark-knight-ost ()
  (interactive)
  (bld play-song "[[https://www.youtube.com/watch?v=X209XwgnKtM][The Dark Knight (Full Soundtrack) - YouTube]]"))

(defun dark-knight-end-credits ()
  (interactive)
  (bld play-song "[[https://www.youtube.com/watch?v=fTr89ENLZPc][The Dark Knight - End Credits Music (HQ) - YouTube]]"))

(defun dark-knight-theme ()
  (interactive)
  (bld play-song "[[https://www.youtube.com/watch?v=w1B3Mgklfd0][Batman The Dark Knight Theme - Hans Zimmer - YouTube]]"))

(defun dark-knight-watchful-guardian ()
  "5 / 5"
  (interactive)
  (bld play-song "[[https://www.youtube.com/watch?v=buejiFXN7Hw][Hans Zimmer - A Watchful Guardian The Dark Knight - YouTube]]"))

(defun dark-knight-rises-theme ()
  (interactive)
  (bld play-song "[[https://www.youtube.com/watch?v=QBHSYkDwNIc][The Dark Knight Rises (Main Theme) - YouTube]]"))

(defun batman-begins-theme ()
  (interactive)
  (bld play-song "[[https://www.youtube.com/watch?v=K4unfJmIvw0][Batman Begins Theme Song - YouTube]]"))

(defun william-tell-overture ()
  (interactive)
  (bld play-song "[[https://www.youtube.com/watch?v=xoBE69wdSkQ][ROSSINI: William Tell Overture (full version) - YouTube]]"))
(defalias 'wto 'william-tell-overture)

(defun arias ()
  (interactive)
  (bld play-song "[[https://www.youtube.com/watch?v=hBStg7Ek6SQ][Mozart The Most Famous and Essential Arias. 4 Hours of All time Masterpiece Operas. HQ - YouTube]]"))

(defun real-estate-easy ()
  (interactive)
  (play-song "[[https://youtu.be/fewVRtkf8_o][Real Estate - Easy - YouTube]]"))

(defun real-estate-green-aisles ()
  (interactive)
  (play-song "[[https://youtu.be/eWhAR2y4Rs0][Real Estate - Green Aisles - YouTube]]"))

(defun real-estate-its-real ()
  (interactive)
  (play-song "[[https://youtu.be/4HWcViTXdYc][Real Estate - Its Real (Official Video) - YouTube]]"))

(defun real-estate-out-of-tune ()
  (interactive)
  (play-song "[[https://youtu.be/7KtoZT7Nxbo][Real Estate - Out Of Tune (2010) - YouTube]]"))

(defun real-estate-municipality ()
  (interactive)
  (play-song "[[https://youtu.be/GmvPeiJZ9io][Real Estate - Municipality - YouTube]]"))

(defun real-estate-wonder-years ()
  (interactive)
  (play-song "[[https://youtu.be/dPStsc0tN6A][Real Estate - Wonder years - YouTube]]"))

(defun real-estate-three-blocks ()
  (interactive)
  (play-song "[[https://youtu.be/BNVztPS-K30][Real Estate- Three Blocks - YouTube]]"))

(defun real-estate-younger-than-yesterday ()
  (interactive)
  (play-song "[[https://youtu.be/gx9vkD8o7CI][Real Estate-- \"Younger Than Yesterday\" - YouTube]]"))

(defun real-esatate-all-the-same ()
  (interactive)
  (play-song "[[https://youtu.be/N6Ni3H6vfQM][Real Estate - All The Same - YouTube]]"))

(defun reel-big-fish-beer ()
  (interactive)
  (play-song "[[https://www.youtube.com/watch?v=gql9220Qon8][Reel Big Fish: Beer - YouTube]]"))

(defun powderfinger-passenger ()
  (interactive)
  (play-song "[[https://www.youtube.com/watch?v=cmuyj4HtZWg][Powderfinger - Passenger - YouTube]]"))

(defun powderfinger-my-kind-of-scene (args)
  "4/5"
  (interactive "P")
  (play-song "[[https://www.youtube.com/watch?v=rnPV6CNdG3M][Powderfinger - My Kind Of Scene - YouTube]]"))

(defun powderfinger-love-your-way (args)
  "4/5"
  (interactive "P")
  (play-song "[[https://www.youtube.com/watch?v=Qp7AIYaTcZc][Powderfinger - Love Your Way (Official Video) - YouTube]]"))

(defun powderfinger-pick-you-up (args)
  "5/5 I love this song"
  (interactive "P")
  (play-song "[[https://www.youtube.com/watch?v=4Ha-dtNXTM8][Powderfinger - Pick You Up - YouTube]]"))

(defun powderfinger-daf (args)
  "Nostalgia 9/10"
  (interactive "P")
  (play-song "[[https://www.youtube.com/watch?v=Wsioatt9Wms][Powderfinger - D.A.F (Official Video) - YouTube]]"))

(defun maroon-5-makes-me-wonder (args)
  "docstring"
  (interactive "P")
  (play-song "[[https://www.youtube.com/watch?v=sAebYQgy4n4][Maroon 5 - Makes Me Wonder (Official Music Video) - YouTube]]"))

(defun play-foo-fighters-fz ()
  (interactive)
  (let* ((dir "$DUMP/torrents/Foo Fighters - Foo Fighters (1995) Flac")
         (sel (fz (glob "*" dir))))
    (play-song (concat dir "/" sel))))

(provide 'my-music)