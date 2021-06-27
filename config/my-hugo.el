;; https://ox-hugo.scripter.co/

;; (with-eval-after-load 'ox
;;   (require 'ox-hugo))

(use-package ox-hugo
  :ensure t            ;Auto-install the package from Melpa (optional)
  :after ox)

(setq org-hugo-default-section-directory "/home/shane/dump/home/shane/notes/ws/blog/blog/content/posts")

(provide 'my-hugo)