(require 'transpose-frame)

(define-key global-map (kbd "C-x M-5") #'transpose-frame)
(define-key global-map (kbd "C-x M-2") #'my-columnate-window)

;; yank-function-from-binding
;; Make a prefix to split the next binding in a window

(defun count-unique-visible-buffers (&optional frame)
  "Count how many buffers are currently being shown.  Defaults to
    selected frame."
  (length (cl-delete-duplicates (mapcar #'window-buffer (window-list frame)))))

(defun only-window-p ()
  (eq 1 (count-unique-visible-buffers)))

(defun sph-next (sequence)
  "Runs the next command in an sph split"
  (interactive (list (format "%s" (key-description (read-key-sequence-vector "Key: ")))))
  (let* ((fun (key-binding (kbd sequence))))
    ;; (let ((shackle-mode nil))
    ;;   (esph fun))
    (esph fun)
    (if (only-window-p)
        (progn (split-window-below)
               (switch-to-previous-buffer)
               (call-interactively 'other-window)))))

(defun spv-next (sequence)
  "Runs the next command in an spv split"
  (interactive (list (format "%s" (key-description (read-key-sequence-vector "Key: ")))))
  (let* ((fun (key-binding (kbd sequence))))
    ;; (let ((shackle-mode nil))
    ;;   (espv fun))
    (espv fun)
    (if (only-window-p)
        (progn (split-window-right)
               (switch-to-previous-buffer)
               (call-interactively 'other-window)))))

(defun sps-next (sequence)
  "Runs the next command in an sps split"
  (interactive (list (format "%s" (key-description (read-key-sequence-vector "Key: ")))))
  (let* ((fun (key-binding (kbd sequence))))
    ;; (let ((shackle-mode nil))
    ;;   (espv fun))
    (esps fun)
    (if (only-window-p)
        (progn (split-window-sensibly)
               (switch-to-previous-buffer)
               (call-interactively 'other-window)))))


(define-key global-map (kbd "M-m w d") 'sph-next)
(define-key global-map (kbd "M-m w D") 'spv-next)
(define-key global-map (kbd "M-m w e") 'sps-next)

(provide 'my-window)