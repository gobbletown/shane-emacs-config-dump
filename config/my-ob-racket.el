(require 'ob-racket)
(require 'my-nix)

(provide 'my-ob-racket)

(org-babel-do-load-languages
      'org-babel-load-languages
      '((racket . t)))

(setq org-babel-racket-command (b. which racket))