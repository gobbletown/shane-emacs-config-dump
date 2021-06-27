(defun my-get-ov-properties-here (&optional overlay)
  (interactive (list (button-at-point)))

  (if (not overlay)
      (setq overlay (button-at-point)))

  (if overlay
      (let* ((ps (overlay-properties overlay))
             (l (- (length ps) 2))
             (a (cl-loop for i in (number-sequence 0 l 2) collect (cons (nth i ps)
                                                                        (nth (+ 1 i) ps)))))
        (if (interactive-p)
            (nbfs (pps a) nil 'emacs-lisp-mode)
          a))))

(defun button-show-properties-here ()
  (interactive)
  (let ((b (button-at (point))))
    ;; TODO Use an alist
    ;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Button-Properties.html
    (with-current-buffer (btv `(
                               (action . ,(button-get b 'action))
                               (mouse-action . ,(button-get b 'mouse-action))
                               (face . ,(button-get b 'face))
                               (overlay-props . ,(ignore-errors (my-get-ov-properties-here)))
                               (mouse-face . ,(button-get b 'mouse-face))
                               (keymap . ,(button-get b 'keymap))
                               (type . ,(button-get b 'type))))
      (emacs-lisp-mode))))

(defun get-button-action ()
  "Get the action of the button at point"
  (interactive)
  (let ((b (button-at (point))))
    (if b
        (button-get b 'action))))

(defun copy-button-action (&optional goto)
  (interactive)
  ;; sym2str wont work here because it might be a closure/sexp instead of a function/symbol
  ;; therefore, I must use str
  (let ((f (get-button-action))
        (b (button-at (point))))
    (setq f
          (cond ((eq 'help-button-action f) `(progn (apply ',(button-get b 'help-function)
                                                           ',(button-get b 'help-args))
                                                    nil))
                ((eq 'helpful--navigate f) `(find-file (substring-no-properties ,(button-get b 'path))))
                (t f)))
    (if goto
        (ignore-errors (find-function f)))
    (my/copy (pp-to-string f))))

(defun goto-button-action ()
  (interactive)
  (copy-button-action t))


(defun button-face-p (button face)
  (if (overlayp button)
      (eq (overlay-get button 'face) face)
    (member face (button-get button 'face))))

(defalias 'overlay-face-p 'button-face-p)

;; (button-face-p-here 'org-brain-local-child)
(defun button-face-p-here (face)
  (let ((b (button-at-point)))
    (button-face-p b face)))


(provide 'my-buttons)