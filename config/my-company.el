(require 'company)

;; This code will allow you to select intellisense options by pressing
;; the digit.

;; (setq company-auto-complete t)
;; (setq company-auto-complete-chars '(?\  ?\) ?.))

;; This is supposed to disable the automatic selection (and disappearance of completions list) of a completion candidate
;; But it doesn't seem to have affected deep tabnine
(setq company-auto-complete nil)
(setq company-auto-complete-chars '())

(setq company-minimum-prefix-length 0)

(add-hook 'after-init-hook 'global-company-mode)


;; (defvar company-active-map
;;   (let ((keymap (make-sparse-keymap)))
;;     (define-key keymap "\e\e\e" 'company-abort)
;;     (define-key keymap "\C-g" 'company-abort)
;;     (define-key keymap (kbd "M-n") 'company-select-next)
;;     (define-key keymap (kbd "M-p") 'company-select-previous)
;;     (define-key keymap (kbd "<down>") 'company-select-next-or-abort)
;;     (define-key keymap (kbd "<up>") 'company-select-previous-or-abort)
;;     (define-key keymap [remap scroll-up-command] 'company-next-page)
;;     (define-key keymap [remap scroll-down-command] 'company-previous-page)
;;     (define-key keymap [down-mouse-1] 'ignore)
;;     (define-key keymap [down-mouse-3] 'ignore)
;;     (define-key keymap [mouse-1] 'company-complete-mouse)
;;     (define-key keymap [mouse-3] 'company-select-mouse)
;;     (define-key keymap [up-mouse-1] 'ignore)
;;     (define-key keymap [up-mouse-3] 'ignore)
;;     (define-key keymap [return] 'company-complete-selection)
;;     (define-key keymap (kbd "RET") 'company-complete-selection)
;;     (define-key keymap [tab] 'company-complete-common)
;;     (define-key keymap (kbd "TAB") 'company-complete-common)
;;     (define-key keymap (kbd "<f1>") 'company-show-doc-buffer)
;;     (define-key keymap (kbd "C-h") 'company-show-doc-buffer)
;;     (define-key keymap "\C-w" 'company-show-location)
;;     (define-key keymap "\C-s" 'company-search-candidates)
;;     (define-key keymap "\C-\M-s" 'company-filter-candidates)
;;     (dotimes (i 10)
;;       (define-key keymap (read-kbd-macro (format "M-%d" i)) 'company-complete-number))
;;     keymap)
;;   "Keymap that is enabled during an active completion.")



(require 'company-tabnine)
;; This is needed to start it
(define-key global-map (kbd "M-~") #'company-complete)


(defun my-company-complete ()
  (interactive)
  ;; C-u should add to the backends
  ;; C-u C-u should erase the backends and select a new one

  (cond
   ((>= (prefix-numeric-value current-prefix-arg) 16)
    (setq my-company-selected-backends
          (list
           (str2sym (fz my-company-all-backends
                        nil nil "my-company-complete select:")))))
   ((>= (prefix-numeric-value current-prefix-arg) 4)
    (setq my-company-selected-backends
          (-uniq
           (cons
            (str2sym (fz my-company-all-backends
                         nil nil "my-company-complete add:"))
            my-company-selected-backends))))
   (t (let ((company-backends my-company-selected-backends))
        (if (equal (length company-backends) 1)
            (message (str (car company-backends))))
        (call-interactively 'company-complete)))))

(define-key global-map (kbd "C-M-i") #'my-company-complete)

;; (define-key global-map (kbd "M-1") #'helm-company)
(define-key global-map (kbd "M-2") #'company-lsp)

;; C-M-i is the same as M-C-i. No such thing as C-M-TAB.
(define-key global-map (kbd "M-SPC") #'indent-for-tab-command)

;; <M-TAB>
(define-key company-active-map (kbd "M-C-i") #'company-abort)

;; j:my-completion-at-point
;; (define-key global-map (kbd "M-~") #'company-complete)
;; (define-key global-map (kbd "M-~") #'company-complete)
(define-key company-active-map (kbd "M-~") #'company-abort)
(define-key company-active-map (kbd "M-~") #'company-abort)
;; (define-key company-active-map (kbd "M-C-i") #'company-complete-selection)

;; M-`
;; This appears to not be permanent
(define-key company-active-map (kbd "<prior>") #'company-previous-page)
(define-key company-active-map (kbd "<next>") #'company-next-page)
;; This is how to define company maps
(define-key company-active-map (kbd "<M-RET>") #'my/tvipe-company-candidates)
;; Also added it late because this binding does not stick
;; vim +/"(define-key company-active-map (kbd \"<RET>\") #'company-complete)" "$EMACSD/emacs"

(define-key company-active-map (kbd "C-o") #'my/tvipe-company-candidates)
(define-key company-active-map (kbd "C-c o") #'my/tvipe-company-candidates)
;; (define-key company-active-map (kbd "M-l") #'helm-company)
                                        ;Don't do this. I often need to go into evil mode. Also, there may be many other useful bindings in here
(define-key company-active-map (kbd "M-l") nil)
(define-key company-active-map (kbd "M-1") #'helm-company)

;; This fixes backspace in comments where 'dictionary' autocompletion appears using company-mode, but company uses C-h to "show documentation", which there is no documentation for.
;; (my/with 'company (define-key company-active-map (kbd "C-h") nil))
(define-key company-active-map (kbd "C-h") 'delete-backward-char)
;; (define-key company-active-map (kbd "SPC") 'self-insert-command)
(define-key company-active-map (kbd "SPC") nil)
(define-key company-active-map (kbd "(") 'self-insert-command)
;; (define-key company-active-map (kbd "C-h") nil)

;; (define-key company-mode-map (kbd "C-M-i") #'company-tabnine)
(setq company-show-numbers t)

(let ((map company-active-map))
  (mapc
   (lambda (x)
     (define-key map (format "%d" x)
       'ora-company-number))
   (number-sequence 0 9))
  (define-key map " "
    (lambda ()
      (interactive)
      (company-abort)
      (self-insert-command 1)))
  (define-key map (kbd "<return>")
    nil))

(defun ora-company-number ()
  "Forward to `company-complete-number'.

           Unless the number is potentially part of the candidate.
           In that case, insert the number."
  (interactive)
  (let* ((k (this-command-keys))
         (re (concat "^" company-prefix k)))
    (if (cl-find-if
         (lambda (s)
           (string-match re s))
         company-candidates)
        (self-insert-command 1)
      (company-complete-number
       (string-to-number k)))))

;; [[https://emacs.stackexchange.com/questions/712/what-are-the-differences-between-autocomplete-and-company-mode?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa][completion - What are the differences between autocomplete and company mode? - Emacs Stack Exchange]]
;; I've used autocomplete-mode for a good a few years and switched to company-mode a couple of months ago.
;; In basic usage there's not much of a difference. Like someone else posted this link has a good summary of the differences.
;; I found company-mode to be easier to configure and to let it do what I want it to. With autocomplete-mode I ran into issues now and then of something not working the way I wanted it to and then something else falling over when tweaking it. In usage, I rarely feel company-mode is in the way when using Emacs while autocomplete-mode did get in the way now and then.
;; Also, for developers it is easy to add support for their packages to company-mode, see: EmacsWiki:CompanyMode:Backends.
;; They are not compatible with each other. For now, there's more packages that support autocomplete-mode but that is changing fast.
;; tl;dr. They pretty much do the same thing. Start with company-mode and try autocomplete-mode if you miss anything from the former.
;; company-mode
;; Modular in-buffer completion framework for Emacs
;; Make company work everywhere. For some reason, cider tries to jack into a
;; clojure repl no matter which type of file im editing, as long as company mode
;; is on.
(setq company-global-modes
      '(not
        ESS-MODE
        org-mode
        emacs-lisp-mode
        markdown-mode))

(global-company-mode t)

;; (set 'company-idle-delay 0.1)
;; (set 'company-idle-delay 'now)
;; Trigger completion immediately.
;; Keep this. I think it helps
(setq company-idle-delay 0)
(setq company-minimum-prefix-length 1)

;; This breaks terminal emacs
(require 'company-childframe)

;; (company-childframe-mode 1)
(company-childframe-mode -1)

;; (setq company-tooltip-align-annotations t)
(setq company-tooltip-align-annotations
      nil)

;; I prefer highlighting to alignment in this case
(defun my/tvipe-company-candidates ()
  (interactive)
  ;; $HOME$MYGIT/spacemacs/packages27/company-20180315.439/company.el
  ;; (tvd
  ;;  (my/join
  ;;   company-candidates
  ;;   "\n"))
  (spsp "vs -ac"
        (my/join
         company-candidates
         "\n")))

(defun my-company-cancel ()
  (interactive)
  (company-cancel))

(require 'company-statistics)
(company-statistics-mode)

(provide 'my-company/go)

(setq company-tooltip-limit 20) ; bigger popup window
(setq company-idle-delay 0.3)  ; decrease delay before autocompletion popup shows
(setq company-echo-delay 0)    ; remove annoying blinking
(setq company-begin-commands '(self-insert-command)) ; start autocompletion only after typing


;; This appears to be the only reliable way to get company to load for a mode
;; (add-hook 'emacs-lisp-mode-hook #'company-mode)



;; This is the de-facto standard in-buffer completion package. In case
;; you're wondering, Company stands for Complete Anything.
;; (use-package company
;;            :demand t
;;            :bind (;; Replace `completion-at-point' and `complete-symbol' with
;;                   ;; `company-manual-begin'. You might think this could be put
;;                   ;; in the `:bind*' declaration below, but it seems that
;;                   ;; `bind-key*' does not work with remappings.
;;                   ([remap completion-at-point] . company-manual-begin)
;;                   ([remap complete-symbol] . company-manual-begin)

;;                   ;; The following are keybindings that take effect whenever
;;                   ;; the completions menu is visible, even if the user has not
;;                   ;; explicitly interacted with Company.

;;                   :map company-active-map

;;                   ;; Make TAB always complete the current selection. Note that
;;                   ;; <tab> is for windowed Emacs and TAB is for terminal Emacs.
;;                   ("<tab>" . company-complete-selection)
;;                   ("TAB" . company-complete-selection)

;;                   ;; Prevent SPC from ever triggering a completion.
;;                   ("SPC" . nil)

;;                   ;; The following are keybindings that only take effect if the
;;                   ;; user has explicitly interacted with Company.

;;                   :map company-active-map
;;                   :filter (company-explicit-action-p)

;;                   ;; Make RET trigger a completion if and only if the user has
;;                   ;; explicitly interacted with Company. Note that <return> is
;;                   ;; for windowed Emacs and RET is for terminal Emacs.
;;                   ("<return>" . company-complete-selection)
;;                   ("RET" . company-complete-selection)

;;                   ;; We then do the same for the up and down arrows. Note that
;;                   ;; we use `company-select-previous' instead of
;;                   ;; `company-select-previous-or-abort'. I think the former
;;                   ;; makes more sense since the general idea of this `company'
;;                   ;; configuration is to decide whether or not to steal
;;                   ;; keypresses based on whether the user has explicitly
;;                   ;; interacted with `company', not based on the number of
;;                   ;; candidates.

;;                   ("<up>" . company-select-previous)
;;                   ("<down>" . company-select-next))

;;            :bind* (;; The default keybinding for `completion-at-point' and
;;                    ;; `complete-symbol' is M-TAB or equivalently C-M-i. Here we
;;                    ;; make sure that no minor modes override this keybinding.
;;                    ("M-TAB" . company-manual-begin))

;;            :diminish company-mode
;;            :config

;;            ;; Turn on Company everywhere.
;;            (global-company-mode 1)

;;            ;; Show completions instantly, rather than after half a second.
;;            (setq company-idle-delay 0)

;;            ;; Show completions after typing a single character, rather than
;;            ;; after typing three characters.
;;            (setq company-minimum-prefix-length 1)

;;            ;; Show a maximum of 10 suggestions. This is the default but I think
;;            ;; it's best to be explicit.
;;            (setq company-tooltip-limit 10)

;;            ;; Always display the entire suggestion list onscreen, placing it
;;            ;; above the cursor if necessary.
;;            (setq company-tooltip-minimum company-tooltip-limit)

;;            ;; Always display suggestions in the tooltip, even if there is only
;;            ;; one. Also, don't display metadata in the echo area. (This
;;            ;; conflicts with ElDoc.)
;;            (setq company-frontends '(company-pseudo-tooltip-frontend))

;;            ;; Show quick-reference numbers in the tooltip. (Select a completion
;;            ;; with M-1 through M-0.)
;;            (setq company-show-numbers t)

;;            ;; Prevent non-matching input (which will dismiss the completions
;;            ;; menu), but only if the user interacts explicitly with Company.
;;            (setq company-require-match #'company-explicit-action-p)

;;            ;; Company appears to override our settings in `company-active-map'
;;            ;; based on `company-auto-complete-chars'. Turning it off ensures we
;;            ;; have full control.
;;            (setq company-auto-complete-chars nil)

;;            ;; Prevent Company completions from being lowercased in the
;;            ;; completion menu. This has only been observed to happen for
;;            ;; comments and strings in Clojure.
;;            (setq company-dabbrev-downcase nil)

;;            ;; Only search the current buffer to get suggestions for
;;            ;; company-dabbrev (a backend that creates suggestions from text
;;            ;; found in your buffers). This prevents Company from causing lag
;;            ;; once you have a lot of buffers open.
;;            (setq company-dabbrev-other-buffers nil)

;;            ;; Make company-dabbrev case-sensitive. Case insensitivity seems
;;            ;; like a great idea, but it turns out to look really bad when you
;;            ;; have domain-specific words that have particular casing.
;;            (setq company-dabbrev-ignore-case nil)

;;            ;; Make it so that Company's keymap overrides Yasnippet's keymap
;;            ;; when a snippet is active. This way, you can TAB to complete a
;;            ;; suggestion for the current field in a snippet, and then TAB to
;;            ;; move to the next field. Plus, C-g will dismiss the Company
;;            ;; completions menu rather than cancelling the snippet and moving
;;            ;; the cursor while leaving the completions menu on-screen in the
;;            ;; same location.

;;            (with-eval-after-load 'yasnippet
;;              ;; TODO: this is all a horrible hack, can it be done with
;;              ;; `bind-key' instead?

;;              ;; This function translates the "event types" I get from
;;              ;; `map-keymap' into things that I can pass to `lookup-key'
;;              ;; and `define-key'. It's a hack, and I'd like to find a
;;              ;; built-in function that accomplishes the same thing while
;;              ;; taking care of any edge cases I might have missed in this
;;              ;; ad-hoc solution.
;;              (defun radian--normalize-event (event)
;;                (if (vectorp event)
;;                    event
;;                  (vector event)))

;;              ;; Here we define a hybrid keymap that delegates first to
;;              ;; `company-active-map' and then to `yas-keymap'.
;;              (setq radian--yas-company-keymap
;;                    ;; It starts out as a copy of `yas-keymap', and then we
;;                    ;; merge in all of the bindings from
;;                    ;; `company-active-map'.
;;                    (let ((keymap (copy-keymap yas-keymap)))
;;                      (map-keymap
;;                       (lambda (event company-cmd)
;;                         (let* ((event (radian--normalize-event event))
;;                                (yas-cmd (lookup-key yas-keymap event)))
;;                           ;; Here we use an extended menu item with the
;;                           ;; `:filter' option, which allows us to
;;                           ;; dynamically decide which command we want to
;;                           ;; run when a key is pressed.
;;                           (define-key keymap event
;;                             `(menu-item
;;                               nil ,company-cmd :filter
;;                               (lambda (cmd)
;;                                 ;; There doesn't seem to be any obvious
;;                                 ;; function from Company to tell whether or
;;                                 ;; not a completion is in progress (à la
;;                                 ;; `company-explicit-action-p'), so I just
;;                                 ;; check whether or not `company-my-keymap'
;;                                 ;; is defined, which seems to be good
;;                                 ;; enough.
;;                                 (if company-my-keymap
;;                                     ',company-cmd
;;                                   ',yas-cmd))))))
;;                       company-active-map)
;;                      keymap))

;;              ;; The function `yas--make-control-overlay' uses the current
;;              ;; value of `yas-keymap' to build the Yasnippet overlay, so to
;;              ;; override the Yasnippet keymap we only need to dynamically
;;              ;; rebind `yas-keymap' for the duration of that function.
;;              (defun radian--advice-company-overrides-yasnippet
;;                  (yas--make-control-overlay &rest args)
;;                "Allow `company' to override `yasnippet'.
;; This is an `:around' advice for `yas--make-control-overlay'."
;;                (let ((yas-keymap radian--yas-company-keymap))
;;                  (apply yas--make-control-overlay args)))

;;              (advice-add #'yas--make-control-overlay :around
;;                          #'radian--advice-company-overrides-yasnippet)))


(defun my-company-abort-and-yasnippet ()
  (interactive)
  (company-abort)
  (call-interactively 'company-yasnippet))

(defun my-company-abort-and-lsp ()
  (interactive)
  (company-abort)
  (call-interactively 'company-lsp))

(define-key company-active-map (kbd "M-2") 'my-company-abort-and-lsp)
(define-key company-active-map (kbd "M-5") 'my-company-abort-and-yasnippet)


;; (use-package company-box
;;   :hook (company-mode . company-box-mode))

;; Or:
;; (require 'company-box)
;; (add-hook 'company-mode-hook 'company-box-mode)


(setq company-frontends '(company-pseudo-tooltip-frontend))

(setq company-frontends '(company-pseudo-tooltip-unless-just-one-frontend
                          company-preview-if-just-one-frontend
                          company-echo-metadata-frontend))


(defun company-complete-selection ()
  "Insert the selected candidate."
  (interactive)
  ;; (ns "hi")
  (when (and (company-manual-begin) company-selection)
    (let ((result (nth company-selection company-candidates)))
      (company-finish result))))

;; (define-key company-active-map (kbd "<RET>") #'company-complete)
(define-key company-active-map (kbd "RET") 'company-complete-selection)


;; (setq company-frontends '(company-preview-if-just-one-frontend company-echo-metadata-frontend))



;; https://github.com/xenodium/company-org-block

;; (straight-use-package 'company-org-block)
(straight-use-package
 '(company-org-block :type git :host github :repo "xenodium/company-org-block"))
(require 'company-org-block)
(setq company-org-block-edit-style 'auto) ;; 'auto, 'prompt, or 'inline
(add-hook 'org-mode-hook
          (lambda ()
            (add-to-list (make-local-variable 'company-backends)
                         'company-org-block)))


;; Fuzzy search this list to select a completion backends
(defset my-company-all-backends
  '(
    ;; These arse not company completion backends, but I should generate some from them
    ;; pen-pf-generic-file-type-completion
    ;; pen-pf-generic-completion-200-tokens-max
    ;; pen-pf-generic-completion-50-tokens-max-hash
    ;; pen-pf-shell-bash-terminal-command-completion
    company-pen-filetype
    company-complete
    company-tabnine
    company-yasnippet
    company-lsp
    ;; pen-complete-long
    company-org-block))

;; Have my own company-backends and use let around company-complete
;; Use M-TAB
;; | =M-~= | =company-complete= | =global-map=

(defset my-company-selected-backends '(pen-complete-long))


(provide 'my-company)