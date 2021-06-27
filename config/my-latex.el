(require 'ox-latex)

(setq org-latex-inputenc-alist '(("utf8" . "utf8x")))

(require 'zotelo)
(add-hook 'TeX-mode-hook 'zotelo-minor-mode)

(provide 'my-latex)