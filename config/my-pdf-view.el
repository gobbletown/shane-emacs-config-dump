(require 'pdf-view)

(advice-add 'pdf-view-check-incompatible-modes :around #'ignore-errors-around-advice)

(provide 'my-pdf-view)