(require 'hippie-exp)
(require 'hippie-exp-ext)

(remove-from-list 'hippie-expand-try-functions-list 'yas-hippie-try-expand)

(provide 'my-hippie-expand)