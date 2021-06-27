;;; Treat all themes as safe
;; Because sometimes emacs goes insane
;; This doesn't work for spacemacs.
(setq custom-safe-themes t)

; this forces themes to be safe
(defun custom-theme-load-confirm (hash)
  "Query the user about loading a Custom theme that may not be safe.
The theme should be in the current buffer.  If the user agrees,
query also about adding HASH to `custom-safe-themes'."
  (unless noninteractive
    (save-window-excursion
      (rename-buffer "*Custom Theme*" t)
      (emacs-lisp-mode)
      (pop-to-buffer (current-buffer))
      (goto-char (point-min))
      (prog1 (when t
               ;; Offer to save to `custom-safe-themes'.
               (and (or custom-file user-init-file)
                    t
                    (customize-push-and-save 'custom-safe-themes (list hash)))
               t)
        (quit-window)))))

;; If spacemacs is run not in daemon mode, this is still going to be true
(if (and my-daemon-name (not (cl-search "SPACEMACS" my-daemon-name)))
    (use-package spacemacs-theme
      :ensure t
      :init
      (load-theme 'spacemacs-dark t)
      (setq spacemacs-theme-org-agenda-height nil)
      (setq spacemacs-theme-org-height nil))
    (load-theme 'spacemacs-dark t))

(defun org-set-heading-height-1 ()
  (interactive)
  (set-face-attribute 'org-document-title nil :height 1.0)
  (set-face-attribute 'org-level-1 nil :height 1.0)
  (set-face-attribute 'org-level-2 nil :height 1.0)
  (set-face-attribute 'org-level-3 nil :height 1.0)
  (set-face-attribute 'org-scheduled-today nil :height 1.0)
  (set-face-attribute 'org-agenda-date-today nil :height 1.1)
  (set-face-attribute 'org-table nil :foreground "#008787"))
(org-set-heading-height-1)

;;(use-package spaceline
;;  :demand t
;;  :init
;;  (setq powerline-default-separator 'arrow-fade)
;;  :config
;;  (require 'spaceline-config)
;;  (spaceline-spacemacs-theme))


;;(if (cl-search "DEFAULT_org" my-daemon-name)
;;  (progn ()
;;         (custom-set-variables '(custom-enabled-themes (quote (tango-dark))))
;;         )
;;  )

;; [[http://peach-melpa.org][PeachMelpa]]
;; More themes here

;;(if (cl-search "SPACEMACS" my-daemon-name)
;;  (custom-set-variables '(custom-enabled-themes (quote (spacemacs-dark)))))

;; (require 'moe-theme)

;; this doesn't work with sp nw --debug-init because it's not run as a
;; daemon. I must fix this or the theme will keep changing every time I
;; run spacemacs as nw
;;(if (not (cl-search "SPACEMACS" my-daemon-name))
;;
;;;;(message ".emacs: load theme")
;;;;(if (not (cl-search "SPACEMACS" my-daemon-name))
;;;;  (progn
;;;;    ;; (moe-light)
;;;;    (moe-dark)
;;;;    ))
;;;;(moe-dark)
;;
;;  ;; This is good, but iedit needs adjustment
;;
;;  (load-theme 'moe-dark t)
;;
;;  ;; This might be my favorite. Give it to spacemacs
;;  ;;(load-theme 'wombat t)
;;  ;;vim +/"   dotspacemacs-themes" "$HOME/.spacemacs"
;;  )

;; this is a thing, but spacemacs deletes it when i put it in
;; packages.txt


;;(require 'spacemacs-theme)
;;(load-theme 'spacemacs-dark t)

;; This is amazing! Vim's inkpot theme. But it only looks good in GUI emacs.
;; (load-theme 'inkpot t)
 

(provide 'my-themes)
