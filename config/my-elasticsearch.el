(require 'ob-elasticsearch)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((elasticsearch . t)))

(provide 'my-elasticsearch)