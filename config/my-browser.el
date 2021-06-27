(provide 'my-browser)

;; (setq browse-url-browser-function
;;       'browse-url-generic
;;       browse-url-generic-program
;;       "/home/shane/scripts/ff-view")

(setq browse-url-browser-function
      'browse-url-generic
      browse-url-generic-program
      "/home/shane/scripts/copy-thing")


(defun eww-and-search (url)
  "This is a browser function used by ff-view and, thus, racket to search for something in the address bar and then search the resulting website."
  (b ni eww-and-search)
  ;; (tvipe (sed "s/.*q=//" url))
  (my/eww url))