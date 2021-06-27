(require 'my-browser)
(require 'engine-mode)
(require 'my-search)

;; browse-url needs a function that takes 2 arguments
(defun my/eww-js-for-browse-url (url discard)
  (my/eww-js url nil))

;; This is basically equivalent to my/eww-browse-url
(defun my/eww-for-browse-url (url discard)
  (my/eww url nil))

;; (setq engine/browser-function 'my/eww-browse-url)
;; (setq engine/browser-function 'browse-url-generic)
;; (setq engine/browser-function 'my/eww-browse-url-chrome)
;; (setq engine/browser-function 'my/eww-js-for-browse-url)
(setq engine/browser-function 'my/eww-for-browse-url)

;; (engine/set-keymap-prefix (kbd "C-x /"))
(engine/set-keymap-prefix (kbd "H-/"))

(engine-mode 1)

(defun defengine-around-advice (proc &rest args)
  (let ((res (apply proc args)))
    (add-to-list 'search-functions (str2sym (concat "engine/search-" (str (car args)))))
    res))
(advice-add 'defengine :around #'defengine-around-advice)

;; Also Use =C-x /= to invoke engine-mode
(define-key engine-mode-map (kbd "C-x /") engine-mode-prefixed-map)

;; (engine/set-keymap-prefix (kbd "C-c s"))

;; Chrome to engine-mode script
;; [[/home/shane/scripts/chrome-to-engine-mode.sh][scripts/chrome-to-engine-mode.sh]]


;; Modify search before sending
;; ----------------------------

;; (defengine duckduckgo
;;   "https://duckduckgo.com/?q=%s"
;;   :term-transformation-hook 'upcase)

;; (defengine diec2
;;   "dlc.iec.cat/results.asp?txtEntrada=%s"
;;   :term-transformation-hook (lambda (term) (encode-coding-string term latin-1))
;;   :keybinding "c")

;; github simple -- eww
(defengine gs
  "https://github.com/search?ref=simplesearch&q=%s"
  :keybinding "e"
  :browser 'my/eww-browse-url)

(defengine amazon
  "http://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=%s")

(defengine clojars-clojure-templates
  "https://clojars.org/search?q=%s"
  :keybinding "C")

(defengine duckduckgo
  "https://duckduckgo.com/?q=%s"
  :keybinding "k")

(defengine libraries
  "https://libraries.io/search?q=%s"
  :keybinding "/")

(defengine libgen
  "http://gen.lib.rus.ec/search.php?req=%s&lg_topic=libgen&open=0&view=simple&res=25&phrase=1&column=def"
  :keybinding "I")

;; (defengine scihub
;;   "https://sci-hub.do/.ec/search.php?req=%s&lg_topic=libgen&open=0&view=simple&res=25&phrase=1&column=def"
;;   :keybinding "S")

(defengine codesearch-debian
  "https://codesearch.debian.net/search?q=%s"
  :keybinding "d")

(defengine searchcode
  "https://searchcode.com/?q=%s"
  :keybinding "s")

(defengine hoogle
  "https://www.haskell.org/hoogle/?hoogle=%s"
  :keybinding "7")

;; github path requires contents too, so I need an external function for this
;; (defengine github-path
;;   "https://github.com/search?ref=simplesearch&q=%s"
;;   https://github.com/search?q=video+path%3A%2Flayouts%2Fshortcodes&type=Code
;;   :keybinding "h")

(defengine rosindex
  "https://index.ros.org/search/?term=%s"
  :keybinding "R")

(defengine racket
  "http://docs.racket-lang.org/search/index.html?q=%s"
  :keybinding "r")

(defengine racket-languages
  "http://docs.racket-lang.org/search/index.html?q=H:%s"
  :keybinding "l")

;;(defengine google-tcl
;;  "http://www.google.com/search?ie=utf-8&oe=utf-8&q=tcl+lang+%s"
;;  :keybinding "g"
;;  :browser 'my/eww-browse-url)

;; (defengine google
;;   "http://www.google.com/search?ie=utf-8&oe=utf-8&q=%s"
;;   :keybinding "g"
;;   :browser 'my/eww-browse-url)
(defengine google
  "http://www.google.com/search?ie=utf-8&oe=utf-8&q=%s"
  :keybinding "g"
  :browser 'my/eww)

(defun chrome (url &optional discard)
  (interactive (read-string-hist "chrome: "))
  (ns (concat "Chrome: " url))
  (sn (concat "chrome " (q url))))

;; Unfortunately, search requires that I am logged in
(defengine github-advanced
  "https://github.com/search?q=%s&type=Code&ref=advsearch&l=GraphQL&l="
  :keybinding "H"
  ;; :browser 'my/eww
  :browser 'chrome)

(defengine github
  "https://github.com/search?ref=simplesearch&q=%s"
  :keybinding "h")

;; (defengine google-lucky
;;   "http://www.google.com/search?ie=utf-8&oe=utf-8&btnI&q=%s"
;;   :keybinding "L"
;;   :browser 'my/eww-browse-url)
(defengine google-lucky
  "http://www.google.com/search?ie=utf-8&oe=utf-8&btnI&q=%s"
  :keybinding "L"
  :browser 'my/eww-for-browse-url)

(defun browsh (&rest body)
  (interactive (list (read-string "url:")))

  (if (not body)
      (setq body '("http://google.com")))

  (sps (concat "browsh " (q (car body)))))

(defun ebrowsh (url)
  "This is very slow, actually"
  (interactive (list (read-string "url:")))

  (if (not url)
      (setq url '("http://google.com")))

  (term-nsfa (concat "browsh -s " (q url))))

(defengine grep-app
  "https://grep.app/search?q=%s"
  :keybinding "G"
  :browser 'browsh)

(defengine google-images
  "http://www.google.com/images?hl=en&source=hp&biw=1440&bih=795&gbv=2&aq=f&aqi=&aql=&oq=&q=%s"
  :keybinding "i"
  )

(defengine google-maps
  "http://maps.google.com/maps?q=%s"
  :docstring "Mappin' it up."
  :keybinding "m"
  )

(defengine project-gutenberg
  "http://www.gutenberg.org/ebooks/search/?query=%s")

(defengine rfcs
  "http://pretty-rfc.herokuapp.com/search?q=%s")

(defengine stack-overflow
  "https://stackoverflow.com/search?q=%s"
  :keybinding "o"
  )

;; (defengine twitter
;;   "https://twitter.com/search?q=%s"
;;   :keybinding "r"
;;   )

(defengine wikipedia
  "http://www.wikipedia.org/search-redirect.php?language=en&go=Go&search=%s"
  :keybinding "w"
  :docstring "Searchin' the wikis.")

(defengine wiktionary
  "https://www.wikipedia.org/search-redirect.php?family=wiktionary&language=en&go=Go&search=%s"
  :keybinding "k")

(defengine wolfram-alpha
  "http://www.wolframalpha.com/input/?i=%s"
  :keybinding "a")

(defengine youtube
  "http://www.youtube.com/results?aq=f&oq=&search_query=%s")

;; I may need to use a proxy address
(defengine thepiratebay
  "http://uj3wazyk5u4hnvtk.onion/search/%s/0/99/0"
  :keybinding "p")

(defun engine/prompted-search-term (engine-name)
  (let ((current-word (or (thing-at-point 'symbol) "")))
    (read-string-hist (engine/search-prompt engine-name current-word)
                      nil nil current-word)))

(defalias 'find-book-online 'engine/search-libgen)

(provide 'my-engine)