;;; go-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "go" "go.el" (0 0 0 0))
;;; Generated autoloads from go.el

(autoload 'go-play "go" "\
Play a game of GO." t nil)

(autoload 'go-view-sgf "go" "\
View an SGF file.

\(fn &optional FILE)" t nil)

(register-definition-prefixes "go" '("go-instantiate"))

;;;***

;;;### (autoloads nil "go-api" "go-api.el" (0 0 0 0))
;;; Generated autoloads from go-api.el

(register-definition-prefixes "go-api" '("defgeneric-w-setf" "go-" "ignoring-unsupported"))

;;;***

;;;### (autoloads nil "go-board" "go-board.el" (0 0 0 0))
;;; Generated autoloads from go-board.el

(register-definition-prefixes "go-board" '("*autoplay*" "*b" "*go-board-overlays*" "*history*" "*size*" "*t" "*white*" "alive-p" "apply-" "black-piece" "board" "clear-labels" "go-" "make-board" "move-type" "neighbors" "other-color" "pieces-to-board" "player-to-string" "point-of-pos" "remove-dead" "set-go-" "update-display" "white-piece" "with-"))

;;;***

;;;### (autoloads nil "go-board-faces" "go-board-faces.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from go-board-faces.el

(register-definition-prefixes "go-board-faces" '("go-board-"))

;;;***

;;;### (autoloads nil "go-util" "go-util.el" (0 0 0 0))
;;; Generated autoloads from go-util.el

(register-definition-prefixes "go-util" '("*go-partial-line*" "aget" "alistp" "char-to-num" "compose" "curry" "ear-muffs" "go-" "indexed" "make-go-insertion-filter" "num-to-char" "pos-to-index" "range" "rpush" "set-aget" "sym-cat" "take" "transpose-array" "un-ear-muffs" "until"))

;;;***

;;;### (autoloads nil "list-buffer" "list-buffer.el" (0 0 0 0))
;;; Generated autoloads from list-buffer.el

(register-definition-prefixes "list-buffer" '("*buffer-" "*enter-function*" "*refresh-function*" "list"))

;;;***

;;;### (autoloads nil nil ("go-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; go-autoloads.el ends here
