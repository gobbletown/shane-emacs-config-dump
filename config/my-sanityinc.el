(require 'mode-line-bell)
(require 'nav-flash)

;; mode-line-bell-flash isn't working so use nav-flash

;; (defalias 'flash 'mode-line-bell-flash)

(defalias 'flash 'nav-flash-show)
(defalias 'mode-line-bell-flash 'flash)

(provide 'my-sanityinc)