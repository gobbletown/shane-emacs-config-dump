;; TODO Make it so LSP records things which are later suggested
;; TODO I need to scrape the LSP documentation from the overlays and enter thing into a database for lookup
;; Do this now.
;; But where should I store this information?
;; I need to be storing in elasticsearch. Start this process.

(defset suggest-imports-tuples
  '((haskell-mode
     ("Printf" "import Text.Printf")
     ("runCommand" "import System.Process")
     ("floatLE" "import Data.ByteString.Builder")
     ("fold" "import Data.Foldable")
     ("exitFailure" "import System.Exit"))
    (python-mode
     ("defaultdict" "from collections import defaultdict")
     ("nlp" "import spacy")
     ("apriori" "from efficient_apriori import apriori"))))

(defun suggest-imports ()
  (interactive)
  (let ((i
         (-uniq
          (-flatten
           (cl-loop
            for tp in suggest-imports-tuples
            if (major-mode-p (car tp))
            collect
            (cl-loop
             for entry in (cdr tp)
             if (re-match-p (concat "\\b" (regexp-quote (car entry)) "\\b") (buffer-string))
             collect (cdr entry)))))))
    (if (called-interactively-p)
        (progn
          (if i
              (etv (list2str i))
            (message "No suggestions"))))))

(define-key global-map (kbd "H-!") 'suggest-imports)

(provide 'my-suggest-imports)