(require 'selected)

;; e ia syntax-subword symbolword-mode most-
;; used-words line-up-words leaf-keywords
;; keyword-search define-word company-wordfreq

(defun monotonically-increasing-tuple-permutations (input)
  (str2lines (snc "monotonically-increasing-tuple-permutations.py" input)))

;; (monotonically-increasing-tuple-permutations "what is the meaning of this")

(defun dictionaryapi-define (word)
  (interactive (list (rshi "dictionaryapi-define: " (my/thing-at-point))))
  (let ((d (sor (chomp (snc (cmd "dictionaryapi-define" word))))))
    (if (interactive-p)
        (etv d)
      d)))

(defun google-define (word)
  (interactive (list (rshi "google-define: " (my/thing-at-point))))
  (let ((d (sor (chomp (snc (cmd "google-define" word))))))
    (if (interactive-p)
        (etv d)
      d)))

(defun my-wiki-summary (term)
  (interactive (list (rshi "wiki-summary: " (my/thing-at-point))))
  (let ((s
         (snc
          (concat "wiki-summary "
                  term)
          ;; (concat
          ;;  (cmd "curl"
          ;;       (concat
          ;;        "https://en.wikipedia.org/w/api.php?continue=&action=query&titles="
          ;;        (urlencode term)
          ;;        "&prop=extracts&exintro=&explaintext=&format=json&redirects"))
          ;;  " | "
          ;;  "jq -r"
          ;;  " "
          ;;  "'( .query.pages | keys[0] ) as $k | .query.pages[$k].extract'")
          )))
    (if (interactive-p)
        (etv s)
      s)))

(defun ngram-suggest (query)
  (interactive (list (read-string-hist "ngram-suggest query: ")))

  (if (re-match-p "^[^*]+$" query)
      (setq query (concat query " *")))

  (let ((res (str2lines (snc "ngram-complete" query))))
    (if (interactive-p)
        (xc (fz res
                nil nil "ngram-suggest copy: "))
      res)))

;; TODO Make it utilise different combinations of surrounding words
;; For the moment, let it accept 2 words to the left and 2 to the right

;; TODO Make it so it first provides fuzzy selection for the set of 5 words to use
;; TODO Learn to embed python in elisp. That will make it easier to do some tokenization stuff

;; TODO Use this: google-ngram-query-combinations

(defun gen-google-ngram-queries (s i)
  (-filter-not-empty-string
   (str2list
    (snc
     (concat
      "echo "
      (q s)
      " | google-ngram-query-combinations "
      (str i)
      ;; " | perl -e 'print sort { length($b) <=> length($a) } <>'"
      )))))

(defun ngram-query-replace-this ()
  (interactive)
  (if (not (selectionp))
      (let* ((line-str (chomp (current-line-string)))
             (col (+ 1 (current-column)))
             (suggestions (ngram-suggest (fz (gen-google-ngram-queries line-str col)
                                             nil nil "ngram-query-replace-this query: "))))
        (if (-filter-not-empty-string suggestions)
            (let ((replacement (fz suggestions
                                   nil nil "ngram-query-replace-this replacement: ")))
              (if (sor replacement)
                  (nbfs replacement)))))))

(defun ngram-query-replace ()
  (interactive)
  (if (selectionp)
      (let* ((query (if (selection-p)
                        (selection)))
             (reformulated-query (if (string-match-p "\\*" query)
                                     query
                                   (let ((wildcard-word (fz (split-string query " " t)
                                                            nil nil "ngram-query-replace wildcard-word: ")))
                                     (if wildcard-word
                                         (s-replace-regexp (eatify wildcard-word) "*" query)
                                       query))))
             (suggestions (ngram-suggest reformulated-query)))
        (if (-filter-not-empty-string suggestions)
            (let ((replacement (fz suggestions
                                   nil nil "ngram-query-replace suggestions: ")))
              (if replacement
                  (progn
                    (cua-delete-region)
                    (insert replacement))))))
    (ngram-query-replace-this)))


(defun tuple-swap (tp)
  (list (car (cdr tp)) (car tp)))


;; TODO Make my emacs use the OpenAI API for this
(defun pick-emoji ()
  (interactive)
  (let ((tuples
         '(("😔" "Pensive Face")
           ("😯" "Hushed Face")
           ("🍓" "Strawberry")
           ("😐" "Neutral Face")
           ("😑" "Expressionless Face")
           ("🤨" "Face With Raised Eyebrow. Suspicious")
           ("🤦" "facepalm")
           ("👎" "thumbs down sign")
           ("👎" "thuumbs down")
           ("🤔")
           ("🙄" "Face With Rolling Eye")
           ("🤘" "Sign of the horns -- rock")
           ("💫" "Dizzy")
           ("(◠‿◠✿)" "Happy")
           ("┏━┓┏━┓┏━┓ ︵ /(^.^/)" "Caterpiller"))))
    ;; (etv tuples)
    (let ((selection (fz ;; (mapcar 'second tuples)
                      (mapcar 'tuple-swap tuples))))
      (insert (first (first (-filter (lambda (x) (equal (second x) selection)) tuples)))))))

(define-key global-map (kbd "H-V") 'pick-emoji)


;; DONE Go through all the spacy scripts and create etv-filters for them

;; TODO Make it so this opens in an sps vs instead because it can be slow

(defmacro etv-filter (cmd)
  (let* ((slug (slugify cmd))
         (sym (str2sym (concat "etv-" slug))))
    `(defun ,sym (&optional input)
       (interactive (list (my/selected-text)))
       (if (not input)
           (setq input (my/selected-text)))
       ;; (etv (snc ,cmd input))
       (let ((tf (snc "tf txt" input)))
         (sps (concat "cat " (q tf) " | " ,cmd " | vs"))))))

(cl-loop for s in
         '("partsofspeech"
           "entities"
           "deplacy"
           "displacy"
           "summarize"
           "spacyparsetree"
           "token-pos-dep"
           "sentiment"
           "segment-sentences"
           "noun-chunks")
         do
         (eval
          (expand-macro
           `(etv-filter ,s))))

(define-key selected-keymap (kbd "Z n") 'ngram-query-replace)
(define-key selected-keymap (kbd "Z S") 'sps-play-spacy)
(define-key selected-keymap (kbd "Z M") 'etv-summarize)
(define-key selected-keymap (kbd "Z P") 'etv-partsofspeech)
(define-key selected-keymap (kbd "Z R") 'etv-spacyparsetree)
(define-key selected-keymap (kbd "Z E") 'etv-entities)
(define-key selected-keymap (kbd "Z L") 'etv-deplacy)
(define-key selected-keymap (kbd "Z D") 'etv-displacy)
(define-key selected-keymap (kbd "Z T") 'etv-token-pos-dep)
(define-key selected-keymap (kbd "Z N") 'etv-sentiment)
(define-key selected-keymap (kbd "Z G") 'etv-segment-sentences)
(define-key selected-keymap (kbd "Z O") 'etv-noun-chunks)
(define-key selected-keymap (kbd "Z d g") 'google-define)

(defun sps-play-spacy (&optional input)
  (interactive)
  (if (not input)
      (setq input (my/selected-text)))
  (sn "play-spacy" input))

(define-key global-map (kbd "H-S") 'sps-play-spacy)


(defun get-topic (&optional semantic)
  (interactive)
  (let ((topic))
    (if (interactive-p)
        (etv topic))))

(defun find-anagrams (word)
  (interactive (list
                (if (selectionp)
                    (selection)
                    (read-string-hist "find-anagrams: "
                                      (my/thing-at-point)))))
  (xc (fz (snc (cmd "find-anagrams" word))
          nil
          nil
          "find-anagrams copy: "
          nil
          t)))


(defun openai-correct-word (&optional word)
  (interactive (list ;; (word-at-point)
                (car (flyspell-get-word))))

  (flyspell-auto-correct-word (chomp (pen-pf-correct-spelling-for-word word)))

  ;; base on this
  ;; j:flyspell-auto-correct-word

  )

(defun my-auto-correct-word ()
  (interactive)
  (if (>= (prefix-numeric-value current-prefix-arg) 4)
      (call-interactively 'openai-correct-word)
    (call-interactively 'flyspell-auto-correct-word)))

(provide 'my-nlp)