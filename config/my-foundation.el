(defun clean-up-copy-link (rawlink)
  (setq rawlink (s-replace-regexp "^(\\(.*\\))$" "\\1" rawlink))
  (setq rawlink (s-replace-regexp "^[\"]\\(.*\\)[\"]$" "\\1" rawlink))
  (setq rawlink (s-replace-regexp "^\\([a-z]+\\.[a-z]+\\/\\)" "http://\\1" rawlink)) ;go import
  rawlink)

;; I should probably use advice instead
;; This is needed for eww
;; I'm using sh/xurls here to get the url from the thing / lline
(defun my-copy-link-at-point ()
  "Copy the link with the highest priority at the point."
  (interactive)
  (my/copy
   (try
    ;; (progn (error-if-equals (link-hint--action-at-point :copy) "There is no link supporting the :copy action at the point.")
    ;;        (e/xc))
    (error-if-equals (my-button-get-link (glossary-button-at-point)) nil)
    (error-if-equals (clean-up-copy-link (plist-get (link-hint--get-link-at-point) :args)) nil)
    (error-if-equals (e/chomp (sh/xurls (str (thing-at-point 'sexp)))) "")
    (error-if-equals (e/chomp (sh/xurls (str (thing-at-point 'url)))) "")
    (error-if-equals (e/chomp (sh/xurls (str (thing-at-point 'line)))) "")
    "")))

;; spacy.matcher.matcher
;; Match sequences of tokens, based on pattern rules.

;; DOCS: https://spacy.io/api/matcher
;; USAGE: https://spacy.io/usage/rule-based-matching

(provide 'my-foundation)