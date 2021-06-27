(defhydra mz/hydra-elfeed ()
   "filter"
   ("c" (elfeed-search-set-filter "@6-months-ago +cs") "cs")
   ("e" (elfeed-search-set-filter "@6-months-ago +emacs") "emacs")
   ("d" (elfeed-search-set-filter "@6-months-ago +education") "education")
   ("*" (elfeed-search-set-filter "@6-months-ago +star") "Starred")
   ("M" elfeed-toggle-star "Mark")
   ("A" (elfeed-search-set-filter "@6-months-ago") "All")
   ("T" (elfeed-search-set-filter "@1-day-ago") "Today")
   ("Q" bjm/elfeed-save-db-and-bury "Quit Elfeed" :color blue)
   ("q" nil "quit" :color blue)
   )

(use-package elfeed
  :ensure t
  :bind (:map elfeed-search-mode-map
          ("q" . bjm/elfeed-save-db-and-bury)
          ("Q" . bjm/elfeed-save-db-and-bury)
          ("m" . elfeed-toggle-star)
          ("M" . elfeed-toggle-star)
          ("j" . mz/hydra-elfeed/body)
          ("J" . mz/hydra-elfeed/body)))