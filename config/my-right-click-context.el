(require 'my-widgets)
(require 'my-context-functions)

;; right-click-context uses popup
(require 'popup)
(require 'right-click-context)


(defset popup-max-height 30)

(cl-defun popup-menu* (list
                       &key
                       point
                       (around t)
                       (width (popup-preferred-width list))
                       (height popup-max-height)
                       max-width
                       margin
                       margin-left
                       margin-right
                       scroll-bar
                       symbol
                       parent
                       parent-offset
                       cursor
                       (keymap popup-menu-keymap)
                       (fallback 'popup-menu-fallback)
                       help-delay
                       nowait
                       prompt
                       isearch
                       (isearch-filter 'popup-isearch-filter-list)
                       (isearch-cursor-color popup-isearch-cursor-color)
                       (isearch-keymap popup-isearch-keymap)
                       isearch-callback
                       initial-index
                       &aux menu event)
  "Show a popup menu of LIST at POINT. This function returns a
value of the selected item. Almost all arguments are the same as in
`popup-create', except for KEYMAP, FALLBACK, HELP-DELAY, PROMPT,
ISEARCH, ISEARCH-FILTER, ISEARCH-CURSOR-COLOR, ISEARCH-KEYMAP, and
ISEARCH-CALLBACK.

If KEYMAP is a keymap which is used when processing events during
event loop.

If FALLBACK is a function taking two arguments; a key and a
command. FALLBACK is called when no special operation is found on
the key. The default value is `popup-menu-fallback', which does
nothing.

HELP-DELAY is a delay of displaying helps.

If NOWAIT is non-nil, this function immediately returns the menu
instance without entering event loop.

PROMPT is a prompt string when reading events during event loop.

If ISEARCH is non-nil, do isearch as soon as displaying the popup
menu.

ISEARCH-FILTER is a filtering function taking two arguments:
search pattern and list of items. Returns a list of matching items.

ISEARCH-CURSOR-COLOR is a cursor color during isearch. The
default value is `popup-isearch-cursor-color'.

ISEARCH-KEYMAP is a keymap which is used when processing events
during event loop. The default value is `popup-isearch-keymap'.

ISEARCH-CALLBACK is a function taking one argument.  `popup-menu'
calls ISEARCH-CALLBACK, if specified, after isearch finished or
isearch canceled. The arguments is whole filtered list of items.

If `INITIAL-INDEX' is non-nil, this is an initial index value for
`popup-select'. Only positive integer is valid."
  (and (eq margin t) (setq margin 1))
  (or margin-left (setq margin-left margin))
  (or margin-right (setq margin-right margin))
  (if (and scroll-bar
           (integerp margin-right)
           (> margin-right 0))
      ;; Make scroll-bar space as margin-right
      (cl-decf margin-right))
  (setq menu (popup-create point width height
                           :max-width max-width
                           :around around
                           :face 'popup-menu-face
                           :mouse-face 'popup-menu-mouse-face
                           :selection-face 'popup-menu-selection-face
                           :summary-face 'popup-menu-summary-face
                           :margin-left margin-left
                           :margin-right margin-right
                           :scroll-bar scroll-bar
                           :symbol symbol
                           :parent parent
                           :parent-offset parent-offset))
  (unwind-protect
      (progn
        (popup-set-list menu list)
        (if cursor
            (popup-jump menu cursor)
          (popup-draw menu))
        (when initial-index
          (dotimes (_i (min (- (length list) 1) initial-index))
            (popup-next menu)))
        (if nowait
            menu
          (popup-menu-event-loop menu keymap fallback
                                 :prompt prompt
                                 :help-delay help-delay
                                 :isearch isearch
                                 :isearch-filter isearch-filter
                                 :isearch-cursor-color isearch-cursor-color
                                 :isearch-keymap isearch-keymap
                                 :isearch-callback isearch-callback)))
    (unless nowait
      (popup-delete menu))))


;; There is also prop-menu, an alternative right-click menu
;; $EMACSD/packages28/prop-menu-20150728.1118
;; $EMACSD/packages28/idris-mode-20210223.850


;; 01:37 < bpalmer> libertyprime: I don't understand what this is doing. You want to have your own context menu if you click on a term, and use a global one otherwise?
;; 01:37 < libertyprime> yup :) got it going too
;; 01:38 < bpalmer> libertyprime: why don't you just buttonize each term with a text property or overlay that has its own keymap binding for mouse-3 ?
;; 01:38 < maddo> hello, I wanted to ask, is there any documentation for having gnus work with notmuch? Couldn't find anything useful/recent
;; 01:40 < bpalmer> libertyprime: an overlay or text property map should be consulted before minor mode maps, major mode maps, or the global keymap
;; 01:40 < libertyprime> bpalmer: oh whoa thats super cool
;; 01:40 < libertyprime> i didnt know that
;; 01:40 < twb> Let's describe our video game as "artisanal" instead of "hand-drawn"
;; 01:40 < mplsCorwin> Ah, man.  That is a *fantastic* idea bpalmer.
;; 01:40 < bpalmer> I gues the complication would be if you want to quickly and easily turn off your term context menu
;; 01:41 < bpalmer> no, wait, you can simply attach a new property in the same button, and then map over the text property changes or map-overlay looking for it
;; 01:41 < bpalmer> so you can quickly add and remove key bindings.

(defset right-click-context-hook '())
(defset right-click-context-hook-last-event nil)

;; This i how to resend an event
(defun resend-event (e)
  (setq unread-command-events (cons e unread-command-events)))

;; (require 'deferred)

(defun abort-for-right-click-context-mode (;; event
                                           )
  ;; (interactive "e")
  (interactive)
  (if (button-at (point))
      (progn
        (right-click-context-menu-button)
        (error "Cancel right click context menu")))

  (if (widget-at (point))
      (progn
        (right-click-context-menu-widget)
        (error "Cancel right click context menu")))

  ;; In some circumstances, simply fall through to let other plugins handle the right click
  (if ;; (button-at (point))
      nil
      (progn
        (right-click-context-mode -1)
        (run-with-timer 0.1 nil (lm (resend-event right-click-context-hook-last-event)))
        (run-with-timer 0.2 nil (lm (right-click-context-mode 1)))
        (error "Cancel right click context menu"))))

(define-key global-map (kbd "<mouse-3>") (lm (message "when on button")))
;; (define-key global-map (kbd "<mouse-3>") nil)

(add-hook 'right-click-context-hook #'abort-for-right-click-context-mode)

;; This functions like how the Ctrl-leftclick would give right click menu in Mac OS 8.6
(define-key right-click-context-mode-map (kbd "<C-down-mouse-1>") 'right-click-context-click-menu)

;; Was originally bound to this
;; (define-key right-click-context-mode-map (kbd "<C-down-mouse-1>") 'mouse-buffer-menu)


;; (defun right-click-context-click-menu (_event)
;;   "Open Right Click Context menu by Mouse Click `EVENT'."
;;   (interactive "e")
;;   ;; (run-hooks 'right-click-context-hook)
;;   (when (or (eq right-click-context-mouse-set-point-before-open-menu 'always)
;;             (and (null mark-active)
;;                  (eq right-click-context-mouse-set-point-before-open-menu 'not-region)))
;;     (call-interactively #'mouse-set-point))
;;   (right-click-context-menu))

(defun right-click-context-click-menu-around-advice (proc &rest args)
  (call-interactively #'mouse-set-point)
  (setq right-click-context-hook-last-event (car args))
  (ignore-errors
    (run-hooks 'right-click-context-hook)
    (let ((res (apply proc args)))
      res)))
(advice-add 'right-click-context-click-menu :around #'right-click-context-click-menu-around-advice)

(right-click-context-mode t)

;; (defun mouse-save-then-kill-around-advice (proc &rest args)
;;   (message "mouse-save-then-kill called with args %S" args)
;;   (let ((res (apply proc args)))
;;     (message "mouse-save-then-kill returned %S" res)
;;     res))
;; (advice-add 'mouse-save-then-kill :around #'mouse-save-then-kill-around-advice)
;; (advice-remove 'mouse-save-then-kill #'mouse-save-then-kill-around-advice)

(defun right-click-popup-close ()
  (interactive)
  (while popup-instances
    (popup-delete (nth (1- (length popup-instances)) popup-instances))))

(defmacro def-right-click-menu (name
                                ;; predicates
                                popup)
  "Create a right click menu."
  `(defun ,name ()
     "Open Right Click Context menu."
     (interactive)
     (let ((popup-menu-keymap (copy-sequence popup-menu-keymap)))
       ;; (define-key popup-menu-keymap [mouse-3] #'right-click-context--click-menu-popup)
       (define-key popup-menu-keymap [mouse-3] #'right-click-popup-close)
       (define-key popup-menu-keymap (kbd "C-g") #'right-click-popup-close)
       (let ((value (popup-cascade-menu (right-click-context--build-menu-for-popup-el ,popup nil))))
         (when value
           (if (symbolp value)
               (call-interactively value t)
             (eval value)))))))


(defun right-click-context-menu ()
  "Open Right Click Context menu."
  (interactive)
  ;; This should make it so the context menu appears at the top left of the region -- it's better
  (save-excursion-and-region-reliably
   (if (and mark-active
            (< (mark) (point)))
       (exchange-point-and-mark))
   (let ((popup-menu-keymap (copy-sequence popup-menu-keymap)))
     ;; (define-key popup-menu-keymap [mouse-3] #'right-click-context--click-menu-popup)
     (define-key popup-menu-keymap [mouse-3] #'right-click-popup-close)
     (define-key popup-menu-keymap (kbd "C-g") #'right-click-popup-close)
     (let ((value (popup-cascade-menu (right-click-context--build-menu-for-popup-el (right-click-context--menu-tree) nil))))
       (when value
         (if (symbolp value)
             (call-interactively value t)
           (eval value)))))))

;; Menus can have further predicates
(def-right-click-menu right-click-context-menu-button
  '(;; ("Convert headline to file" :call (progn
    ;;                                     (org-brain-this-headline-to-file)
    ;;                                     (revert-buffer))
    ;;  :if (button-face-p-here 'org-brain-local-child))
    ("Convert headline to file" :call (progn
                                        (org-brain-this-headline-to-file)
                                        (revert-buffer))
     :if (org-brain-headline-at-point))
    ("Brain rename file" :call org-brain-rename-file :if (org-brain-file-at-point))
    ("Copy action" :call (copy-button-action)
     :if (button-at (point))
     )
    ("Go to button function" :call (goto-button-action)
     :if (button-at (point)))
    ("Push button" :call (push-button)
     :if (button-at (point)))
    ("Show button properties" :call (button-show-properties-here)
     :if (button-at (point)))
    ("Copy link" :call (my-button-copy-link-at-point)
     :if (button-at-point))
    ("Context functions" :call show-suggest-funcs-context-menu)
    ;; ("Cut" :call (kill-region (region-beginning) (region-end))
    ;;  :if (and (use-region-p) (not buffer-read-only)))
    ;; ("Paste" :call (yank) :if (not buffer-read-only))
    ;; ("Select Region"
    ;;  ("All" :call (mark-whole-buffer) :if (not (use-region-p)))
    ;;  ("Word" :call (mark-word))
    ;;  ("Paragraph" :call (mark-paragraph)))
    ))

(defun push-widget ()
  (interactive)
  (widget-button-press (point)))

;; (widget-get (widget-at-point) :options)
(defun widget-show-properties-here ()
  (interactive)
  (with-current-buffer (btv (plist-get-keys (widget-at (point))))
    (emacs-lisp-mode)))

(defun widget-get-action (widget &optional event)
  ""
  (let ((a (widget-get widget :action)))
    (if (eq a 'widget-parent-action)
        (widget-get-action (widget-get widget :parent))
      a)))

(defun copy-widget-action ()
  (interactive)
  (xc (let ((button (get-char-property (point) 'button)))
        (if button
            (widget-get-action button)
          (lookup-key widget-global-map (this-command-keys))))))

(defun goto-widget-action ()
  (interactive)
  (find-function (let ((button (get-char-property (point) 'button)))
                   (if button
                       (widget-get-action button)
                     (lookup-key widget-global-map (this-command-keys))))))

;; The context functions should really be able to support multiple
;; suggested functions.
;; Maybe it does.

(loop for (ps f) in
      context-tuples
      collect
      ps)

(defun show-suggest-funcs-context-menu ()
  (interactive)
  (let ((ctxmenu
         (let ((body
                (loop for f in (suggest-funcs-collect) collect
                      `(,(sym2str f) :call (,f)))))
           (eval
            `(def-right-click-menu suggest-funcs-context-menu-widget
               ',body)))))
    (call-interactively ctxmenu)))

(def-right-click-menu right-click-context-menu-widget
  '(("Copy action" :call (copy-widget-action)
     :if (widget-at (point)))
    ("Go to widget function" :call (goto-widget-action)
     :if (widget-at (point)))
    ("Push widget" :call (push-widget)
     :if (widget-at (point)))
    ("Show widget properties" :call (widget-show-properties-here)
     :if (widget-at (point)))
    ("Context functions" :call show-suggest-funcs-context-menu)
    ;; ("Cut" :call (kill-region (region-beginning) (region-end))
    ;;  :if (and (use-region-p) (not buffer-read-only)))
    ;; ("Paste" :call (yank) :if (not buffer-read-only))
    ;; ("Select Region"
    ;;  ("All" :call (mark-whole-buffer) :if (not (use-region-p)))
    ;;  ("Word" :call (mark-word))
    ;;  ("Paragraph" :call (mark-paragraph)))
    ))


(def-right-click-menu right-click-context-menu-widget
  '(("Copy action" :call (copy-widget-action)
     :if (widget-at (point)))
    ("Go to widget function" :call (goto-widget-action)
     :if (widget-at (point)))
    ("Push widget" :call (push-widget)
     :if (widget-at (point)))
    ("Show widget properties" :call (widget-show-properties-here)
     :if (widget-at (point)))
    ("Context functions" :call show-suggest-funcs-context-menu)
    ;; ("Cut" :call (kill-region (region-beginning) (region-end))
    ;;  :if (and (use-region-p) (not buffer-read-only)))
    ;; ("Paste" :call (yank) :if (not buffer-read-only))
    ;; ("Select Region"
    ;;  ("All" :call (mark-whole-buffer) :if (not (use-region-p)))
    ;;  ("Word" :call (mark-word))
    ;;  ("Paragraph" :call (mark-paragraph)))
    ))

(defun gpt-test-haskell ()
  (let ((lang ;; (pen-pf-test-if-text-is-haskell (selection))
         (detect-language (selection))))
    (message (concat "Language:" lang))
    (istr-match-p "Haskell" (message lang))))

(defun my-thing-at-point-needs-fixing-p ()
  (or (flyspell-overlay-here-p)))

(defun my-fix-thing-at-point ()
  (interactive)
  (cond
   ((flyspell-overlay-here-p) (my-auto-correct-word))))

(defun my-ratify-thing-at-point ()
  "opposite of my-fix-thing-at-point. It integrates into the lexicon"
  (interactive)
  (cond
   ((flyspell-overlay-here-p) (my-flyspell-add-word))))

;; This is so I can jump here
(defvar right-click-context-global-menu-tree-placeholder nil)
(setq right-click-context-global-menu-tree
      `(("Cancel" :call identity)
        ("Edit menu" :call (j 'right-click-context-global-menu-tree-placeholder))
        ("Go to definition" :call my-godef-or-global-references)
        ("Context functions" :call show-suggest-funcs-context-menu)
        ("Back" :call (call-interactively 'my-holy-jump))
        ("Fix thing here" :call (call-interactively 'my-fix-thing-at-point) :if (my-thing-at-point-needs-fixing-p))
        ("Ratify thing here" :call (call-interactively 'my-ratify-thing-at-point) :if (my-thing-at-point-needs-fixing-p))
        ("Bury buffer" :call (call-interactively 'bury-buffer))
        ("find-in-video" :call find-in-video :if (and (major-mode-p 'dired-mode)
                                                      (let ((p (sor (car (dired-get-marked-files)))))
                                                        (and p
                                                             (f-file-p p)
                                                             (or (string-equal (file-name-extension p) "mkv")
                                                                 (string-equal (file-name-extension p) "mp4")
                                                                 (string-equal (file-name-extension p) "avi"))))))
        ;; ("GPT-3"
        ;;  ("GPT-3: Convert Haskell to Clojure" :call pen-pf-translate-haskell-to-clojure :if (gpt-test-haskell)))
        ("GPT-3: Convert Haskell to Clojure" :call pen-pf-translate-haskell-to-clojure :if (gpt-test-haskell))
        ;; ("pen (code)"
        ;;  ((concat "asktutor (" (str major-mode) ")") :call pen-tutor-mode-assist :if (major-mode-p 'prog-mode)))
        ("pen (code)"
         ("asktutor" :call pen-tutor-mode-assist :if (major-mode-p 'prog-mode)))
        ("NLP"
         ("Summarize" :call (progn
                              (call-interactively 'pen-pf-eli5-explain-like-i-m-five)
                              (call-interactively 'fi-text-to-paras)) :if (selected-p))
         ("Vexate" :call (progn
                           (call-interactively 'pen-pf-complicated-explanation-of-how-to-x)
                           (call-interactively 'fi-text-to-paras)) :if (selected-p))
         ("Fast Paras" :call (call-interactively 'fi-text-to-paras-nosegregate) :if (selected-p))
         ("Paras" :call (call-interactively 'fi-text-to-paras) :if (selected-p))
         ("spaCy" :call (call-interactively 'sps-play-spacy) :if (selected-p))
         ("dict" :call (call-interactively 'dict-word) :if (and (selected-p)
                                                                (equal 1 (length (s-split " " (selection))))))
         ("ngram query replace" :call (call-interactively 'ngram-query-replace))
         ("find-anagrams" :call find-anagrams))
        ("save, git all below, push" :call (progn
                                             (message "Saving")
                                             (save-buffer)
                                             (message "Adding")
                                             (sh/git-add-all-below)
                                             (message "Pushing")
                                             (sn "vc p")
                                             (message "Done")))
        ("Open in VSCode" :call open-in-vscode :if (buffer-file-name))
        ("windows"
         ("only" :call delete-other-windows))
        ("buffer"
         ("Kill buffer" :call kill-buffer-immediately)
         ("Reopen buffer" :call kill-buffer-and-reopen)
         ("Previous" :call switch-to-previous-buffer))
        

        ;; We don't generate the menu system
        ;; The menu system must be static

        ;; ,(let* ((cfs (suggest-funcs-collect))
        ;;        (tups
        ;;         (loop for cf in cfs collect
        ;;               (list (str cf) :call cf))))
        ;;    (if tups
        ;;        (cons "context tups" tups)
        ;;      ))

        ("git"
         ("Add all below" :call sh/git-add-all-below))
        ("Copy" :call (kill-ring-save (region-beginning) (region-end))
         :if (use-region-p))
        ("Cut" :call (kill-region (region-beginning) (region-end))
         :if (and (use-region-p) (not buffer-read-only)))
        ("Paste" :call (yank) :if (not buffer-read-only))
        ("Undo" :call (undo-tree-undo))
        ("Scrape"
         ("URLS" :call etv-urls-in-region))
        ("sx" :call sx-search-lang
         :if (selected))
        ("sxi" :call sx-search-immediately-lang
         :if (selected))
        ("Select"
         ("Thing" :call my-select-thing-at-point)
         ("Paragraph" :call mark-paragraph)
         ("All" :call mark-whole-buffer))
        ("Babel enter" :call org-edit-special :if (org-in-src-block-p))
        ("Babel exit" :call org-edit-src-exit :if (org-src-edit-buffer-p))
        ("Glossary"
         ;; ("All"  :call (add-to-glossary-file-for-buffer) :if (use-region-p))
         ("Add" :call (call-interactively 'add-to-glossary-file-for-buffer))
         ("Link" :call (call-interactively 'glossary-add-link)))
        ;; ("Select Region"
        ;;  ("All"  :call (mark-whole-buffer) :if (not (use-region-p)))
        ;;  ("Word" :call (mark-word))
        ;;  ("Paragraph" :call (mark-paragraph)))
        ;; ("Text Convert"
        ;;  ("Downcase"   :call (downcase-region (region-beginning) (region-end)))
        ;;  ("Upcase"     :call (upcase-region (region-beginning) (region-end)))
        ;;  ("Capitalize" :call (capitalize-region (region-beginning) (region-end)))
        ;;  ("URL Encode" :call (right-click-context--process-region
        ;;                       (region-beginning) (region-end) 'url-encode-url))
        ;;  ("URL Decode" :call (right-click-context--process-region
        ;;                       (region-beginning) (region-end) 'right-click-context--url-decode))
        ;;  ("Comment Out" :call comment-dwim))
        ;; ("Go To"
        ;;  ("Top"    :call (goto-char (point-min)))
        ;;  ("Bottom" :call (goto-char (point-max)))
        ;;  ("Directory" :call (find-file default-directory)))
        ("Describe Character" :call (describe-char (point)) :if (not (use-region-p)))
        ("Button cloud" :call toggle-buttoncloud)))


;; TODO Start using buffer-local menus
;; (setq right-click-context-local-menu-tree)


;; This isn't a true right-click, but it's close enough
;; This is because I don't yet know of a way to emulate a mouse click without tmux
(define-key global-map (kbd "C-M-z") 'right-click-context-menu)

;; Have
;; (define-key right-click-context-mode-map (kbd "<next>") 'cua-scroll-down)
;; (define-key right-click-context-mode-map (kbd "next") nil)

(provide 'my-right-click-context)