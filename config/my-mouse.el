;; Use C-M-x instead

;; (defun make-mouse-event-at-point (base-event)
;;   (let ((posn (posn-at-point))
;;         (prefix "")
;;         (basic-type (event-basic-type base-event))
;;         (modifiers (event-modifiers base-event)))
;;     (cond
;;      ((and (integerp basic-type) (>= basic-type ?0) (<= basic-type ?9))
;;       ;; click
;;       (let* ((mouse-type (intern (format "%smouse-%d" prefix (- basic-type ?0))))
;;              (click-count 1)
;;              (type (event-convert-list (append modifiers (list mouse-type)))))
;;         (list type posn click-count)))
;;      (t
;;       (error "Unsupported key for mouse event: %s" (event-basic-type base-event))))))
;; (defun simulate-mouse-event-at-point ()
;;   (interactive)
;;   (let ((event (make-mouse-event-at-point last-input-event)))
;;     (setq unread-command-events (cons event unread-command-events))))

;; (defvar simulate-mouse-event-map (make-sparse-keymap))
;; (global-set-key [f11] simulate-mouse-event-map)
;; (define-key simulate-mouse-event-map [t] 'simulate-mouse-event-at-point)

;; mouse-wheel-text-scale

(require 'mwheel)

(defun mouse-wheel-scroll-more (event)
  "Increase or decrease the height of the default face according to the EVENT."
  (interactive (list last-input-event))
  (mwheel-scroll event)
  (mwheel-scroll event)
  (mwheel-scroll event)
  (mwheel-scroll event)
  (mwheel-scroll event)
  ;; (let ((selected-window (selected-window))
  ;;       (scroll-window (mouse-wheel--get-scroll-window event))
  ;;       (button (mwheel-event-button event)))
  ;;   (select-window scroll-window 'mark-for-redisplay)
  ;;   (unwind-protect
  ;;       (cond ((eq button mouse-wheel-down-event)
  ;;              (text-scale-increase 1))
  ;;             ((eq button mouse-wheel-up-event)
  ;;              (text-scale-decrease 1)))
  ;;     (select-window selected-window)))
  )

(defun mouse-wheel-scroll-2 (event)
  "Increase or decrease the height of the default face according to the EVENT."
  (interactive (list last-input-event))
  (mwheel-scroll event)
  (mwheel-scroll event)

  ;; (let ((selected-window (selected-window))
  ;;       (scroll-window (mouse-wheel--get-scroll-window event))
  ;;       (button (mwheel-event-button event)))
  ;;   (select-window scroll-window 'mark-for-redisplay)
  ;;   (unwind-protect
  ;;       (cond ((eq button mouse-wheel-down-event)
  ;;              (text-scale-increase 1))
  ;;             ((eq button mouse-wheel-up-event)
  ;;              (text-scale-decrease 1)))
  ;;     (select-window selected-window)))
  )

(define-minor-mode mouse-wheel-mode
  "Toggle mouse wheel support (Mouse Wheel mode)."
  :init-value t
  ;; We'd like to use custom-initialize-set here so the setup is done
  ;; before dumping, but at the point where the defcustom is evaluated,
  ;; the corresponding function isn't defined yet, so
  ;; custom-initialize-set signals an error.
  :initialize 'custom-initialize-delay
  :global t
  :group 'mouse
  ;; Remove previous bindings, if any.
  (mouse-wheel--remove-bindings)
  ;; Setup bindings as needed.
  (when mouse-wheel-mode
    (dolist (binding mouse-wheel-scroll-amount)
      (cond
       ;; Bindings for changing font size.
       ((and (consp binding) (eq (cdr binding) 'text-scale))
        (dolist (event (list mouse-wheel-down-event mouse-wheel-up-event))
          (mouse-wheel--add-binding `[,(list (caar binding) event)]
                                    'mouse-wheel-scroll-more)))
       ;; Bindings for scrolling.
       (t
        (dolist (event (list mouse-wheel-down-event mouse-wheel-up-event
                             mouse-wheel-left-event mouse-wheel-right-event))
          (dolist (key (mouse-wheel--create-scroll-keys binding event))
            (mouse-wheel--add-binding key 'mouse-wheel-scroll-2))))))))

(mouse-wheel-mode -1)
(mouse-wheel-mode 1)




;; mouse-set-point
(defun my-mouse-set-point (event &optional promote-to-region)
  "Move point to the position clicked on with the mouse.
This should be bound to a mouse click event type.
If PROMOTE-TO-REGION is non-nil and event is a multiple-click, select
the corresponding element around point, with the resulting position of
point determined by `mouse-select-region-move-to-beginning'."
  (interactive "e\np")
  (mouse-minibuffer-check event)
  (if (and promote-to-region (> (event-click-count event) 1))
      (progn
        (mouse-set-region event)
        (when mouse-select-region-move-to-beginning
          (when (> (posn-point (event-start event)) (region-beginning))
            (exchange-point-and-mark))))
    ;; Use event-end in case called from mouse-drag-region.
    ;; If EVENT is a click, event-end and event-start give same value.
    (posn-set-point (event-end event))))

;; This is to disable right-click from changing the position when mark is active
(defun mouse-set-point (event &optional promote-to-region)
  (interactive "e\np")
  (try
   (if (or (eq (car event)
               'mouse-1)
           (eq (car event)
               'down-mouse-1)
           (eq (car event)
               'double-mouse-1)
           (eq (car event)
               'double-down-mouse-1)
           (not mark-active))
       (my-mouse-set-point event promote-to-region)
     ;; (message (pps event))
     )
   (my-mouse-set-point event promote-to-region)))

;; j:mouse--drag-set-mark-and-point

(defun right-click-context-click-menu (_event)
  "Open Right Click Context menu by Mouse Click `EVENT'."
  (interactive "e")
  (when (or (eq right-click-context-mouse-set-point-before-open-menu 'always)
            (and (null mark-active)
                 (eq right-click-context-mouse-set-point-before-open-menu 'not-region)))
    (call-interactively #'my-mouse-set-point))
  (right-click-context-menu))


(provide 'my-mouse)