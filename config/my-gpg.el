;; https://www.masteringemacs.org/article/keeping-secrets-in-emacs-gnupg-auth-sources
;; https://hostadvice.com/how-to/how-to-install-and-configure-openpgp-on-ubuntu-18-04/

;; DISCARD frustratingly, this does not fix the problem for forge or erc
;; I just needed to reboot emacs
;; It turns out that you have to use custom-set-variables for this one
;; https://stackoverflow.com/questions/41741477/emacs-epa-and-gnupg2-no-usable-configuration
;; (setq epg-gpg-program "gpg")

;; I appear to be able to use gpg for some things.
;; I can open a new something.gpg file and encrypt it with my key.
;; And open it again.

(require 'epa-file)
;; (custom-set-variables '(epg-gpg-program  "/home/shane/scripts/gpg2"))
(setq epg-gpg-program "/home/shane/scripts/gpg2")

(setenv "GPG_AGENT_INFO" nil)

(provide 'my-gpg)