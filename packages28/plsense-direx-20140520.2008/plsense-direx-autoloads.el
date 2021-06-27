;;; plsense-direx-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "plsense-direx" "plsense-direx.el" (0 0 0 0))
;;; Generated autoloads from plsense-direx.el

(autoload 'plsense-direx:get-explorer "plsense-direx" "\
Return the buffer of package explorer for PROJNM.

\(fn PROJNM &optional FORCE-CREATE NO-CREATE)" nil nil)

(autoload 'plsense-direx:get-referer "plsense-direx" "\
Return the buffer of package referer for PROJNM.

\(fn PROJNM &optional FORCE-CREATE NO-CREATE)" nil nil)

(autoload 'plsense-direx:get-explorer-with-open-location "plsense-direx" "\
Return the buffer of package explorer for PROJNM with open location of PKGNM/MTDNM.

\(fn PROJNM PKGNM &optional MTDNM)" nil nil)

(autoload 'plsense-direx:get-referer-with-open-location "plsense-direx" "\
Return the buffer of package referer for PROJNM with open location of PKGNM/MTDNM.

\(fn PROJNM PKGNM &optional MTDNM)" nil nil)

(autoload 'plsense-direx:update-explorer "plsense-direx" "\
Update the buffer of package explorer for PROJNM about PKGNM.

\(fn PROJNM PKGNM)" nil nil)

(autoload 'plsense-direx:update-referer "plsense-direx" "\
Update the buffer of package referer for PROJNM about PKGNM.

\(fn PROJNM PKGNM)" nil nil)

(autoload 'plsense-direx:find-explorer-no-select "plsense-direx" "\
Find the buffer of package explorer matched cursor location without display." nil nil)

(autoload 'plsense-direx:find-referer-no-select "plsense-direx" "\
Find the buffer of package referer matched cursor location without display." nil nil)

(autoload 'plsense-direx:config-default "plsense-direx" "\
Do setting recommemded configuration." nil nil)

(autoload 'plsense-direx:open-explorer "plsense-direx" "\
Open perl package explorer.

\(fn &optional OTHER-WINDOW)" t nil)

(autoload 'plsense-direx:open-explorer-other-window "plsense-direx" "\
Open perl package explorer in other window." t nil)

(autoload 'plsense-direx:open-referer "plsense-direx" "\
Open perl package referer.

\(fn &optional OTHER-WINDOW)" t nil)

(autoload 'plsense-direx:open-referer-other-window "plsense-direx" "\
Open perl package referer in other window." t nil)

(autoload 'plsense-direx:display-help "plsense-direx" "\
Display help buffer about the node/leaf of cursor location." t nil)

(autoload 'plsense-direx:update-current-package "plsense-direx" "\
Update the package of cursor location in Perl buffer." t nil)

(autoload 'plsense-direx:setup-current-buffer "plsense-direx" "\
Do setup for using plsense-direx in current buffer." t nil)

(register-definition-prefixes "plsense-direx" '("direx:" "plsense-direx:"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; plsense-direx-autoloads.el ends here
