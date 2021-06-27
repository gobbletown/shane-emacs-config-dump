;; This plugin was quite bad and broke emacs
;; (require 'thesaurus)

;; This one could also be good. It can accept any old thesaurus csv file
;; Disabled because I can't find it on melpa
;; (require 'synonyms)

;; This plugin was quite bad and broke emacs
;; (setq thesaurus-bhl-api-key "1c9bc2c18aceafe4df1e6cff74fcee6c")
;; optional key binding
;; (define-key global-map (kbd "C-x t") 'thesaurus-choose-synonym-and-replace)


;; via http://www.emacswiki.org/emacs/ThesauriAndSynonyms
;; The file names are absolute, not relative, locations
;;     - e.g. /foobar/mthesaur.txt.cache, not mthesaur.txt.cache
;; (use-package synonyms
;;   :ensure t ;; install package if not found
;;   :init     ;; executed before loading package
;;   (setq synonyms-file "~/.emacs.d/data/mthes10/mthesaur.txt")
;;   (setq synonyms-cache-file "~/.emacs.d/data/mycachefile")
;;   :config
;;   (defun my-synonym-current-word ()
;;     "Lookup synonyms for current word."
;;     (interactive)
;;     (synonyms-lookup (thing-at-point 'word) nil nil)))
;;   ;; :bind (:map my-map ("s" . my-synonym-current-word)))

(provide 'my-thesaurus)