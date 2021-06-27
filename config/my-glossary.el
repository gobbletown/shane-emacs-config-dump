;; e:$NOTES/ws/emacs/glossary-system/todo.org

;; j:insert-text-button
;; This function is like insert-button, except that the button is
;; actually part of the text instead of being a property of the buffer.
;; Creating large numbers of buttons can also be somewhat faster using
;; insert-text-button.

;; Properties are arbitrary things
;; (insert-button (propertize "dksjlf" 'yo "hi"))


;; TODO Make a bloom filter for each glossary
;; I could do that or I could turn the turples into a hash function


;; Glossary term tuple
;; -------------------
;; (path byteoffset term)

;; Glossary candidate term tuple
;; -----------------------------
;; (path byteoffset term)
;; path is the (get-path) of where the term was discovered -- useless
;; byteoffset -- unused

(require 'my-regex)
(require 'my-lists)

(require 'my-glossary-error)

;; Compute the topics first
(require 'my-computed-context)

(defvar glossary-keep-tuples-up-to-date t)

(defset glossary-max-lines-for-entire-buffer-gen 1000)
(defset glossary-overflow-chars 10000)
;; (defset glossary-overflow-chars 1000)
(defset glossary-idle-time 0.2)

(defvar glossary-files nil)

(defun glossary-window-start ()
  (max 1 (- (window-start) glossary-overflow-chars)))

(defun glossary-window-end ()
  (min (point-max) (+ (window-end) glossary-overflow-chars)))

;; (insert-text-button (propertize "dksjlf" 'yo "hi"))

;; Shy group (does not get a number)
;; \(?: ... \)
;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Regexp-Backslash.html#Regexp-Backslash

;; (let ((fg "#a73f5f")
;;       (bg "#331111"))

;;   (set-face-foreground 'annotate-annotation-secondary fg)
;;   (set-face-background 'annotate-annotation-secondary bg))

;; These maybe region predicates really only make sense for the glossary
;; So I'm unsure whether or not to move them to where the rest of the string predicates are defined
;; I may introduce even more logic, so keep them here
(defun ire-in-region-or-buffer-p (r)
  (if (use-region-p)
      (ire-in-region-p r)
    (ire-in-buffer-p r)))

(defun str-in-region-or-buffer-p (s)
  (if (use-region-p)
      (str-in-region-p s)
    (str-in-buffer-p s)))

(defun re-in-region-or-buffer-or-path-p (r)
  (if (use-region-p)
      (re-in-region-or-path-p r)
    (re-in-buffer-or-path-p r)))

(defun istr-in-region-or-buffer-or-path-p (s)
  (if (use-region-p)
      (istr-in-region-or-path-p s)
    (istr-in-buffer-or-path-p s)))

(defun istr-in-region-or-buffer-p (s)
  (if (use-region-p)
      (istr-in-region-p s)
    (istr-in-buffer-p s)))

(defun ire-in-region-or-buffer-or-path-p (r)
  (if (use-region-p)
      (ire-in-region-or-path-p r)
    (ire-in-buffer-or-path-p r)))

(defun ieat-in-region-or-buffer-or-path-p (s)
  (if (use-region-p)
      (ieat-in-region-or-path-p s)
    (ieat-in-buffer-or-path-p s)))


;; TODO Ensure that glossaries come from only one place, the glossaries directory
;; This will help to pr


;; TODO Ensure that a window of text is checked, not the entire buffer.
;; This would make the glossary system faster for large files, such as the KJV bible.
;; Combine logic with predicates. Have ONE top level predicate and a list of glossaries to add
(defset glossary-predicate-tuples
  ;; (mu `(((str-in-region-or-buffer-p "terraform")
  ;;        .
  ;;        ("$HOME/glossaries/terraform.txt"))
  ;;       ((ire-in-region-or-buffer-p "\\bAWS\\b")
  ;;        .
  ;;        ("$HOME/glossaries/aws.txt"))))

  ;; Don't use string-match-p because istr-match-in-buffer-p and co. dont throw errors. Use those instead

  (mu `(((or (re-in-region-or-buffer-or-path-p "\\bVault\\b")
             (re-in-region-or-buffer-or-path-p "\\bConsul\\b")
             (and (not (major-mode-p 'text-mode))
                  (istr-in-region-or-buffer-or-path-p "terraform"))
             (and (not (major-mode-p 'text-mode))
                  (ire-in-region-or-buffer-or-path-p "\\bvagrant\\b")))
         "$HOME/glossaries/hashicorp.txt"
         "$HOME/glossaries/terraform.txt")
        ((or (istr-in-region-or-buffer-p "French")
             (istr-in-region-or-buffer-p "france")
             (istr-match-p "French" (get-path nil t)))
         "$HOME/glossaries/french.txt"
         "$NOTES/ws/french/phrases.txt"
         "$NOTES/ws/french/glossary.txt")
        ((istr-in-region-or-buffer-p "fasttext")
         "$HOME/glossaries/fasttext.txt")
        ((or (str-in-region-or-buffer-p "consciousness")
             (str-in-region-or-buffer-p "Schrodinger"))
         "$HOME/glossaries/consciousness.txt"
         "$HOME/glossaries/general-ai-agi.txt")
        ((or (str-in-region-or-buffer-p "cryptocurrenc")
             (str-in-region-or-buffer-p "blockchain")
             (str-in-region-or-buffer-p "crypto")
             (str-in-region-or-buffer-p "bitcoin")
             (str-in-region-or-buffer-p "ethereum"))
         "$HOME/glossaries/cryptocurrencies.txt"
         "$HOME/glossaries/cryptography.txt")
        ((or (str-in-region-or-buffer-p "Schrodinger"))
         "$HOME/glossaries/quantum-mechanics.txt")
        ((or (istr-in-region-or-buffer-p "datomic"))
         "$HOME/glossaries/datomic.txt")
        ((or (str-in-region-or-buffer-p "localhost"))
         "$HOME/glossaries/ip-networking.txt")
        ((or (str-in-region-or-buffer-p "keras"))
         "$HOME/glossaries/keras.txt")
        ((or (str-in-region-or-buffer-p "terraform")
             (str-in-region-or-buffer-p "docker")
             (ire-in-region-or-buffer-p "\\bIaC\\b"))
         "$HOME/glossaries/iac-infrastructure-as-code.txt")
        ((or (ire-in-region-or-buffer-p "prolog"))
         "$HOME/glossaries/prolog.txt")
        ((or (ire-in-region-or-buffer-p "\\bnix"))
         "$HOME/glossaries/nix.txt")
        ((or
          (major-mode-p 'emacs-lisp-mode)
          (major-mode-p 'Info-mode))
         "$HOME/glossaries/emacs-lisp-elisp.txt")
        ((minor-mode-p my/lisp-mode)
         "$HOME/glossaries/lisp-based-languages.txt")
        ((or (ire-in-region-or-buffer-or-path-p "kubernetes")
             (ire-in-region-or-buffer-or-path-p "k8s"))
         "$HOME/glossaries/kubernetes.txt")
        ((or (istr-in-region-or-buffer-or-path-p "lotr")
             (istr-in-region-or-buffer-or-path-p "lord of the rings"))
         "$HOME/glossaries/lotr-lord-of-the-rings.txt")
        ((ire-in-region-or-buffer-or-path-p "docker")
         "$HOME/glossaries/docker.txt")
        ;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Window-Hooks.html
        ((ire-in-region-or-buffer-or-path-p "/elisp/")
         "$HOME/glossaries/emacs-lisp-elisp.txt")
        ((istr-in-region-or-buffer-or-path-p "clojure")
         "$HOME/glossaries/clojure.txt"
         "$HOME/glossaries/programming-language-theory.txt")
        ((and (ire-in-region-or-buffer-or-path-p "haskell")
              (not (major-mode-p 'emacs-lisp-mode)))
         "$HOME/glossaries/haskell.txt")
        ((or (ieat-in-region-or-buffer-or-path-p "AWS")
             (ieat-in-region-or-buffer-or-path-p "amazon"))
         "$HOME/glossaries/aws.txt")
        ((or (ieat-in-region-or-buffer-or-path-p "ethereum")
             (ieat-in-region-or-buffer-or-path-p "eth"))
         "$HOME/glossaries/ethereum.txt")
        ((or (ieat-in-region-or-buffer-or-path-p "transformer"))
         "$HOME/glossaries/transformer.txt")
        ((or (ieat-in-region-or-buffer-or-path-p "gpt")
             (ieat-in-region-or-buffer-or-path-p "openai"))
         "$HOME/glossaries/openai.txt"
         "$HOME/glossaries/transformer.txt"
         "$HOME/glossaries/gpt.txt")
        ((ire-in-region-or-buffer-or-path-p "\\bANSIBLE\\b")
         "$HOME/glossaries/ansible.txt")
        ((istr-in-region-or-buffer-or-path-p "Maigret")
         "$NOTES/ws/maigret/glossary.txt"
         "$NOTES/ws/french/words.txt")
        ((or (istr-in-region-or-buffer-or-path-p "mark forsyth")
             (istr-in-region-or-buffer-or-path-p "simulacra")
             (major-mode-p 'wordnut-mode))
         ,(glob "/home/shane/notes/ws/*/words.txt")
         ,(glob "/home/shane/notes/ws/*/phrases.txt")
         "$HOME/glossaries/english.txt")
        ;; ((or (string-match-p "/glossary.txt$" (get-path-nocreate))
        ;;      (string-match-p "/home/shane/glossaries/.*.txt$" (get-path-nocreate))
        ;;      (string-match-p "/home/shane/notes/ws/.*/words.txt$" (get-path-nocreate))
        ;;      (string-match-p "/home/shane/notes/ws/.*/phrases.txt$" (get-path-nocreate)))
        ;;  ,(glob "/home/shane/glossaries/*.txt"))

        ;; ((major-mode-p 'prog-mode)
        ;;  (let* ((lang (detect-language))
        ;;         (lang (cond ((string-equal "emacs-lisp" lang) "emacs-lisp-elisp")
        ;;                     (t lang)))
        ;;         (fp (concat "$HOME/glossaries/" lang ".txt")))
        ;;    (if (test-f fp)
        ;;        fp)))
        ((ieat-in-region-or-buffer-or-path-p "Myst")
         "$HOME/glossaries/myst.txt")
        ((or (istr-in-region-or-buffer-or-path-p "mitmproxy")
             (istr-in-region-or-buffer-or-path-p "Filter expressions"))
         "$HOME/glossaries/mitm.txt")
        ((or (istr-in-region-or-buffer-or-path-p "network")
             (istr-in-region-or-buffer-or-path-p "ifconfig"))
         "$HOME/glossaries/ip-networking.txt")
        ((or (istr-in-region-or-buffer-or-path-p "spacy"))
         "$HOME/glossaries/spacy.txt")
        ((or (istr-in-region-or-buffer-or-path-p "loom")
             (istr-in-region-or-buffer-or-path-p "laria"))
         "$HOME/glossaries/multiverse.txt")
        ((or (istr-in-region-or-buffer-or-path-p "learning")
             (istr-in-region-or-buffer-or-path-p "intelligence"))
         "$HOME/glossaries/artificial-intelligence-ai.txt")
        ((ire-in-region-or-buffer-or-path-p "\\bROS\\b") "$HOME/glossaries/ros.txt")
        ((or (istr-in-region-or-buffer-or-path-p "database")
             (istr-in-region-or-buffer-or-path-p "solr")
             (istr-in-region-or-buffer-or-path-p "elasticsearch")
             (ieat-in-region-or-buffer-or-path-p "kibana")
             (ieat-in-region-or-buffer-or-path-p "information retrieval")
             (ieat-in-region-or-buffer-or-path-p "SEO"))
         "$HOME/glossaries/nlp-natural-language-processing.txt"
         "$HOME/glossaries/transformer.txt"
         "$HOME/glossaries/information-retrieval.txt"
         "$HOME/glossaries/spacy.txt"
         "$HOME/glossaries/elk-elastic-search.txt"
         "$HOME/glossaries/seo-search-engine-optimisation.txt"
         "$HOME/glossaries/databases.txt")
        ((or (istr-in-region-or-buffer-or-path-p "natural language processing")
             (ieat-in-region-or-buffer-or-path-p "nlp")
             (istr-in-region-or-buffer-or-path-p "liguistic")
             (istr-in-region-or-buffer-or-path-p "embedding")
             (ieat-in-region-or-buffer-or-path-p "information retrieval"))
         "$HOME/glossaries/nlp-natural-language-processing.txt"
         "$HOME/glossaries/nlp-python.txt"
         "$HOME/glossaries/information-retrieval.txt"
         "$HOME/glossaries/seo-search-engine-optimisation.txt"
         "$HOME/glossaries/linguistics.txt"
         "$HOME/glossaries/prompt-engineering.txt"
         "$HOME/glossaries/language-acquisition.txt"
         "$HOME/glossaries/spoken-languages.txt"
         "$HOME/glossaries/databases.txt")
        ((or (istr-in-region-or-buffer-or-path-p "ENGLISH BIBLE")
             (istr-in-region-or-buffer-or-path-p "psalm")
             (istr-in-region-or-buffer-or-path-p "hebrew")
             (istr-in-region-or-buffer-or-path-p "King James"))
         "$HOME/glossaries/bible.txt"
         "$HOME/glossaries/bible-english.txt")
        ((or (ieat-in-region-or-buffer-or-path-p "ADV")
             (ieat-in-region-or-buffer-or-path-p "DET")
             (ieat-in-region-or-buffer-or-path-p "NOUN"))
         "$HOME/glossaries/nlp-natural-language-processing.txt")
        ((or (istr-in-region-or-buffer-or-path-p "relevance")
             (istr-in-region-or-buffer-or-path-p "retrieval")
             (istr-in-region-or-buffer-or-path-p "ranking")
             (ieat-in-region-or-buffer-or-path-p "IR"))
         "$HOME/glossaries/information-retrieval.txt"
         "$HOME/glossaries/information-ranking.txt")
        ((or (istr-in-region-or-buffer-or-path-p "inflect"))
         "$HOME/glossaries/linguistics.txt")
        ((or (istr-in-region-or-buffer-or-path-p "concurrency")
             (istr-in-region-or-buffer-or-path-p "agent")
             (istr-in-region-or-buffer-or-path-p "lock")
             (istr-in-region-or-buffer-or-path-p "mutex"))
         "$HOME/glossaries/concurrent-programming.txt")
        ((or (istr-in-region-or-buffer-or-path-p "Solr"))
         "$HOME/glossaries/solr.txt")
        ((or (istr-in-region-or-buffer-or-path-p "Random")
             (istr-in-region-or-buffer-or-path-p "probability")
             (istr-in-region-or-buffer-or-path-p "outcome")
             (istr-in-region-or-buffer-or-path-p "information")
             (istr-in-region-or-buffer-or-path-p "distribution"))
         "$HOME/glossaries/probability.txt"
         "$HOME/glossaries/data-science.txt"
         "$HOME/glossaries/statistics.txt")
        ((or (istr-in-region-or-buffer-or-path-p "classification")
             (istr-in-region-or-buffer-or-path-p "regression")
             (istr-in-region-or-buffer-or-path-p "model")
             (istr-in-region-or-buffer-or-path-p "computer vision"))
         "$HOME/glossaries/machine-learning.txt"
         "$HOME/glossaries/deep-learning.txt")
        ((or (istr-in-region-or-buffer-or-path-p "empirical"))
         "$HOME/glossaries/research.txt")
        ((or (istr-in-region-or-buffer-or-path-p "conditioning"))
         "$HOME/glossaries/reinforcement-learning.txt")
        ((or (istr-in-region-or-buffer-or-path-p "fixture"))
         "$HOME/glossaries/testing.txt")
        ((or (istr-in-region-or-buffer-or-path-p "Aragorn"))
         "$HOME/glossaries/lotr-lord-of-the-rings.txt")
        ((or (eat-in-buffer-or-path-p "ZooKeeper")
             (ieat-in-region-or-buffer-or-path-p "Apache")
             (ieat-in-region-or-buffer-or-path-p "tika"))
         "$HOME/glossaries/apache.txt")
        ((or (istr-in-region-or-buffer-or-path-p "Python")) "$HOME/glossaries/python.txt")
        ((or ;; (istr-in-region-or-buffer-or-path-p "expect")
          (istr-in-region-or-buffer-or-path-p "tcl")) "$HOME/glossaries/tcl.txt")
        ((or (istr-in-region-or-buffer-or-path-p "TypeScript")) "$HOME/glossaries/typescript.txt")
        ((or (istr-in-region-or-buffer-or-path-p "Dwarf Fortress")
             ;; Can't do this or LORT is full of symbols
             ;; (istr-in-region-or-buffer-or-path-p "Dwarf")
             )
         "$HOME/glossaries/dwarf-fortress.txt")
        ((or (istr-in-region-or-buffer-or-path-p "racket"))
         "$HOME/glossaries/racket.txt")
        ((or (ieat-in-region-or-buffer-or-path-p "Kotlin")) "$HOME/glossaries/kotlin.txt")
        ((or (ieat-in-region-or-buffer-or-path-p "git"))
         "$HOME/glossaries/git.txt")
        ((or (istr-in-region-or-buffer-or-path-p "Neural Network"))
         "$HOME/glossaries/deep-learning.txt")
        ((or (ieat-in-region-or-buffer-or-path-p "food")
             (ieat-in-region-or-buffer-or-path-p "cuisine")) "$HOME/glossaries/cooking.txt")
        ((or (istr-in-region-or-buffer-or-path-p "SQL"))
         "$HOME/glossaries/sql.txt")
        ((or (istr-in-region-or-buffer-or-path-p "sourcegraph"))
         "$HOME/glossaries/sourcegraph.txt"))))


(defun glossary-list-relevant-glossaries ()
  (append
   (cl-loop for fn in (list-all-glossary-files)
            when
            (istr-in-region-or-buffer-p (string-replace ".txt$" "" (basename fn)))
            collect fn)
   (-distinct
    (-flatten
     (cl-loop for tup in
              glossary-predicate-tuples
              collect
              (if (eval (car tup)) (cdr tup)))))))

(defun glossary-add-relevant-glossaries (&optional no-draw)
  (interactive)
  (add-glossaries-to-buffer (glossary-list-relevant-glossaries) no-draw)
  ;; (cl-loop for g in (glossary-list-relevant-glossaries) do (add-glossaries-to-buffer (list g)))
  ;; (dolist (g (glossary-list-relevant-glossaries))
  ;;   (add-glossaries-to-buffer (list g)))
  )

;; Not sure if this will work for pdfs which are opened as text files
;; (add-hook 'find-file-hooks 'glossary-add-relevant-glossaries t)

;; (remove-hook 'find-file-hooks 'glossary-add-relevant-glossaries t)


;; Make a list of tuples and list of glossaries thing, similar to context functions


(defsetface glossary-button-face
  '((t :foreground "#3fa75f"
       ;; It's better for the glossary buttons to have no background, so normal syntax things, such as LSP highlighting can still be visible
       ;; underline is enough
       ;; :background "#2e2e2e"
       :background nil
       :weight bold
       :underline t))
  "Face for glossary buttons.")

;; (defsetface glossary-candidate-button-face
;;   '((t ;; :foreground "#3f5fc7"
;;      :foreground nil
;;      :background "#000022"
;;      :weight bold
;;      :underline t))
;;   "Face for glossary candidate buttons.")

(defsetface glossary-candidate-button-face
  '((t
     :foreground "#3f5fc7"
     ;; :foreground nil
     ;; :background "#000022"
     :weight bold
     :underline t))
  "Face for glossary candidate buttons.")

(define-button-type 'glossary-button 'follow-link t 'help-echo "Click to go to definition" 'face 'glossary-button-face)
(define-button-type 'glossary-candidate-button 'follow-link t 'help-echo "Click to add to glossary" 'face 'glossary-candidate-button-face)

;; (defset glossary-term-3tuples (my-eval-string (sn (concat "list-glossary-terms-for-elisp " (q "$HOME/glossaries/abstract-algebra.txt")))))

;; (fz (seq-uniq (mapcar 'last glossary-term-3tuples) 'eq))

;; (fz (seq-uniq (mapcar 'last glossary-term-3tuples) 'eq))
;; "list-glossary-terms-for-elisp"


(defun my-show-overlays-here ()
  (interactive)
  (new-buffer-from-string (pp (cl-loop for o in (overlays-at (point)) collect (sp--get-overlay-text o)))))

;; (cl-loop for o in (overlays-at (point)) collect (button-get o 'glossarypath))
(defun my-show-button-paths-here ()
  (interactive)
  (new-buffer-from-string (pp (glossary-get-button-3-tuples-at (point)))))

;; (-reduce 'gnus-and '(1 2 3))
;; (apply 'gnus-and '(1 2 3))
;; (apply 'gnus-and '(nil 2 3))
(defun glossary-get-button-3-tuples-at (p)
  (interactive (list (point)))
  (-filter
   (l (tp)
     ;; (reduce 'gnus-and tp)
     (apply 'gnus-and tp)
     ;; (gnus-and tp)
     )
   (cl-loop
    for
    o
    in
    (overlays-at p)
    collect
    (list
     (button-get o 'glossarypath)
     (button-get o 'byteoffset)
     (button-get o 'term)))))

;; (defset glossary-overlays-var-tmp nil)
;; (defun set-glossary-overlays-var-tmp ()
;;   (interactive)
;;   (setq glossary-overlays-var-tmp (cl-loop
;;                                    for
;;                                    o
;;                                    in
;;                                    (overlays-at (point))
;;                                    collect
;;                                    (list
;;                                     (button-get o 'glossarypath)
;;                                     (button-get o 'byteoffset)
;;                                     (button-get o 'term)))))

(defset glossary-blacklist
  (s-split " " "The the and in or OR IN to TO"))

(defun glossary-list-tuples (&optional fp)
  (-filter (l (e) (not (member (third e) glossary-blacklist)))
           (glossary-sort-tuples
            (if fp
                (my-eval-string (sn (concat "list-glossary-terms-for-elisp " (q fp))))
              (my-eval-string (sn "list-glossary-terms-for-elisp"))))))

;; Doesn't speed things up
;; (memoize 'glossary-list-tuples)
;; (memoize-restore 'glossary-list-tuples)

(defun glossary-sort-tuples (tuples)
  (sort
   tuples
   (lambda (e1 e2) (< (length (third e1))
                      (length (third e2))))))

;; I don't think sorting makes much of a difference
(defset glossary-term-3tuples (glossary-list-tuples))
;; This is always global, where the above is only sometimes global
(defset glossary-term-3tuples-global glossary-term-3tuples)

(defset glossary-candidate-3tuples nil)
;; (unset-variable 'glossary-term-3tuples)
;; (delete-file-local-variable 'glossary-term-3tuples)

(defun recalculate-glossary-3tuples ()
  (interactive)
  (defset-local glossary-term-3tuples (-distinct (flatten-once (cl-loop for fp in glossary-files collect (glossary-list-tuples fp))))))

(defun glossary-reload-term-3tuples ()
  (interactive)
  ;; This is meant to set it globally
  (defset glossary-term-3tuples (glossary-list-tuples))
  (defset glossary-term-3tuples-global glossary-term-3tuples))

;; (setq )
;; (glossary-word-3tuples (my-eval-string (sn (concat "list-glossary-terms-for-elisp " (q "$HOME/glossaries/abstract-algebra.txt")))))
;; (let ((glossary-word-3tuples (my-eval-string (sn (concat "list-glossary-terms-for-elisp " (q "$HOME/glossaries/abstract-algebra.txt"))))))
;;   (tv (list2str (mapcar 'car glossary-word-3tuples))))

                                        ; grep --byte-offset --with-filename -oP "^[a-zA-Z0-9]+[a-zA-Z0-9 ]+$" compilers.txt

;; TODO Make a '() list' of 3-tuples from parsing the glossaries with an external script:
;; term, path, byte position.
;; grep --byte-offset --with-filename -oP "^[a-zA-Z0-9]+[a-zA-Z0-9 ]+$" compilers.txt
;; I could do this in emacs lisp initially.

;; TODO Make a binding to delete all buttons

;; (defun make-buttons-for-glossary-terms (glossaryfile beg end)
;;   "Makes buttons for glossary terms found in this buffer."
;;   (interactive "sGlossary file path: \nr"))



(defset glossary-button-map
  (let ((map (make-sparse-keymap)))
    ;; The following definition needs to avoid usijng escape sequences that
    ;; might get converted to ^M when building loaddefs.el
    (define-key map [(control ?m)] 'push-button)
    ;; (define-key map [mouse-2] 'push-button)
    ;; mouse-2 is single click, double-mouse-1 is double-click
    (define-key map [double-mouse-1] 'push-button)
    ;; FIXME: You'd think that for keymaps coming from text-properties on the
    ;; mode-line or header-line, the `mode-line' or `header-line' prefix
    ;; shouldn't be necessary!
    (define-key map [mode-line mouse-2] 'push-button)
    (define-key map [header-line mouse-2] 'push-button)
    map)
  "Keymap used by buttons.")

;; Pretty quick actually
(defun create-buttons-for-term (term beg end &optional glossarypath byteoffset buttontype)
  "Adds glossary buttons for Term in in beg/end region.
Go through a buffer in search of a term and create buttons for all instances
Use my position list code. Make it use rosie lang and external software."
  (interactive "sTerm: \nr")
  (if (not buttontype)
      (setq buttontype 'glossary-button))

  ;; (if mark-active
  ;;     (setq deactivate-mark t)
  ;;   ;; (setq beg
  ;;   ;;                 100
  ;;   ;;                 end
  ;;   ;;                 1000)
  ;;   (if (not beg)
  ;;       (let ((nlines (count-lines (point-min) (point-max))))
  ;;         (if (> nlines glossary-max-lines-for-entire-buffer-gen)
  ;;             (progn
  ;;               ;; (ns "hi")
  ;;               (setq beg
  ;;                     (glossary-window-start)
  ;;                     end
  ;;                     (glossary-window-end)))
  ;;           (setq beg
  ;;                 (point-min)
  ;;                 end
  ;;                 (point-max))))))
  (goto-char beg)
  ;; (message (concat "beg " (str beg)))
  (let ((pat
         (concat
          "\\(\\b\\|[. ']\\|^\\)"
          ;; Here, replace the ' ' spaces in term with \\s+
          (regexp-quote term)
          ;; The apostrophe is when I have a possessive (Gehn's)
          "s?\\(\\b\\|[. ']\\|$\\)")
         ;; (if (ire-match-p "^[a-z_].*[a-z1-9_]$" term)
         ;;     (concat
         ;;      "\\(\\b\\|^\\|'\\)"
         ;;      (regexp-quote term)
         ;;      ;; The apostrophe is when I have a possessive (Gehn's)
         ;;      "s?\\(\\b\\|$\\|'\\)")
         ;;   (concat
         ;;    "\\(^\\| \\|'\\)"
         ;;    (regexp-quote term)
         ;;    ;; The apostrophe is when I have a possessive (Gehn's)
         ;;    "s?\\($\\| \\|'\\)"))
         ))
    ;; (message pat)
    ;; (re-search-forward "\\(^\\| \\|'\\)iso-25010s?\\($\\| \\|'\\)" (window-end) t)
    (while (re-search-forward pat end t)
      (progn
        ;; Remove the regex at point here
        ;; Put the button here
                                        ; (replace-match "" t t)
        ;; (insert-text-button
        ;; It's modifying the buffer, which is bad.
        ;; It operates on org-mode, which is bad.
                                        ; (insert-text-button
        (let ((contents (match-string 0))
              (beg (match-beginning 0))
              (end (match-end 0)))
          (make-button
           ;; (match-beginning 0)
           (if (string-match "^[ '.].*" contents)
               (+ beg 1)
             beg)
           ;; I must manually remove the ', if it was matched, because there is no lookahead
           (if (string-match ".*[' .]$" contents)
               (- end 1)
             end)
           ;; (propertize term 'face 'bold)
           'term term
           'keymap glossary-button-map
           'glossarypath glossarypath
           'byteoffset byteoffset
           'action (if (eq buttontype 'glossary-candidate-button)
                       'glossary-candidate-button-pressed
                     'glossary-button-pressed)
           'type buttontype))))))


;; Pretty quick actually
(defun make-buttons-for-glossary-terms (beg end &optional 3tuples buttontype)
  "Makes buttons for glossary terms found in this buffer."
  (interactive "r")
  (if (not buttontype)
      (setq buttontype 'glossary-button))

  (if (not 3tuples)
      (setq 3tuples
            (cond
             ((eq buttontype 'glossary-button) glossary-term-3tuples)
             ((eq buttontype 'glossary-candidate-button) glossary-candidate-3tuples))))

  (if ;; (or (not mark-active) (not beg))
      (not beg)
      (let ((nlines (count-lines (point-min) (point-max))))
        (if (> nlines glossary-max-lines-for-entire-buffer-gen)
            (progn
              ;; (message "make-buttons-for-glossary-terms")
              (setq beg
                    (glossary-window-start)
                    end
                    (glossary-window-end)))
          (setq beg
                (point-min)
                end
                (point-max)))))
  (cl-loop for termtuple in 3tuples do
           (create-buttons-for-term (third termtuple) beg end
                                    (first termtuple)
                                    (second termtuple)
                                    buttontype)))

;; TODO Do this without position list navigation first
;; Search for the term literally, with word boundaries either side
;; TODO Make it generic with position list navigation. Position list navigation is currently buggy. This has to work perfectly.

(defun goto-byte (byteoffset)
  (interactive "nByte position: ")
  ;; TODO Ensure that this also factors in dos line endings
  (goto-char (byte-to-position (+ byteoffset 1))))

(defun glossary-candidate-button-pressed (button)
  "When I press a glossary button, it should take me to the definition"
  (let* (;; (term (button-get button 'term))
         (term (button-get-text button))
         (byteoffset (button-get button 'byteoffset))
         (start (button-start button))
         (glossarypath (button-get button 'glossarypath))
         (buttons-here (glossary-get-button-3-tuples-at start)))

    (if (< 1 (length buttons-here))
        (let* ((button-line (umn (fz (mnm (pp-map-line buttons-here)))))
               (button-tuple (if button-line
                                 (my-eval-string (concat "'" button-line))))
               (selected-button (if button-tuple
                                    (car (-filter (l (li) (and (equal (first button-tuple) (button-get li 'glossarypath))
                                                               (equal (second button-tuple) (button-get li 'byteoffset))
                                                               (equal (third button-tuple) (button-get li 'term))))
                                                  (overlays-at start))))))
          (if selected-button
              (progn
                ;; (ns "hi")
                (setq button selected-button)
                (setq term (button-get-text button))
                ;; (setq term (button-get button 'term))
                (setq byteoffset (button-get button 'byteoffset))
                (setq start (button-start button))
                (setq glossarypath (button-get button 'glossarypath))
                (setq buttons-here (glossary-get-button-3-tuples-at byteoffset)))
            ;; Cancelling fz seems to move forward 1 char
            (backward-char))))
    (cond
         ((equal current-prefix-arg (list 4)) (setq current-prefix-arg nil))
         ((not current-prefix-arg) (setq current-prefix-arg (list 4))))
    (with-current-buffer
        (add-to-glossary-file-for-buffer term nil (sn "oc" glossarypath)))))


(defun glossary-button-pressed (button)
  "When I press a glossary button, it should take me to the definition"
  ;; Get some properties of the button
  (let* ((term (button-get button 'term))
         (byteoffset (button-get button 'byteoffset))
         (start (button-start button))
         (glossarypath (button-get button 'glossarypath))
         (buttons-here (glossary-get-button-3-tuples-at start))
         ;; (beginning       (button-get button 'beginning))
         ;; (ending          (button-get button 'ending))
         ;; (begin-of-button (button-get button 'begin-of-button))
         ;; (end-of-button   (button-get button 'end-of-button))
         )

    ;; (fz (pp-map-line (glossary-get-button-3-tuples-at (point))))

    ;; TODO Fix how the overlays double up
    (if (< 1 (length buttons-here))
        (let* ((button-line (umn (fz (mnm (pp-map-line buttons-here)))))
               (button-tuple (if button-line
                                 (my-eval-string (concat "'" button-line))))
               (selected-button (if button-tuple
                                    (car (-filter (l (li) (and (equal (first button-tuple) (button-get li 'glossarypath))
                                                               (equal (second button-tuple) (button-get li 'byteoffset))
                                                               (equal (third button-tuple) (button-get li 'term))))
                                                  (overlays-at start)
                                                  ;; (glossary-get-button-3-tuples-at start)
                                                  )))))
          (if selected-button
              (progn
                ;; (ns "hi")
                (setq button selected-button)
                (setq term (button-get button 'term))
                (setq byteoffset (button-get button 'byteoffset))
                (setq start (button-start button))
                (setq glossarypath (button-get button 'glossarypath))
                (setq buttons-here (glossary-get-button-3-tuples-at byteoffset)))
            ;; Cancelling fz seems to move forward 1 char
            (backward-char))))
    (with-current-buffer
        (if (>= (prefix-numeric-value current-prefix-arg) 4)
            (find-file-other-window glossarypath)
          (find-file glossarypath))
      (goto-byte byteoffset)
      ;; (redraw-glossary-buttons-when-window-scrolls-or-file-is-opened)
      ;; (run-hooks 'find-file-hook)
      )
    ;; (ns (concat term " " (str byteoffset) " " glossarypath))

    ;; (progn-read-only-disable
    ;;  (save-excursion
    ;;    (button-put button 'invisible t)
    ;;    (let ((annotation-button (previous-button (point))))
    ;;      (button-put annotation-button 'face '(:strike-through t)))
    ;;    (let ((replace-button (next-button (point))))
    ;;      (button-put replace-button 'invisible t))))
    ))

;; (add-hook 'text-mode-hook 'make-buttons-for-glossary-terms)
;; (remove-hook 'text-mode-hook 'make-buttons-for-glossary-terms)

;; (add-hook 'text-mode-hook (lm (ns "yo")))

(defun reload-glossary-and-generate-buttons (beg end)
  (interactive "r")
  (glossary-reload-term-3tuples)
  (generate-glossary-buttons-over-buffer beg end t))

(defun reload-glossary-reopen-and-generate-buttons (beg end)
  "DEPRECATED"
  (interactive "r")
  (glossary-reload-term-3tuples)
  (kill-buffer-and-reopen)
  (generate-glossary-buttons-over-buffer beg end))

;; (defun dedup-glossary-term-3tuples ()
;;   (setq glossary-term-3tuples (-distinct glossary-term-3tuples)))

;; TODO Make a function for removing all glossary buttons


(defun button-get-text (b)
  ;; A button may be an overlay or just text with properties
  (if b
      (buffer-substring (button-start b) (button-end b)))
  ;; (if (overlayp b)
  ;;     (buffer-substring (overlay-start o) (overlay-end o))
  ;;   )
  )

;; (sp--get-overlay-text (button-at (point)))
;; (defalias 'button-get-text 'sp--get-overlay-text)

(defun list-glossary-files ()
  (str2lines ;; (cl-sn "find $HOME/glossaries -name '*.txt' -type f -o -type l" :chomp t)
   ;; (cl-sn "cd $HOME/glossaries; F fng | sed \"s=^=$HOME/glossaries/=\"" :chomp t)
   (cl-sn "list-glossary-files" :chomp t)))
(defalias 'list-all-glossary-files 'list-glossary-files)

(defun other-glossaries-not-added-yet ()
  (let ((all-glossary-files (list-glossary-files)))
    (if (and (local-variable-p 'glossary-files) glossary-files)
        (-difference
         all-glossary-files
         glossary-files)
      all-glossary-files)))

;; (qtvd (other-glossaries-not-added-yet))



(defun get-keyphrases-for-buffer (beg end)
  (interactive "r")
  ;; (str2lines (cl-sn "extract-keyphrases" :stdin (buffer-string) :chomp t))

  (-filter-not-empty-string
   (let ((s
          ;; (buffer-string)
          (buffer-substring (glossary-window-start)
                            (glossary-window-end))
          ;; (buffer-substring (window-start)
          ;;                   (window-end))
          ))
     (str2lines (cl-sn "extract-keyphrases" :stdin s :chomp t)))))

(defun recalculate-glossary-candidate-3tuples (beg end)
  (interactive "r")
  (let* ((p (mnm (get-path-nocreate)))
         (tls (mapcar
               (lambda (s) (list p nil s))
               (-distinct
                (if glossary-term-3tuples
                    (let ((tl (mapcar 'downcase (mapcar 'third glossary-term-3tuples))))
                      (-filter
                       (lambda (s) (not (-contains? tl (downcase s))))
                       (get-keyphrases-for-buffer beg end)))
                  (get-keyphrases-for-buffer beg end))
                ;; (flatten-once (cl-loop for fp in glossary-files collect (glossary-list-tuples fp)))
                ))))
    (if (not (use-region-p))
        (defset-local glossary-candidate-3tuples tls))
    tls))

(defun draw-glossary-buttons-and-maybe-recalculate (beg end &optional recalculate-tuples)
  (interactive "r")

  ;; This is for the entire buffer

  ;; I'm not sure what is triggering dired to render the glossary
  (if (not (or (major-mode-p 'dired-mode)
               (major-mode-p 'compilation-mode)
               (string-equal (buffer-name) "*button cloud*")
               (re-match-p (buffer-name) "^\\*untitled")))
      (progn
        ;; This takes a long time for big glossaries
        (if (or
             recalculate-tuples
             (not (local-variable-p 'glossary-term-3tuples))
             ;; I can't be bothered figuring out why 'glossary-term-3tuples is being created as a local variable in eww
             (major-mode-p 'eww-mode))
            (progn
              (recalculate-glossary-3tuples)
              (recalculate-glossary-error-3tuples)))

        (if (and
             (myrc-test "glossary_suggest_keyphrases")
             ;; Only draw suggestions if in eww, text or sx
             (or
              (major-mode-p 'eww-mode)
              (major-mode-p 'text-mode)
              (major-mode-p 'org-brain-visualize-mode)
              (major-mode-p 'sx-question-mode))
             ;; yaml-mode is a text mode
             (not (major-mode-p 'yaml-mode)))
            (recalculate-glossary-candidate-3tuples beg end))

        (gl-beg-end
         (progn
           (make-buttons-for-glossary-terms
            gl-draw-start
            gl-draw-end)
           (make-buttons-for-glossary-terms
            gl-draw-start
            gl-draw-end
            glossary-candidate-3tuples
            'glossary-candidate-button)
           (make-buttons-for-glossary-terms
            gl-draw-start
            gl-draw-end
            glossary-error-term-3tuples
            'glossary-error-button))))))

(defun append-glossary-files-locally (fps)
  ;; relevant-glossaries should override glossary-files when set
  ;; It's meant for the region, not the buffer
  (if (local-variable-p 'glossary-files)
      (defset-local glossary-files (-union glossary-files fps))
    (defset-local glossary-files fps)))

;; (add-glossaries-to-buffer (list "/home/shane/glossaries/lotr-lord-of-the-rings.txt"))
(defun add-glossaries-to-buffer (fps &optional no-draw)
  (interactive (list (-filter-not-empty-string (str2lines (umn ;; (fzf-m (list2str (other-glossaries-not-added-yet)))
                                                           (fz (mnm (list2str (other-glossaries-not-added-yet)))))))
                     ;; (str2lines (umn (mfz-m (mnm ;; (b find $HOME/notes/ws/glossaries -type f -o -type l)
                     ;;                 (b find $HOME/glossaries -type f -o -type l)))))
                     ))
  (if fps
      (save-excursion
        (progn
          (append-glossary-files-locally fps)

          ;; (if (and (local-variable-p 'glossary-files) glossary-files)
          ;;     (defset-local glossary-term-3tuples (flatten-once (cl-loop for fp in glossary-files collect (glossary-list-tuples fp))))
          ;;   )

          ;; Ensure they are uniqued
          ;; (if (local-variable-p 'glossary-term-3tuples)
          ;;     (setq glossary-term-3tuples (-distinct glossary-term-3tuples)))
          ;; The global list may also need uniqifying
          ;; (setq glossary-term-3tuples (-distinct glossary-term-3tuples))

          (if (not no-draw)
              (draw-glossary-buttons-and-maybe-recalculate nil nil))))))

(defun test-f (fp)
  (eq (progn (sh-notty (concat "test -f " (q fp)))
             (string-to-int b_exit_code))
      0))

(defun test-d (fp)
  (eq (progn (sh-notty (concat "test -d " (q fp)))
             (string-to-int b_exit_code))
      0))

(defun glossary-path-p (&optional fp)
  (if (not fp)
      (setq fp (get-path-nocreate)))
  (if fp
      (or (re-match-p "/glossary.txt$" fp)
          (re-match-p "glossaries/.*\\.txt$" fp)
          (re-match-p "/home/shane/notes/ws/.*/words.txt$" fp)
          (re-match-p "/home/shane/notes/ws/.*/phrases.txt$" fp))))


(defset glossary-imenu-generic-expression
  '(("" "^\\([a-zA-Z0-9].+\\)$" 1)))
(defun glossary-imenu-configure ()
  (interactive)
  (if (glossary-path-p)
      (setq imenu-generic-expression glossary-imenu-generic-expression)))
(add-hook 'text-mode-hook 'glossary-imenu-configure)



(defun button-imenu ()
  (interactive)
  (let ((imenu-create-index-function #'button-cloud-create-imenu-index))
    (helm-imenu)))
(defalias 'glossary-button-imenu 'button-imenu)

(defun byte-to-marker (byte)
  (set-marker (make-marker) byte))


(defun generate-glossary-buttons-over-region (beg end &optional clear-first force)
  (interactive "r")

  (message "(generate-glossary-buttons-over-region)")

  ;; TODO Use language detection

  ;; (message "(generate-glossary-buttons-over-region)")

  ;; TODO Make it so suggested words are just another lexicon

  (if glossary-keep-tuples-up-to-date
      (glossary-reload-term-3tuples))

  (if (not (use-region-p))
      (generate-glossary-buttons-over-buffer beg end clear-first force)
    (progn
      (if clear-first (remove-glossary-buttons-over-region beg end))

      ;; Make these lexically local
      (let ((glossary-files)
            (glossary-error-files))
        (glossary-add-relevant-glossaries t)
        (glossary-error-add-relevant-glossaries t)
        (save-excursion
          ;; glossary-files

          ;; Perhaps, select a lexicon here

          (let ((glossary-files
                 (mu '("$NOTES/ws/english/words.txt"))
                 ;; nil
                 ;; calculate glossary files
                 )
                (glossary-error-files nil
                                      ;; calculate glossary error files
                                      ))
            (mylog (draw-glossary-buttons-and-maybe-recalculate beg end))))))))

(defun generate-glossary-buttons-over-buffer-around-advice (proc &rest args)
  (let ((res (apply proc args)))
    res))
(advice-add 'generate-glossary-buttons-over-buffer :around #'generate-glossary-buttons-over-buffer-around-advice)
(advice-remove 'generate-glossary-buttons-over-buffer #'generate-glossary-buttons-over-buffer-around-advice)

(defun generate-glossary-buttons-over-buffer (beg end &optional clear-first force)
  (interactive "r")

  (message "(generate-glossary-buttons-over-buffer)")

  ;; (message "(generate-glossary-buttons-over-buffer)")

  (if force (defset-local glossary-force-on t))

  (if (use-region-p)
      (generate-glossary-buttons-over-region beg end clear-first force)
    (unless (or
             (string-equal (get-path-nocreate) "/home/shane/var/smulliga/source/git/config/emacs/config/my-glossary.el")
             (and (not (myrc-test "auto_glossary_enabled"))
                  (not (and (variable-p 'glossary-force-on) glossary-force-on))))

      ;; (message "hi")
      ;; This actually makes it appear not seamless. Not worth fixing
      (if clear-first (remove-all-glossary-buttons))

      (glossary-add-relevant-glossaries t)
      (glossary-error-add-relevant-glossaries t)
      (save-excursion
        (if (or (and (variable-p 'glossary-force-on) glossary-force-on)
                (not (or (major-mode-p 'org-modmfse)
                         (major-mode-p 'outline-mode)
                         (string-equal (buffer-name) "*glossary cloud*"))))

            (progn
              (mu (cond ((major-mode-p 'python-mode)
                         (progn
                           (append-glossary-files-locally (list "$HOME/glossaries/python.txt"
                                                                "$HOME/glossaries/tensorflow.txt"
                                                                "$HOME/glossaries/nlp-python.txt"
                                                                "$HOME/glossaries/onnx.txt"
                                                                "$HOME/glossaries/deep-learning.txt"
                                                                "$HOME/glossaries/nlp-natural-language-processing.txt"))
                           ;; (defset-local glossary-files (mu (list "$HOME/glossaries/python.txt"
                           ;;                                        "$HOME/glossaries/tensorflow.txt"
                           ;;                                        "$HOME/glossaries/pytorch.txt"
                           ;;                                        "$HOME/glossaries/onnx.txt"
                           ;;                                        "$HOME/glossaries/deep-learning.txt"
                           ;;                                        "$HOME/glossaries/nlp-natural-language-processing.txt")))
                           ;; (defset-local glossary-term-3tuples (flatten-once (cl-loop for fp in glossary-files collect (glossary-list-tuples fp))))
                           ;; (defset-local glossary-term-3tuples (nconc (glossary-list-tuples "$HOME/glossaries/tensorflow.txt")
                           ;;                                            (glossary-list-tuples "$HOME/glossaries/pytorch.txt")
                           ;;                                            (glossary-list-tuples "$HOME/glossaries/python.txt")
                           ;;                                            (glossary-list-tuples "$HOME/glossaries/deep-learning.txt")
                           ;;                                            (glossary-list-tuples "$HOME/glossaries/nlp-natural-language-processing.txt")))
                           ))
                        ((and (major-mode-p 'text-mode)
                              (stringp (get-path-nocreate))
                              (let* ((fp (get-path-nocreate))
                                     (bn (basename fp))
                                     (dn (f-dirname fp))
                                     (ext (file-name-extension bn))
                                     (mant (file-name-sans-extension bn))
                                     (pdf-fp (concat dn "/" mant ".pdf"))
                                     (PDF-fp (concat dn "/" mant ".PDF")))
                                (or (test-f pdf-fp)
                                    (test-f PDF-fp))))
                         (progn
                           ;; (ns "using pdf glossary")
                           (let ((glossary-fp (concat (f-dirname (get-path-nocreate)) "/glossary.txt")))
                             (append-glossary-files-locally (list glossary-fp))
                             ;; (defset-local glossary-files (list glossary-fp))
                             ;; (defset-local glossary-term-3tuples (nconc (glossary-list-tuples glossary-fp)
                             ;;                                            ;; (glossary-list-tuples glossary-fp)
                             ;;                                            ))
                             )
                           ;; For each glossary? Nah. Just hardcode it
                           ;; (let ((bs (buffer-string)))
                           ;;   (mu (if (string-match-p "clojure" bs)
                           ;;           (add-glossaries-to-buffer (list "$HOME/glossaries/clojure.txt")))
                           ;;       (if (string-match-p "aws" bs)
                           ;;           (add-glossaries-to-buffer (list "$HOME/glossaries/aws.txt")))))
                           ))
                        ((and (get-path-nocreate)
                              (let* ((fp (get-path-nocreate))
                                     (bn (basename fp))
                                     (dn (f-dirname fp))
                                     (dnbn (basename dn))
                                     (ext (file-name-extension bn))
                                     (mant (file-name-sans-extension bn)))
                                (or (and (string-equal dnbn "glossaries")
                                         (major-mode-p 'text-mode))
                                    (string-equal bn "glossary.txt"))))
                         (append-glossary-files-locally (list (get-path-nocreate))))
                        ((major-mode-p 'prog-mode)
                         (let* ((lang (detect-language))
                                (lang (cond ((string-equal "emacs-lisp" lang) "emacs-lisp-elisp")
                                            (t lang)))
                                (fp (concat "$HOME/glossaries/" lang ".txt")))
                           (if ;; (bq test -f  fp)
                               (test-f fp)
                               (append-glossary-files-locally (list fp))
                             ;; (defset-local glossary-term-3tuples (glossary-list-tuples fp))
                             )))
                        ;; ((string-match-p "HaskellBook" (get-path-nocreate))
                        ;;  (progn
                        ;;    (defset-local glossary-files (list (umn "$HOME/glossaries/haskell.txt")))
                        ;;    (defset-local glossary-term-3tuples (glossary-list-tuples "$HOME/glossaries/haskell.txt"))))
                        ((str-match-p "Lord of the Rings" (get-path-nocreate))
                         (progn
                           (append-glossary-files-locally (list "$HOME/glossaries/lotr-lord-of-the-rings.txt"))
                           ;; (defset-local glossary-files (list (umn "$HOME/glossaries/lotr-lord-of-the-rings.txt")))
                           ;; (defset-local glossary-term-3tuples (glossary-list-tuples "$HOME/glossaries/lotr-lord-of-the-rings.txt"))
                           ))

                        ;; Not sure why I had this
                        ;; ((or (string-match-p "/glossary.txt$" (get-path-nocreate))
                        ;;      (string-match-p "/home/shane/glossaries/.*\.txt$" (get-path-nocreate))
                        ;;      (string-match-p "/home/shane/notes/ws/.*/words.txt$" (get-path-nocreate))
                        ;;      (string-match-p "/home/shane/notes/ws/.*/phrases.txt$" (get-path-nocreate)))
                        ;;  ;; (ns "unset")
                        ;;  (unset-variable 'glossary-files t)
                        ;;  (unset-variable 'glossary-term-3tuples t))

                        (
                         (glossary-path-p (get-path-nocreate))
                         ;; (or (str-match-p "/glossary.txt$" (get-path-nocreate))
                         ;;     (str-match-p "/home/shane/glossaries/.*\\.txt$" (get-path-nocreate))
                         ;;     (str-match-p "/home/shane/notes/ws/.*/words.txt$" (get-path-nocreate))
                         ;;     (str-match-p "/home/shane/notes/ws/.*/phrases.txt$" (get-path-nocreate)))
                         (append-glossary-files-locally (list (get-path-nocreate))))

                        ;; (t
                        ;;  (progn
                        ;;    (append-glossary-files-locally (list (umn "$HOME/glossaries/english.txt")))
                        ;;    ;; (defset-local glossary-files (list (umn "$HOME/glossaries/english.txt")))
                        ;;    ;; (defset-local glossary-term-3tuples (glossary-list-tuples "$HOME/glossaries/english.txt"))
                        ;;    ))
                        ))

              ;; (message "generate-glossary-buttons-over-buffer")

              ;; (setq glossary-term-3tuples (-take 100 glossary-term-3tuples))

              (draw-glossary-buttons-and-maybe-recalculate beg end)
              ;; (if (< (length glossary-term-3tuples) 1000)
              ;;     (draw-glossary-buttons-and-maybe-recalculate))
              ;; (make-buttons-for-glossary-terms
              ;;  (point-min)
              ;;  (point-max))
              ))))))
;; (message "glossary buttons generated")


(defmacro gl-beg-end (&rest body)
  `(let* ((gl-beg (if (selectionp)
                      (min (point) (mark))
                    (point-min)))
          (gl-end (if (selectionp)
                      (max (point) (mark))
                    (point-max)))
          (nlines (count-lines gl-beg gl-end))
          (gl-use-sliding-window (> nlines glossary-max-lines-for-entire-buffer-gen))
          (gl-draw-start (or
                          gl-beg
                          (if gl-use-sliding-window
                              (glossary-window-start)
                            (point-min))))
          (gl-draw-end (or
                        gl-end
                        (if gl-use-sliding-window
                            (glossary-window-end)
                          (point-max)))))
     (progn
       ,@body)))

(defun generate-glossary-buttons-manually ()
  (interactive)

  (if (major-mode-p 'term-mode)
      (with-current-buffer
          (new-buffer-from-tmux-pane-capture t)
        (generate-glossary-buttons-manually))
    (gl-beg-end
     (if (use-region-p)
         (generate-glossary-buttons-over-region gl-beg gl-end nil t)
       (generate-glossary-buttons-over-buffer gl-end gl-end nil t)))))


;;; Annoyingly, I can't automatically run the glossary for the brain visualizer
;;; I don't want to anyway as it would get in the way of existing buttons.
;; (defun org-brain-visualize-around-advice (proc &rest args)
;;   (let ((res (apply proc args)))
;;     (a/beep)
;;     (redraw-glossary-buttons-when-window-scrolls-or-file-is-opened)
;;     res))
;; (advice-add 'org-brain-visualize :around #'org-brain-visualize-around-advice)
;; (advice-remove 'org-brain-visualize #'org-brain-visualize-around-advice)
;; (add-hook 'org-brain-after-visualize-hook 'redraw-glossary-buttons-when-window-scrolls-or-file-is-opened t)
;; (add-hook 'org-brain-visualize-follow-hook 'redraw-glossary-buttons-when-window-scrolls-or-file-is-opened t)
;; (remove-hook 'org-brain-visualize-follow-hook 'redraw-glossary-buttons-when-window-scrolls-or-file-is-opened)
;; (remove-hook 'org-brain-after-visualize-hook 'redraw-glossary-buttons-when-window-scrolls-or-file-is-opened)
;; (remove-hook 'org-brain-visualize-mode-hook 'redraw-glossary-buttons-when-window-scrolls-or-file-is-opened)

(defun wordnut--lookup-around-advice (proc &rest args)
  (let ((res (apply proc args)))
    (run-buttonize-hooks)
    res))
(advice-add 'wordnut--lookup :around #'wordnut--lookup-around-advice)
;; (advice-remove 'wordnut--lookup #'wordnut--lookup-around-advice)

;; Adding directly to the text hook made emacsclient unable to open after a restart
(defun after-emacs-loaded-add-hooks-for-glossary ()
  ;; This is what triggers the glossary in text-mode, but not in dired-mode
  ;; (remove-hook 'find-file-hooks 'redraw-glossary-buttons-when-window-scrolls-or-file-is-opened)
  (add-hook 'find-file-hooks 'run-buttonize-hooks t)
  ;; (add-hook 'wordnut-mode-hook 'run-buttonize-hooks t)
  ;; (remove-hook 'wordnut-mode-hook 'run-buttonize-hooks)
  ;; (remove-hook 'wordnut-mode-hook 'redraw-glossary-buttons-when-window-scrolls-or-file-is-opened)
  ;; (remove-hook 'wordnut-mode-hook 'redraw-glossary-buttons-when-window-scrolls-or-file-is-opened)
  ;; (add-hook 'Info-mode-hook 'redraw-glossary-buttons-when-window-scrolls-or-file-is-opened t)
  ;; (remove-hook 'find-file-hooks 'redraw-glossary-buttons-when-window-scrolls-or-file-is-opened)

  ;; new-buffer-hooks is my own thing
  ;; This is what was causing dired and grep-mode to have the glossary drawn
  ;; The problem is that the hooks run when the window is created, but not after a program is run within that window
  ;; (add-hook 'new-buffer-hooks 'redraw-glossary-buttons-when-window-scrolls-or-file-is-opened t)
  (remove-hook 'new-buffer-hooks 'redraw-glossary-buttons-when-window-scrolls-or-file-is-opened)
  (restart-glossary)

  ;; (add-hook 'python-mode-hook 'reload-glossary-and-generate-buttons)
  ;; (add-hook 'text-mode-hook 'reload-glossary-and-generate-buttons)
  ;; (remove-hook 'eww-after-render-hook 'reload-glossary-and-generate-buttons t)
  ;; (add-hook 'eww-after-render-hook 'reload-glossary-and-generate-buttons t)
  ;; (add-hook 'text-mode-hook 'generate-glossary-buttons-over-buffer)
  )
;; window-setup-hook does nothing sometimes
;; (add-hook 'window-setup-hook 'after-emacs-loaded-add-hooks-for-glossary t)
;; after-init-hook hangs
;; (add-hook 'after-init-hook 'after-emacs-loaded-add-hooks-for-glossary t)
;; emacs-startup-hook works


;; This is good, but I want to rely soley on the timer
;; I am. This is neccessary to avoid breaking *scratch*
(add-hook 'emacs-startup-hook 'after-emacs-loaded-add-hooks-for-glossary t)


;; (remove-hook 'text-mode-hook 'generate-glossary-buttons-over-buffer)


;; (remove-hook 'text-mode-hook (lm (make-buttons-for-glossary-terms (point-min) (point-max))))

;; (remove-hook 'text-mode-hook (lm (call-interactively 'make-buttons-for-glossary-terms)))



;; (defun next-button (pos &optional count-current)
;;   "Return the next button after position POS in the current buffer.
;; If COUNT-CURRENT is non-nil, count any button at POS in the search,
;; instead of starting at the next button."
;;     (unless count-current
;;       ;; Search for the next button boundary.
;;       (setq pos (next-single-char-property-change pos 'button)))
;;     (and (< pos (point-max))
;; 	 (or (button-at pos)
;; 	     ;; We must have originally been on a button, and are now in
;; 	     ;; the inter-button space.  Recurse to find a button.
;; 	     (next-button pos))))

(defun glossary-next-button-fast (pos)
  (let* ((nextpos (next-single-char-property-change pos 'button))
         (nextbutton (button-at nextpos)))
    ;; (message (concat (str pos) " " (str nextpos)))
    (if (not (and (not nextbutton) (= (button-start nextbutton) pos)))
        (progn
          (while (or (not nextbutton) (= (button-start nextbutton) pos))
            ;; (message (concat (str pos) " " (str nextpos)))
            (progn
              (setq nextpos (next-single-char-property-change nextpos 'button))
              (setq nextbutton (button-at nextpos))))
          nextbutton))))
  ;; (let* ((nextpos (next-single-char-property-change pos 'button))
  ;;        (nextbutton (button-at nextpos)))
  ;;   (if (and (not nextbutton) (not (= nextpos pos)))
  ;;       (progn
  ;;         (setq nextpos (next-single-char-property-change nextpos 'button))
  ;;         (setq nextbutton (button-at nextpos))))
  ;;   (if (and nextbutton (= nextpos pos))
  ;;       (progn
  ;;         (setq nextpos (next-single-char-property-change nextpos 'button))
  ;;         (setq nextbutton (button-at nextpos))))
  ;;   nextbutton
  ;;   ;; (while (and (setq nextbutton (button-at nextpos))))
  ;;   ;; (if nextbutton
  ;;   ;;     nextbutton
  ;;   ;;   (progn
  ;;   ;;     (setq nextbutton
  ;;   ;;           (button-at (next-single-char-property-change nextpos 'button))))
  ;;   ;;   ;; (next-single-char-property-change pos 'button)
  ;;   ;;   ;; (next-single-char-property-change (next-single-char-property-change pos 'button) 'button)
  ;;   ;;   )
  ;;   )


;; (goto-char (button-start (glossary-next-button-fast (point))))

(defun next-button-of-face (face)
  "Go to the next button which has the given face"
  (let ((b nil)
        (pos nil))
    (save-excursion
      (let ((cand (next-button (point)))
            (bface (button-get cand 'face)))
        (while (and cand (eq bface 'glossary-button-face))
          (setq cand (next-button (point))))
        (setq pos (point))
        cand))
    (goto-char pos)))


;; It would be better to collect ALL the buttons somehow and then filter them.
;; This is because there can be multiple buttons starting on the same point.

;; ace-link--help-collect
;; This still isnt perfect
;; http://www.google.com/url?q=https://github.com/kgann/cljs-flux&sa=U&ved=2ahUKEwibprGYs9jsAhW97XMBHeiJCPUQFjABegQIBxAB&usg=AOvVaw35OKApFhf0L6dTs2p9r2Zv
(defun buttons-collect (&optional face)
  "Collect the positions of visible links in the current `help-mode' buffer."

  (let* ((candidates)
         (p (glossary-window-start))
         ;; (lp p)
         (b (button-at p))
         (e (or (and b (button-end b)) p))
         (le e))
    (if (and b (if face (eq (button-get b 'face) face)
                 t))
        (push (cons (button-label b) p) candidates))
    (while (and (setq b ;; (glossary-next-button-fast p)
                      ;; strangely, next-button can return a button that starts before the e. i have to check that case,
                      ;; make e forcibly continue to increase every iteration. use le
                      (next-button e))
                (setq p (button-start b))
                (setq e (button-end b))
                (< p (glossary-window-end)))
      ;; (if (eq p lp)
      ;;     (setq p (+ p 1)))
      ;; (message (str p))
      (if (and b (if face (eq (button-get b 'face) face)
                   t))
          (push (cons (button-label b) p) candidates)
        (progn
          ;; (message (cc "p:" p ", e:" e  " " (float-time)))
          (setq e (+ (button-start b) 1))
          (if (<= e le)
              (setq e (+ 1 le)))
          (setq le e)
          ;; (message (cc "p:" p ", e:" e  " " (float-time)))
          ))
      ;; (push (cons (button-label b) p) candidates)
      )
    ;; (append
    ;;  (nreverse candidates)
    ;;  (widgets-collect))
    (nreverse candidates))

  ;; (let ((skip (text-property-any
  ;;              (glossary-window-start) (glossary-window-end) 'button nil))
  ;;       candidates)
  ;;   (save-excursion
  ;;     ;; next-single-char-property-change

  ;;     ;; This one
  ;;     ;; (text-property-not-all (point) (glossary-window-end) 'button nil)

  ;;     ;; (next-button (point))

  ;;     ;; (next-single-char-property-change (point) 'button)

  ;;     (next-single-char-property-change (point) 'button)

  ;;     (while (and skip (setq skip
  ;;                            (text-property-not-all skip (glossary-window-end) 'button nil)
  ;;                            ;; (next-single-char-property-change skip 'button)
  ;;                            ))
  ;;       (goto-char skip)
  ;;       (push (cons (button-label (button-at skip)) skip) candidates)
  ;;       (setq skip (text-property-any (point) (glossary-window-end)
  ;;                                     'button nil))))
  ;;   (nreverse candidates))
  )

;; Just call next-widget until I end up where I started
(defun widgets-collect ()
  "Collect the positions of visible links in the current gnus buffer."
  (require 'wid-edit)
  (let (candidates pt)
    (save-excursion
      (goto-char (point-min))
      (setq pt (point))
      (if (widget-at (point))
          (push (cons (str (thing-at-point 'symbol)) (point)) candidates))
      (ignore-errors
        (while
            (progn (widget-forward 1)
                   (> (point) pt))
          (setq pt (point))
          (push (cons (str (thing-at-point 'symbol)) (point)) candidates)))
      (nreverse candidates))))

;; broken
;; (defun buttons-collect-pred (pred)
;;   "Collect the positions of visible links in the current `help-mode' buffer."

;;   (let* ((candidates)
;;          (p (glossary-window-start))
;;          (b (button-at p))
;;          (e (or (and b (button-end b)) p))
;;          (e (or (and b (funcall pred b)) p))
;;          (le e))
;;     (if (and b (if pred (funcall pred b) t))
;;         (push (cons (button-label b) p) candidates))
;;     (while (and (setq b (next-button e))
;;                 (setq p (button-start b))
;;                 (setq e (button-end b))
;;                 (< p (glossary-window-end)))
;;       (if (and b (if pred (funcall pred b) t))
;;           (push (cons (button-label b) p) candidates)
;;         (progn
;;           (setq e (+ (button-start b) 1))
;;           (if (<= e le)
;;               (setq e (+ 1 le)))
;;           (setq le e)
;;           )))
;;     (nreverse candidates)))

;; broken
;; (defun buttons-collect-face (face)
;;   (eval
;;    `(buttons-collect-pred
;;      (lambda (b) (eq (button-get b 'face) ',face))))
;;   ;; (buttons-collect-pred
;;   ;;  (lambda (b) (eq (button-get b 'face) 'glossary-buttons-face)))
;;   )

;; broken
;; (defun buttons-collect-label (label)
;;   (eval
;;    `(buttons-collect-pred
;;      (lambda (b) (eq (button-label b) ,label)))))

(defun glossary-buttons-collect ()
  (append (buttons-collect 'glossary-button-face)
          (buttons-collect 'glossary-candidate-button-face)
          (buttons-collect 'glossary-error-button-face)))

;; (defun glossary-buttons-collect ()
;;   (save-excursion
;;     (beginning-of-buffer)
;;     (let ((skip (next-single-char-property-change skip 'button))
;;           candidates)
;;       (save-excursion

;;         (while (and skip (setq skip (next-single-char-property-change skip 'button)))
;;           (goto-char skip)
;;           (push (cons (button-label (button-at skip)) skip) candidates)
;;           (setq skip (text-property-any (point) (glossary-window-end)
;;                                         'button nil)))

;;         (setq skip (next-single-char-property-change skip 'button))
;;         (and (< skip (point-max))
;;              (or (button-at skip)
;;                  ;; We must have originally been on a button, and are now in
;;                  ;; the inter-button space.  Recurse to find a button.
;;                  (next-button skip))))
;;       (nreverse candidates))))



(defun ace-link-glossary-button ()
  (interactive)
  (let ((pt (avy-with ace-link-help
              (avy-process
               (mapcar #'cdr (glossary-buttons-collect))
               (avy--style-fn avy-style)))))
    (ace-link--help-action pt)))

;; I probably want to search all glossaries
(defun goto-glossary-definition (term)
  (interactive (list
                (fz (sn "list-glossary-terms")
                    (if (selectionp) (downcase (my/thing-at-point)))
                    nil
                    "goto-glossary-definition: ")))

  (if glossary-keep-tuples-up-to-date
      (glossary-reload-term-3tuples))

  (let* ((tups (-filter (l (e) (string-equal (car (last e)) term)) glossary-term-3tuples-global))
         (button-line (if tups
                          (umn (fz (mnm (pp-map-line tups)) nil nil nil nil t))))
         (button-tuple (if button-line
                           (my-eval-string (concat "'" button-line)))))
    (if button-tuple
        (progn
          (deselect)
          (with-current-buffer
              (if (>= (prefix-numeric-value current-prefix-arg) 4)
                  (find-file-other-window (first button-tuple))
                (find-file (first button-tuple)))
            (goto-byte (second button-tuple))))
      (message "word not found"))
    nil))

(defun goto-glossary-definition-noterm (term)
  (interactive (list (fz (sn "list-glossary-terms")
                         ""
                         nil
                         "goto-glossary-definition-noterm: ")))

  ;; (if glossary-keep-tuples-up-to-date
  ;;     (glossary-reload-term-3tuples))

  (goto-glossary-definition term))

(defun go-to-glossary-file-for-buffer (&optional take-first)
  (interactive)
  ;; TODO Make a fuzzy selection for this
  (mu (ff (or (and (not (>= (prefix-numeric-value current-prefix-arg) 4))
                   (local-variable-p 'glossary-files)
                   (if take-first
                       (car glossary-files)
                     (umn (fz (mnm (list2str glossary-files))
                              nil
                              nil
                              "go-to-glossary-file-for-buffer: "))))
              (umn (fz (mnm (list2str (list-glossary-files)))
                       nil
                       nil
                       "go-to-glossary-file-for-buffer: "))
              ;; "$NOTES/glossary.txt"
              ))))


(defun lm-define (term &optional prepend-lm-warning)
  (interactive)
  (let ((def
         (pen-pf-define-word term)))

    (if (sor def)
        (progn
          (if prepend-lm-warning
              (setq def (concat "NLG: " def)))
          (if (interactive-p)
              (etv def)
            def)))))


(defun add-to-glossary-file-for-buffer (term &optional take-first definition)
  "C-u will allow you to add to any glossary file"
  (interactive (let ((s (my/thing-at-point)))
                 (if (not (sor s))
                     (setq s (read-string-hist "add glossary term: ")))
                 (list s)))
  (message "(add-to-glossary-file-for-buffer)")
  (deselect)
  (if (not definition)
      (setq definition
            (qa
             -l (lm-define term t)
             -d (dictionaryapi-define term)
             -g (google-define term)
             -w (my-wiki-summary term)
             -W (my-wiki-summary (snc (cmd "redirect-wiki-term" term)))
             -r (read-string "definition: ")
             -m ""
             -n "")))

  ;; (tv definition)

  ;; TODO Make a fuzzy selection for this
  (let ((cb (current-buffer))
        ;; (gfs (if (local-variable-p 'glossary-files) glossary-files))
        (fp
         (if (is-glossary-file)
             (buffer-file-name)
           (umn (or
                 (and (or (>= (prefix-numeric-value current-prefix-arg) 4)
                          (not (local-variable-p 'glossary-files)))
                      (umn (fz (mnm (list2str (list-glossary-files)))
                               nil nil "add-to-glossary-file-for-buffer glossary: ")))
                 (and
                  (local-variable-p 'glossary-files)
                  (if take-first
                      (car glossary-files)
                    (umn (fz (mnm (list2str glossary-files))
                             "$HOME/glossaries/"
                             nil "add-to-glossary-file-for-buffer glossary: "))
                    ;; (umn (fz (mnm (list2str (glob "/home/shane/glossaries/*.txt"))) "$HOME/glossaries/"))
                    ))
                 (umn (fz (mnm (list2str (list "$HOME/glossaries/glossary.txt")))
                          "$HOME/glossaries/"
                          nil "add-to-glossary-file-for-buffer glossary: ")))))))
    ;; Unfortunately, I can't automatically do this
    ;; (if (and fp (not (-contains? gfs fp)))
    ;;     (glossary-add-link term fp))
    (with-current-buffer
        (ff fp)
      (progn
        (if (save-excursion
              (beginning-of-line)
              (looking-at-p (concat "^" (unregexify term) "$")))
            (progn
              (end-of-line))
          (progn
            (end-of-buffer)
            (newline)
            (newline)
            (insert term)))
        (newline)
        (if (sor definition)
            (insert
             (qa
              -t (snc "ttp" (concat "    " definition))
              -p (snc "tpp" (concat "    " definition))
              -n definition))
          (insert "    ")))
      (current-buffer))))

;; (mu (define-key global-map (kbd "H-y") (dff (ff (or (and (variable-p 'glossary-files) glossary-files) "$NOTES/glossary.txt")))))
(define-key global-map (kbd "H-i") 'add-glossaries-to-buffer)
(define-key global-map (kbd "H-Y I") 'add-glossaries-to-buffer)

;; Do not bind to functions which *require* a region
;; generate-glossary-buttons-manually
(define-key global-map (kbd "H-d") 'generate-glossary-buttons-manually)
(define-key global-map (kbd "H-Y d") 'generate-glossary-buttons-manually)
;; (define-key global-map (kbd "H-y") (dff (go-to-glossary-file-for-buffer t)))
;; (define-key global-map (kbd "C-H-y") 'go-to-glossary-file-for-buffer)
(define-key global-map (kbd "H-Y F") 'go-to-glossary-file-for-buffer)
(define-key global-map (kbd "H-Y A") 'add-to-glossary-file-for-buffer)
;; (define-key global-map (kbd "H-Y") nil)
(define-key global-map (kbd "H-Y G") 'glossary-reload-term-3tuples)
(define-key global-map (kbd "H-h") 'goto-glossary-definition)
(define-key global-map (kbd "H-Y H") 'goto-glossary-definition)
;; (define-key global-map (kbd "H-u") 'goto-glossary-definition-noterm)
;; This is used for the 'global-arg'
;; (define-key global-map (kbd "H-u") nil)
(define-key global-map (kbd "H-Y L") 'go-to-glossary)
(define-key global-map (kbd "<help> y") 'goto-glossary-definition)
(define-key global-map (kbd "<help> C-y") 'go-to-glossary)
(define-key global-map (kbd "H-y") 'go-to-glossary-file-for-buffer)

(define-key selected-keymap (kbd "A") 'add-to-glossary-file-for-buffer)


(defun remove-glossary-buttons-over-region (beg end)
  (interactive "r")
  (remove-overlays beg end 'face 'glossary-button-face))

(defun remove-all-glossary-buttons ()
  (interactive "r")
  (message "(remove-all-glossary-buttons)")
  (remove-glossary-buttons-over-region (point-min) (point-max))
  ;; (save-excursion
  ;;   (beginning-of-buffer)
  ;;   (while (next-button (point))
  ;;     (goto-char (next-button (point)))))
  )
(defalias 'clear-glossary-buttons 'remove-all-glossary-buttons)


(defset my-buttonize-hook '())

(add-hook 'my-buttonize-hook 'redraw-glossary-buttons-when-window-scrolls-or-file-is-opened)
(add-hook 'my-buttonize-hook 'make-buttons-for-all-filter-cmds)

(defun run-buttonize-hooks ()
  (interactive)
  (run-hooks 'my-buttonize-hook))


;; This has to be here AS WELL as in the Info-mode-hook
(defun Info-find-node-2-around-advice (proc &rest args)
  (let ((res (apply proc args)))
    (run-buttonize-hooks)
    res))
(advice-add 'Info-find-node-2 :around #'Info-find-node-2-around-advice)
;; (advice-remove 'Info-find-node-2 #'Info-find-node-2-around-advice)


(defun redraw-glossary-buttons-when-window-scrolls-or-file-is-opened ()
  (interactive)
  (message-no-echo (concat "redraw-glossary scroll " (get-path nil t)))
  (unless (or
           (not (myrc-test "auto_glossary_enabled"))
           (major-mode-p 'dired-mode)
           (major-mode-p 'compilation-mode)
           (string-equal (buffer-name) "*button cloud*")
           (re-match-p (buffer-name) "^\\*untitled")
           (and (timerp draw-glossary-buttons-timer)
                (= glossary-timer-current-window-start (glossary-window-start))
                (string= glossary-timer-current-buffer-name (buffer-name))))
    (defset glossary-timer-current-window-start (glossary-window-start))
    (defset glossary-timer-current-buffer-name (buffer-name))
    (if (or (major-mode-p 'prog-mode)
            (major-mode-p 'text-mode)
            (major-mode-p 'conf-mode)
            (major-mode-p 'org-brain-visualize-mode)

            ;; Doesn't work
            (major-mode-p 'Info-mode)
            (major-mode-p 'eww-mode)
            (major-mode-p 'fundamental-mode)
            ;; (major-mode-p 'term-mode)
            (major-mode-p 'Man-mode)
            (major-mode-p 'special-mode))
        ;; (message (concat "buttonized " (buffer-name)))
        (try
         (generate-glossary-buttons-over-buffer nil nil t)
         (message "problem generating glossary buttons")))
    ;; (if (not (remove-if-not 'identity (cl-loop for pat in glossary-blacklist-patterns collect (string-match pat (buffer-name)))))
    ;;     (generate-glossary-buttons-over-buffer nil nil t))
    ))

(defvar draw-glossary-buttons-timer nil)

;; TODO Create a blacklist of buffers, so I don't break them
;; I guess there are too many buffer which would be broken but this, in order to use a blacklist. So I need a whitelist
;; (defset glossary-blacklist-patterns (list "^\\*helm"))


(defun toggle-draw-glossary-buttons-timer (&optional newstate)
  (interactive)
  (defset glossary-timer-current-window-start (glossary-window-start))
  (defset glossary-timer-current-buffer-name (buffer-name))

  (cond ((not (timerp draw-glossary-buttons-timer))
         (if (interactive-p)
             (progn (generate-glossary-buttons-over-buffer nil nil t)
                    ;; (setq draw-glossary-buttons-timer (run-with-idle-timer glossary-idle-time 1 'redraw-glossary-buttons-when-window-scrolls-or-file-is-opened))
                    (setq draw-glossary-buttons-timer (run-with-idle-timer glossary-idle-time 1 'run-buttonize-hooks))
                    (message "glossary timer created")
                    t)
           nil))
        ((eq -1 newstate)
         (progn
           (cancel-timer draw-glossary-buttons-timer)
           (message "glossary timer stopped")
           nil))
        ((eq 1 newstate)
         (progn
           (cancel-timer draw-glossary-buttons-timer)
           (progn (generate-glossary-buttons-over-buffer nil nil t)
                  ;; (setq draw-glossary-buttons-timer (run-with-idle-timer glossary-idle-time 1 'redraw-glossary-buttons-when-window-scrolls-or-file-is-opened))
                  (setq draw-glossary-buttons-timer (run-with-idle-timer glossary-idle-time 1 'run-buttonize-hooks))
                  t)
           (message "glossary timer restarted")))
        (t
         (if (interactive-p)
             (if (-contains? timer-idle-list draw-glossary-buttons-timer)
                 (toggle-draw-glossary-buttons-timer -1)
               (toggle-draw-glossary-buttons-timer 1))
           (-contains? timer-idle-list draw-glossary-buttons-timer)))))

(defun restart-glossary ()
  (interactive)
  (toggle-draw-glossary-buttons-timer t))

(defun glossary-add-link (term fp)
  (interactive (list (read-string-hist "glossary term: " (my/thing-at-point))
                     (umn (fz (mnm (list2str (glob "/home/shane/glossaries/*.txt"))) "$HOME/glossaries/"))
                     ;; (ff (umn (or (and (local-variable-p 'glossary-files)
                     ;;                   (umn (fz (mnm (list2str glossary-files)) "$HOME/glossaries/"))
                     ;;                   ;; (umn (fz (mnm (list2str (glob "/home/shane/glossaries/*.txt"))) "$HOME/glossaries/"))
                     ;;                   )
                     ;;              (umn (fz (mnm (list2str "$HOME/glossaries/glossary.txt")) "$HOME/glossaries/")))))
                     ))
  (let ((code
         `((or (istr-in-region-or-buffer-or-path-p ,term))
           ,(mnm fp))))
    (j 'glossary-predicate-tuples)
    (special-lispy-different)
    (-dotimes 3 'backward-char)
    (newline)
    (indent-for-tab-command)
    (insert (pp-oneline code))))

(define-key selected-keymap (kbd "L") 'glossary-add-link)

(defun glossary-draw-after-advice (proc &rest args)
  (let ((res (apply proc args)))
    (generate-glossary-buttons-over-buffer nil nil t)
    (redraw-glossary-buttons-when-window-scrolls-or-file-is-opened)
    res))
;; (advice-add 'Man-fit-to-window :around #'glossary-draw-after-advice)
;; (advice-remove 'Man-fit-to-window #'glossary-draw-after-advice)
;; (advice-add 'Man-update-manpage :around #'glossary-draw-after-advice)
;; (advice-remove 'Man-update-manpage #'glossary-draw-after-advice)
;; (advice-remove 'Man-update-manpage #'glossary-draw-after-advice)
;; (advice-add 'Man-fontify-manpage :around #'glossary-draw-after-advice)
;; (advice-remove 'Man-fontify-manpage #'glossary-draw-after-advice)


(advice-add 'Man-bgproc-sentinel :around #'glossary-draw-after-advice)

(advice-remove 'Man-getpage-in-background #'Man-notify-when-ready-around-advice)
;; (advice-remove 'Man-notify-when-ready #'Man-notify-when-ready-around-advice)

;; (advice-remove 'Man-notify-when-ready #'glossary-draw-after-advice)
;; (advice-add 'Man-cleanup-manpage :around #'glossary-draw-after-advice)
;; (advice-remove 'Man-cleanup-manpage #'glossary-draw-after-advice)


(define-key global-map (kbd "H-B") 'goto-glossary-definition)

(defun generate-glossary-term-and-definition (term)
  (interactive))

;; Generate glossary term
(define-key selected-keymap (kbd "Z g g") 'generate-glossary-term-and-definition)


(defun is-glossary-file (&optional fp)
  ;; This path works also with info
  (setq fp (or fp (get-path)))
  (or
   (re-match-p "glossary\\.txt$" fp)
   (re-match-p "words\\.txt$" fp)
   (re-match-p "glossaries/.*\\.txt$" fp)))

(require 'link-hint)

;; the glossary buttons are not org links, so I cant use link-hint
;; I have to make my own wrapper around link-hint
;; (add-to-list 'alink-hint-types 'link-hint-glossary-link)

(defun glossary-button-at-point ()
  (let ((p (point))
        (b (button-at-point)))
    (if (and
         b
         (eq (button-get b 'face) 'glossary-button-face))
        b
      nil))
  (button-at-point))
(defalias 'glossary-button-at-point-p 'glossary-button-at-point)

(defun my-button-get-link (b)
  (cond
   ((eq (button-get b 'face) 'glossary-button-face)
    (concat "[[y:" (button-get-text b) "]]"))
   (t nil)))

(defun my-button-copy-link-at-point ()
  (interactive)
  (xc (my-button-get-link (button-at-point))))

"This should enable me to copy org-links from buttons, not just from org-links"
(defun ace-link-copy-button-link ()
  (interactive)
  (avy-with ace-link-help
    (avy-process
     (mapcar #'cdr (buttons-collect))
     (avy--style-fn avy-style)))
  (let* ((b (button-at-point))
         (l (my-button-get-link b)))
    (if l
        (xc l)))
  ;; (button-get-text (button-at-point))
  ;; (ace-link--help-action pt)
  )

(define-key my-mode-map (kbd "M-j M-y") 'ace-link-copy-button-link)
(define-key my-mode-map (kbd "M-j y") 'ace-link-copy-button-link)

(provide 'my-glossary)