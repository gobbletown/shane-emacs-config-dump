(require 's)

(defun current-major-mode-map ()
  (let ((sym (string2symbol (concat (current-major-mode) "-map"))))
    (if (not (boundp sym))
        (setq sym (string2symbol (concat (s-chop-suffix "-mode" (current-major-mode)) "-map"))))
    (if (not (boundp sym))
        (setq sym nil))
    sym))

(defun showmap--read-symbol (prompt predicate)
  (let* ((sym-here (current-major-mode-map) ;; (symbol-at-point)
                   )
         (default-val
           (when (funcall predicate sym-here)
             (symbol-name sym-here))))
    (when default-val
      (setq prompt
            (replace-regexp-in-string
             (rx ": " eos)
             (format " (default: %s): " default-val)
             prompt)))
    (intern (completing-read prompt obarray
                             predicate t nil nil
                             default-val))))

;; I need to use a macro to generate a predicate function
(defmacro variable-name-re-p (re)
  "Predicate for a variable with name matching regex"
  `(lambda (object)
       (and (variable-p object)
            (not (not (string-match-p ,re (sym2str object)))))))

;; (apply (variable-name-re-p "-map$") '(interactive))
;; (apply (variable-name-re-p "-map$") (list 'interactive))
;; (apply (variable-name-re-p "-map$") '(helm-map))
;; (apply (variable-name-re-p "-map$") (list 'helm-map))


(defun show-map-as-string (&optional mapsym)
  (interactive (list(showmap--read-symbol "map: " (variable-name-re-p "-map$"))))

  ;; For some reason this doesn't work in when actually in buffer-menu
  ;; I'm not going to debug it though.
  ;; M-x buffer-menu
  ;; j:Buffer-menu-mode-map
  ;; | =M-l M-r M-p= | =show-map= | =global-map=

  (if (not mapsym)
      (setq mapsym (current-major-mode-map)))

  (if (stringp mapsym)
      (setq mapsym (eval (str2sym (mapsym)))))

  (let ((mstring (concat "\\{" (sym2str mapsym) "}")))
    (substitute-command-keys mstring)))


(defun fz-map-fn (&optional mapsym)
  "fuzzy find maps and pretty print them in a new buffer"
  (interactive (list ;; (showmap--read-symbol "Function: " #'variable-p)
                (showmap--read-symbol "map: " (variable-name-re-p "-map$"))))

  (if (not mapsym)
      (setq mapsym (current-major-mode-map)))

  (if (stringp mapsym)
      (setq mapsym (eval (str2sym (mapsym)))))

  (if (>= (prefix-numeric-value current-prefix-arg) 4)
      (show-map mapsym)
    (let ((prefix-numeric-value nil))
      (run-major-mode-function mapsym))))

(defun show-map (&optional mapsym)
  "fuzzy find maps and pretty print them in a new buffer"
  (interactive (list ;; (showmap--read-symbol "Function: " #'variable-p)
                (showmap--read-symbol "map: " (variable-name-re-p "-map$"))))

  (if (not mapsym)
      (setq mapsym (current-major-mode-map)))

  (if (stringp mapsym)
      (setq mapsym (eval (str2sym (mapsym)))))

  ;; (let ((prefix-numeric-value nil))
  ;;   (fz-map-fn mapsym))
  (with-current-buffer
      (new-buffer-from-string
       (concat (sym2str mapsym) "\n\n" (show-map-as-string mapsym))
       ;; (concat "*" (sym2str mapsym) "*")
       ;; I don't want shackle to hide it'
       ;; (sym2str mapsym)
       ;; But I still want it to look temporary
       (concat "∙" (sym2str mapsym) "∙"))
    (view-mode 1))
  (fz-map-fn mapsym)
  ;; (if (>= (prefix-numeric-value current-prefix-arg) 4)
  ;;     ;; This is far more accurate because it shows the bindings
  ;;     ;; Can't rely on ivy annotations to show bindings
  ;;     )

  (provide 'my-show-map))