;; (defsetface colour-button-face
;;   '((t :foreground "#990000"
;;        :background "#005500"
;;        :weight bold
;;        :inherit 'unspecified
;;        :underline t))
;;   "Face for color buttons. Do not color in.")

(defmacro setface (name spec doc)
  `(custom-set-faces (list ',name
                           ,spec)))

(defmacro defsetface (name spec doc)
  `(progn
     (defface ,name ,spec ,doc)
     (setface ,name ,spec ,doc)))

(defsetface colour-button-face
  '((t :foreground nil
       :background nil
       :weight bold
       :inherit nil
       :underline nil))
  "Face for color buttons. Do not color in.")

(define-button-type 'colour-button 'face 'colour-button-face)

;; Can't seem to figure out how to get button colours working again
;; I have run this file in a vanilla emacs and it doesn't affect the colourful overlays.
;; That means that the button face is not causing the problem
(defun list-colors-print (list &optional callback)
  (let ((callback-fn
           (if callback
               `(lambda (button)
                    (funcall ,callback (button-get button 'color-name))))))
    (dolist (color list)
      (if (consp color)
            (if (cdr color)
                (setq color (sort color (lambda (a b)
                                                  (string< (downcase a)
                                                             (downcase b))))))
          (setq color (list color)))
      (let* ((opoint (point))
               (color-values (color-values (car color)))
               (light-p (>= (apply 'max color-values)
                                (* (car (color-values "white")) .5))))
          (insert (car color))
          (indent-to 22)
          (put-text-property opoint (point) 'face `(:background ,(car color)))
          (put-text-property
           (prog1 (point)
             (insert " ")
             ;; Insert all color names.
             (insert (mapconcat 'identity color ",")))
           (point)
           'face (list :foreground (car color)))
          (insert (propertize " " 'display '(space :align-to (- right 9))))
          (insert " ")
          (insert (propertize
                     (apply 'format "#%02x%02x%02x"
                              (mapcar (lambda (c) (ash c -8))
                                        color-values))
                     'mouse-face 'highlight
                     'help-echo
                     (let ((hsv (apply 'color-rgb-to-hsv
                                           (color-name-to-rgb (car color)))))
                       (format "H:%.2f S:%.2f V:%.2f"
                                 (nth 0 hsv) (nth 1 hsv) (nth 2 hsv)))))
          (when callback
          (make-text-button
           opoint (point)
           'follow-link t
           'type 'colour-button
           ;; 'face nil
           ;; 'face 'colour-button-face
           ;; 'face (list :background (car color) :foreground (if light-p "black" "white"))
           'mouse-face (list :background (car color) :foreground (if light-p "black" "white"))
           'color-name (car color)
           'action callback-fn)))
      (insert "\n"))
    (goto-char (point-min))))


(setq custom-search-field nil)
(setq custom-unlispify-tag-names nil)
(setq custom-face-default-form 'selected)

;; this *must* exist. Since "~/" doesn't necessarily exist, I can't use that
;; (setq initial-buffer-choice "~/")
(setq initial-buffer-choice nil)

(provide 'my-custom-conf)
