;; This caused slowness in emacs
;; (add-to-list 'load-path (concat emacsdir "/manual-packages/apu"))
;; (require 'apu)
                                        ; $EMACSD/manual-packages/apu/apu.el

(add-to-list 'load-path (concat emacsdir "/manual-packages/unpackaged.el"))
(require 'unpackaged)

(add-to-list 'load-path (concat emacsdir "/manual-packages/systemd-services.el"))
(require 'systemd-services)

(add-to-list 'load-path (concat emacsdir "/manual-packages/inf-messer"))
(require 'inf-messer)
(load-library "inf-messer")

(add-to-list 'load-path (concat emacsdir "/manual-packages/inf-kjv"))
(require 'inf-kjv)
(load-library "inf-kjv")

(add-to-list 'load-path (concat emacsdir "/manual-packages/calibre-query.el"))
(require 'calibre-query)
(load-library "calibre-query")

(add-to-list 'load-path (concat emacsdir "/manual-packages/org-transclusion"))
(require 'org-transclusion)
(load-library "org-transclusion")

(add-to-list 'load-path (concat emacsdir "/manual-packages/svg-lib"))
(require 'svg-lib)
(load-library "svg-lib")

(add-to-list 'load-path (concat emacsdir "/manual-packages/gnus"))
(require 'gnus)
(load-library "gnus")

;; (eval
;;  `(use-package power-mode
;;     :load-path ,(concat emacsdir "/manual-packages/power-mode.el")
;;     :init
;;     (add-hook 'after-init-hook #'power-mode)))

(never
 ;; This is not nice

 ;; It creates an eieio object which has some kind of timer
 ;; It doesn't even have a configuration layer

 ;; The code is so old it is quite broken.

 (add-to-list 'load-path (concat emacsdir "/manual-packages/matrix-client.el"))
 (require 'matrix-client)
 (load-library "matrix-client"))

(provide 'my-load-manually)