(require 'lentic nil t)

(provide 'my-lentic)

;; (require 'lentic-autoloads)
;; the requuire t does not work in ignoring errors
(ignore-errors (require 'lentic-autoloads nil t))

;; This is needed for python in markdown code blocks

;; https://github.com/phillord/lentic
