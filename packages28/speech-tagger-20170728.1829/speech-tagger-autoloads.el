;;; speech-tagger-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "speech-tagger" "speech-tagger.el" (0 0 0 0))
;;; Generated autoloads from speech-tagger.el

(autoload 'speech-tagger-clear-tags-dwim "speech-tagger" "\
Clear tag overlays from highlighted region or buffer.
If PFX given, read buffer name to clear tags from.

\(fn PFX)" t nil)

(autoload 'speech-tagger-tag-dwim "speech-tagger" "\
Create tag overlays in selected region or buffer for parts of speech.
Send selected region to external process for analysis.  Call
`speech-tagger-setup' as required.  If PFX given, read buffer name to tag.  Be
warned that this function may take some time on large selections or buffers.

\(fn PFX)" t nil)

(register-definition-prefixes "speech-tagger" '("speech-tagger-"))

;;;***

;;;### (autoloads nil nil ("speech-tagger-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; speech-tagger-autoloads.el ends here
