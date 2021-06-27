(defmacro ||= (sym value)
  "Idempotent assignment operator from Ruby"
  `(progn
     (if (not (variable-p ',sym))
         (setq ,sym ,value))
     ,sym))

(defmacro &&= (sym value)
  "Mutate only operator from Ruby"
  `(progn
     (if (variable-p ',sym)
         (progn (setq ,sym ,value)
                ,sym)
       nil)))

(provide 'my-operators)