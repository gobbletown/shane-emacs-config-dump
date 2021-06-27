;; https://www.emacswiki.org/emacs/CopyingWholeLines
(defun copy-line (arg)
  "Copy lines (as many as prefix argument) in the kill ring.
      Ease of use features:
      - Move to start of next line.
      - Appends the copy on sequential calls.
      - Use newline as last char even on the last line of the buffer.
      - If region is active, copy its lines."
  (interactive "p")
  (let ((beg (line-beginning-position))
        (end (line-end-position arg)))
    (when mark-active
      (if (> (point) (mark))
          (setq beg (save-excursion (goto-char (mark)) (line-beginning-position)))
        (setq end (save-excursion (goto-char (mark)) (line-end-position)))))
    (if (eq last-command 'copy-line)
        (kill-append (buffer-substring beg end) (< end beg))
      (kill-ring-save beg end)))
  (kill-append "\n" nil)
  (beginning-of-line (or (and arg (1+ arg)) 2))
  (if (and arg (not (= 1 arg))) (message "%d lines copied" arg)))


(setq-default truncate-lines t)
;; Disable this! purcell uses it
(desktop-save-mode 0)

;; This is how to add extra things into the mode-line if you are using telephone-line
;; (telephone-line-defsegment 'telephone-line-daemonp-segment (format "%s" my-daemon-name))
;; (default-text-scale-mode t)
;; (default-text-scale-mode -1)

(define-key global-map (kbd "C-M--") 'text-scale-decrease)
(define-key global-map (kbd "C-M-=") 'text-scale-increase)

;; (setq browse-url-generic-program "google-chrome")
;; Make it so xmonad knows to switch to firefox. This would be good for documentation. Or I should just create a firefox wrapper for this.
;; (setq browse-url-generic-program "firefox")
(setq browse-url-generic-program "ff-view")

;; Make sure this is off. It would be annoying. But good for debugging
;; 20:49 < mrblack> My emacs started to open the debugger whenever I use keyboard-quit... anyone know how I can make it stop doing that?
(setq debug-on-quit nil)



;; gh f ".el" "No earlier matching history item"
;; https://raw.githubusercontent.com/typester/emacs/master/lisp/bindings.el
;; ("^Exit the snippet first!$"
;;  "^End of line$"
;;  "^Beginning of line$"
;;  beginning-of-line
;;  beginning-of-buffer
;;  end-of-line
;;  end-of-buffer
;;  end-of-file
;;  buffer-read-only
;;  file-supersession
;;  mark-inactive
;;  user-error)

(push "^No window numbered .$"     debug-ignored-errors)

(dolist (item `(,(purecopy "^Previous command was not a yank$")
                ,(purecopy "^Minibuffer window is not active$")
                ,(purecopy "^No previous history search regexp$")
                ,(purecopy "^No later matching history item$")
                ,(purecopy "^No earlier matching history item$")
                ,(purecopy "^End of history; no default available$")
                ,(purecopy "^End of defaults; no next item$")
                ,(purecopy "^Beginning of history; no preceding item$")
                ,(purecopy "^No recursive edit is in progress$")
                ,(purecopy "^Changes to be undone are outside visible portion of buffer$")
                ,(purecopy "^No undo information in this buffer$")
                ,(purecopy "^No further undo information")
                ,(purecopy "^Save not confirmed$")
                ,(purecopy "^Recover-file cancelled\\.$")
                ,(purecopy "^Cannot switch buffers in a dedicated window$")))
  (push item debug-ignored-errors))

(defun next-line-nonvisual (&optional arg try-vscroll)
  (interactive)
  (let ((line-move-visual nil))
    (next-line arg try-vscroll)))

(defun previous-line-nonvisual (&optional arg try-vscroll)
  (interactive)
  (let ((line-move-visual nil))
    (previous-line arg try-vscroll)))

(setq debug-on-error nil)


;; This was mark sexp or something It's also used by spacemacs
(define-key global-map (kbd "C-M-@") nil)
;; I could make it a general prefix key but I really don't like it. Just use it for the spacemacs menus



(defun save-buffers-kill-emacs (&optional arg)
  "Offer to save each buffer, then kill this Emacs process.
With prefix ARG, silently save all file-visiting buffers without asking.
If there are active processes where `process-query-on-exit-flag'
returns non-nil and `confirm-kill-processes' is non-nil,
asks whether processes should be killed.
Runs the members of `kill-emacs-query-functions' in turn and stops
if any returns nil.  If `confirm-kill-emacs' is non-nil, calls it."
  (interactive "P")
  ;; Don't use save-some-buffers-default-predicate, because we want
  ;; to ask about all the buffers before killing Emacs.
  (save-some-buffers arg t)
  (let ((confirm confirm-kill-emacs))
    (and
     (or (not (memq t (mapcar (function
                               (lambda (buf) (and (buffer-file-name buf)
                                                  (buffer-modified-p buf))))
                              (buffer-list))))
         (progn (setq confirm nil)
                (yes-or-no-p "Modified buffers exist; exit anyway? ")))
     (or (not (fboundp 'process-list))
         ;; process-list is not defined on MSDOS.
         (not confirm-kill-processes)
         (let ((processes (process-list))
               active)
           (while processes
             (and (memq (process-status (car processes)) '(run stop open listen))
                  (process-query-on-exit-flag (car processes))
                  (setq active t))
             (setq processes (cdr processes)))
           (or (not active)
               (with-current-buffer-window
                   (get-buffer-create "*Process List*")
                   `(display-buffer--maybe-at-bottom
                     (dedicated . t)
                     (window-height . fit-window-to-buffer)
                     (preserve-size . (nil . t))
                     (body-function
                      . ,#'(lambda (_window)
                             (list-processes t))))
                   #'(lambda (window _value)
                       (with-selected-window window
                         (unwind-protect
                             (progn
                               (setq confirm nil)
                               (yes-or-no-p "Active processes exist; kill them and exit anyway? "))
                           (when (window-live-p window)
                             (quit-restore-window window 'kill)))))))))
     ;; Query the user for other things, perhaps.
     ;; (message "trying")
     ;; Ignore errors wont work as run-hook-with-args-until-failure is a c function?
     ;; (ignore-errors (run-hook-with-args-until-failure 'kill-emacs-query-functions))
     (try (run-hook-with-args-until-failure 'kill-emacs-query-functions)
          (progn
            (or (null confirm)
                (funcall confirm "Really exit Emacs? "))
            (kill-emacs)))

     ;; (message "made it")
     ;; I want to always make it to this point
     (or (null confirm)
         (funcall confirm "Really exit Emacs? "))
     (kill-emacs))))

(provide 'my-emacs)