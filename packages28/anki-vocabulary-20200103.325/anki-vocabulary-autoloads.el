;;; anki-vocabulary-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "anki-vocabulary" "anki-vocabulary.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from anki-vocabulary.el

(autoload 'anki-vocabulary-set-ankiconnect "anki-vocabulary" "\
Set the correspondence relation for fields in card." t nil)

(autoload 'anki-vocabulary "anki-vocabulary" "\
Translate SENTENCE and WORD, and then create an anki card.

\(fn &optional SENTENCE WORD)" t nil)

(register-definition-prefixes "anki-vocabulary" '("anki-vocabulary-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; anki-vocabulary-autoloads.el ends here
