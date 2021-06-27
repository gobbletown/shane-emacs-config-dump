(require 'my-utils)

;; This is a badly thought out function. Don't use it.
(defmacro d/f (f)
  "Select the first function that exists in order of priority with prefixes el/sh"
  (if (my/funcion-exists (my/add-symbol-prefix f 'el))))


;; This looks like a bad function
(defun my/bind-1-with-fzf ()
  (interactive)
  (shell-command (concat "tm -te -d nw \"bind1-with-fzf.sh \\\"" buffer-file-name "\\\"\" 1>/dev/null 2>/dev/null &") t))

;; M-x xx
;; This will tell you the word at the point
;; thing-at-point lets you get the current word under cursor into a string. (or, current line, current sentence, paragraph, file, URL, defun, ….)
(defun xx ()
  "print current word."
  (interactive)
  (message "%s" (thing-at-point 'word)))


;; No longer use this
(defun copy-to-kill-ring-and-clipboard ()
  "description string"
  (interactive)
  ;; let allows you to create local variables.
  ;; setq makes global variables
  (if (region-active-p)
      (let ((rstart (region-beginning))
            (rend (region-end)))
        ;; (setq rstart (region-beginning))
        ;; (setq rend (region-end))
        (kill-ring-save rstart rend)
        (goto-char rstart)
        (call-interactively 'set-mark-command)
        (goto-char rend)
        ;; (simpleclip-copy rstart rend)
        (shell-command-on-region rstart rend "xc"))
    ;; if not selecting anything then move forward a word, like vim
    ;;(kbd "M-f")
    (forward-word)))

;; this saves the region and reuses it -- useful idiom
(defun kill-region-and-clipboard ()
  "This kills and copies to the X clipboard"
  (interactive)
  ;; let allows you to create local variables.
  ;; setq makes global variables
  (if (region-active-p)
      (let ((rstart (region-beginning))
            (rend (region-end)))
        ;; (setq rstart (region-beginning))
        ;; (setq rend (region-end))

        ;; (simpleclip-copy rstart rend)
        (shell-command-on-region rstart rend "xc")

        (goto-char rstart)
        (call-interactively 'set-mark-command)
        (goto-char rend)
        (kill-region rstart rend)
        ;; (message "hi")
        )))

;; Thiswas enabled. Not anymore
;;(define-key my-mode-map (kbd "M-w") #'copy-to-kill-ring-and-clipboard)
;;(define-key minibuffer-local-map (kbd "M-w") #'copy-to-kill-ring-and-clipboard)
;;(define-key my-mode-map (kbd "C-w") #'kill-region-and-clipboard)
