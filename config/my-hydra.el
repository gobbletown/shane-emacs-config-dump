;; Stop using hydra for normal menus
;; I must convert this.

(use-package hydra
  :ensure t)


;; This file is a bitch
;; Hydra was a mistake

;; TODO
;; Make it so my hydra does not need to save files to do in-place sed replacements for things like erase-empty-whitespace.

;; All ":idle 1" have been removed
;; For nested hydras, this is terrible
;; I should only use idle for the initial hydra. It still flickers on successive hydras
;; Alternatively, the first hydra should
;; I should not use a hydra for the inital key


;; Doen't work
;; (progn
;;   ;; This doesn't fix the prefix problem
;;   (define-prefix-command 'my-prefix-m-l)
;;   (global-set-key (kbd "M-'") 'my-prefix-m-l)
;;   (global-set-key (kbd "M-l") 'my-prefix-m-l)

;;   ;; This doesn't fix the prefix problem
;;   (define-prefix-command 'my-prefix-m-le)
;;   (global-set-key (kbd "M-' M-e") 'my-prefix-m-le)
;;   (global-set-key (kbd "M-l M-e") 'my-prefix-m-le))



(require 'my-utils)
(require 'evil)
(require 'my-auto-complete)
(require 'selected)
(require 'my-hydra-window)
(require 'ace-window)                   ; for maximize window


(defmacro sslk (kb &rest body)
  "This lets me write more terse code"

  ;; This was =and nil= anyway so it shouldnt hurt to remove it
  ;; (if (and nil (is-spacemacs))
  ;;     (setq kb (s-replace-regexp "M-" "" kb)))

  (let ((f (car body))
        ;; (prefix (s-replace-regexp ".$" "" kb))
        )
    `(progn
       ;; (define-prefix-command 'my-prefix-m-g)
       ;; (global-set-key (kbd "M-g") 'my-prefix-m-g)

       ;; (define-key global-map (kbd (concat "M-m" (sed "s/./ &/g" ,kb))) ,f)
       ;; (define-key global-map (kbd (concat "M-m" (sed "s/./ M-&/g" ,kb))) ,f)

       ;; (if (is-spacemacs)
       ;;     (progn (spacemacs/declare-prefix ,prefix ,prefix)
       ;;             (spacemacs/set-leader-keys ,kb ,f)
       ;;             ;; (spacemacs/set-leader-keys ,(concat "M-" kb) ,f)
       ;;             ))

       ;; Instead of doing these seds, use a combination
       ;; Do combinations of combinations. i.e. Allow =M-m M-f r= rather than merely =M-m M-F M-R= and =M-m f r=
       (let ((spaced
              ;; (sed "s/./& /g" ,kb)
              (s-replace-regexp "\\(.\\)" "\\1 " ,kb)
              )
             (spaced-m
              ;; (sed "s/./M-& /g" ,kb)
              (s-replace-regexp "\\(.\\)" "M-\\1 " ,kb)))

         ;; (-cartesian-product '(my-mode-map global-map) '("^l" "M-'") '(spaced spaced-m))
         (ignore-errors (define-key my-mode-map (kbd (s-replace-regexp "^l" "M-'" (s-replace-regexp " $" "" spaced))) ,f))
         (ignore-errors (define-key global-map (kbd (concat "M-" (s-replace-regexp " $" "" spaced))) ,f))
         (ignore-errors (define-key my-mode-map (kbd (s-replace-regexp "^l" "M-m" (s-replace-regexp " $" "" spaced))) ,f))
         (ignore-errors (define-key my-mode-map (kbd (s-replace-regexp "^M-l" "M-m" (s-replace-regexp " $" "" spaced-m))) ,f))
         (ignore-errors (define-key my-mode-map (kbd (s-replace-regexp "^M-l" "M-'" (s-replace-regexp " $" "" spaced-m))) ,f))
         (ignore-errors (define-key global-map (kbd (s-replace-regexp " $" "" spaced-m)) ,f)))

       ;; Using our own menu, not the spacemacs one. So don't use spacemacs/declare-prefix
       )))

;; Used by my-spacemacs.el, later
(if (is-spacemacs)
    (progn
      (spacemacs/declare-prefix "y" "own-menu")
      ;; Unmap existing
      ;; No need to unmap anymore.
      ;; (define-key spacemacs-default-map-root-map (kbd "M-m l") nil)

      ;; (spacemacs/declare-prefix "l" "own-general")
      ;; (spacemacs/declare-prefix "lr" "sh-rc")
      ;; (spacemacs/declare-prefix "g" "go to")
      ;; (spacemacs/declare-prefix "gd" "go to thing")
      ;; (spacemacs/declare-prefix "lp" "sh-playground")
      ;; (spacemacs/declare-prefix "lz" "sh-fuzzy")
      ;; (spacemacs/declare-prefix "lP" "sh-playground-edit")
      ;; (spacemacs/declare-prefix "l;" "sh-repl")
      ))



(require 'link-hint)

;; My plan for this file must be for it to become as easy as possible to extend with the minimal number of keys
;; Everything must be written in lisp
;; emacs-lisp is literally the future


;; Unbind a bunch of keys
;; (dolist (key
;;          '("C-a"
;;            "C-b"
;;            "C-c"
;;            "C-d"
;;            "C-e"
;;            "C-f"
;;            "C-g"
;;            "C-h"
;;            "C-k"
;;            "C-l"
;;            "C-n"
;;            "C-o"
;;            "C-p"
;;            "C-q"
;;            "C-t"
;;            "C-u"
;;            "C-v"
;;            "C-x"
;;            "C-z"
;;            ))
;;   (global-unset-key (kbd key)))


;; VISUAL below

;; I almost never use M-q bindings. Therefore, I should change it so that M-q is a hydra?
;; I shoudl change it so that M-q is a hydra anyway

;; I should build hydras with maps so that I am able to remember things more easily.
;; Those visual maps are so useful.


(defvar sel/hydra-stack nil)


(defun sel/hydra-push (expr)
  (push `(lambda () ,expr) sel/hydra-stack))

(defun sel/hydra-pop ()
  (interactive)
  (let ((x (pop sel/hydra-stack)))
    (when x
      (funcall x))))

(defun prehydra ()
  "happens before hydra appears"
  ;; (linum-mode 1)
  )



(defun posthydra ()
  "happens after hydra appears"
  ;; (linum-mode -1)
  )

;; Blue heads quit hydra. But I dont get a hydra until one of them is started
;; ("q" (cfilter "c wrl q") "wrl quote" :color blue)
;; :exit t makes all heads exit. no longer need :color blue
;; Single sexps are surrounded with (lambda () (interactive) ...)
;; Lispy breaks 'f' key. It's able to interfere with hydra. So use meta keys
;; (defun hya_filtering ()
;;   (progn (save-excursion (h_f/body) (sel/hydra-push '(h_x/body)))))

;; (defun hya_quoting ()
;;   (progn (save-excursion (h_q/body) (sel/hydra-push '(h_x/body)))))

;; (defun hya_refactoring ()
;;   (progn (save-excursion (h_r/body) (sel/hydra-push '(h_x/body)))))

;; (defun hya_transforming ()
;;   (progn (save-excursion (h_t/body) (sel/hydra-push '(h_x/body)))))

;; (defun hya_tools ()
;;   (progn (save-excursion (h_o/body) (sel/hydra-push '(h_x/body)))))

;; (defun hya_codesearch ()
;;   (progn (save-excursion (h_d/body) (sel/hydra-push '(h_x/body)))))

;; (defun hya_versioncontrol ()
;;   ;; Use the same hydra for both visual and normal
;;   (progn (save-excursion (h_nv/body) (sel/hydra-push '(h_x/body)))))



;; (defhydra h_x (:exit t ;; "VISUAL"
;;                      :pre (prehydra)
;;                      :post (posthydra)
;;                      :coelor blue
;;                      :hint nil
;;                      :columns 4

;;                      selected-keymap
;;                      "l")
;;   "VISUAL"
;;   ;; ("q"  sel/hydra-pop "exit")
;;   ("C-i" #'indent-region "Indent Region")

;;   ("1" #'delete-other-windows "only")
;;   ("0" #'delete-window "close")
;;   ("2" #'split-window-below "hsplit")
;;   ("3" #'split-window-right "vsplit")
;;   ("h" #'toggle-evil "Toggle Evil")

;;   ("m" #'switch-to-previous-buffer "alternate buffer")

;;   ;; This doesn't work. The ~ overrides it
;;   ;; ("`" 'other-window "Other window")
;;   ;; (";" 'other-window "Other window") ;This doesn't work either because 'other-window does nothing
;;   (";" (df h-other-window (other-window 1)) "Other window")

;;   ;; ("f" (hya_filtering) "filtering")
;;   ("q" (hya_quoting) "quoting")
;;   ("r" (hya_refactoring) "refactoring")
;;   ;; ("t" (hya_transforming) "transforming")
;;   ("t" #'tvipe "tvipe")
;;   ("t" (hya_transforming) "transforming")
;;   ("e" #'my-revert "Revert Buffer")
;;   ("w" #'my-save "Save Buffer")
;;   ("/" #'dack-selection-top "dack top")
;;   ("?" #'eack-selection "eack selection")
;;   ("o" #'hya_tools "tools")
;;   ("d" #'hya_codesearch "codesearch")
;;   ;; ("v" (hya_versioncontrol) "version control")
;;   ;; ("v" (hya_versioncontrol) "version control")
;;   ;; ("k" (progn (save-excursion (h_nc/body) (norm/hydra-push '(h_nx/body)))) "commands")
;;   )



(defun show_hydra ()
  "Start my main hydra."
  (interactive)
  (if (region-active-p)
      (let ((rstart (region-beginning))
            (rend (region-end)))
        (h_x/body))
    (h_nx/body)))



;; Keep this enabled until I start using which-key
;; (define-key my-mode-map (kbd "M-'") #'show_hydra)
;; (define-key my-mode-map (kbd "M-l") #'show_hydra)
;; (define-key selected-keymap (kbd "l") #'show_hydra)


;; (define-key my-mode-map (kbd "M-l") 'h_nx/body)


;; (defhydra h_q (:exit t ;; "VISUAL: quoting"
;;                      :pre (prehydra)
;;                      :post (posthydra)
;;                      :color blue
;;                      :hint nil
;;                      :columns 4)
;;   "VISUAL: quoting"
;;   ;; ("q" (cfilter "s awrl 'q -ftl'") "wrl quote")
;;   ("q" (wrl_q) "wrl quote")
;;   ("u" (wrl_uq) "wrl unquote")
;;   ("n" (wrl_qne) "wrl quote no ends")
;;   ;; (","  sel/hydra-pop "exit" :color blue)
;;   )

(defun erase_starting_whitespace ()
  "Use sed to erase starting whitespace."
  (cfilter "sed 's/^\\s\\+//'"))

(defun erase_surrounding_whitespace ()
  "Use sed to erase surrounding whitespace."
  (concat "sed 's/\\s\\+$//'"))

;; (defhydra h_r (:exit t ;; "VISUAL: refactoring"
;;                      :pre (prehydra)
;;                      :post (posthydra)
;;                      :color blue
;;                      :hint nil
;;                      :columns 4)
;;   "VISUAL: refactoring"
;;   ("E" (erase_starting_whitespace) "erase starting whitespace")
;;   ("e" (erase_surrounding_whitespace) "erase free/end whitespace")
;;   ("f" (fixup-whitespace) "fixup whitespace")
;;   ("8" (cfilter "autopep8") "autopep8"))



(defun search_code ()
  (interactive)
  (cfilter "tee >(tm -f -S -tout spv \"searchcode | sp\")"))


(defun google_example ()
  (interactive (list (if (buffer-file-name)
                         (file-name-extension (buffer-file-name))
                       (read-string-hist "egr ext/lang: "))
                     (my/thing-at-point)))
  ;; (cfilter (concat "tee >(tm -f -S -tout nw \"cs g " (file-name-extension (buffer-file-name)) "\")"))
  (term-sps (concat "cs g " (q ext) " " (q query))))


(defun google_example_literal (ext query)
  (interactive (list (if (buffer-file-name)
                         (file-name-extension (buffer-file-name))
                       (read-string-hist "egr ext/lang: "))
                     (my/thing-at-point)))
  (term-sps (concat "cs g -l " (q ext) " " (q query)))
  ;; (cfilter (concat "tee >(tm -f -S -tout nw \"cs g -l " (file-name-extension (buffer-file-name)) "\")"))
  )


;; Make something that optionaly produces a hydra or something else?
;; Nah, forget hydra. Convert the code and move on.
(defmacro mkhydra (name &rest body)
  ""
  `'(defhydra ,name (:exit t
                           :pre (prehydra)
                           :post (posthydra)
                           :color blue
                           :hint nil
                           :columns 4)
      ,@body))

(defmacro convert-hydra-to-sslk (prefix hydra)
  "Generates regular bindings from hydra defintion"
  ;; (tail hydra)
  (cons 'progn
        (let ((result
               (-slice hydra 3)))
          (if (stringp (car result))
              (setq result (tail result)))
          ;; (tvipe result)
          ;; (message (str result))

          (setq result
                (mapcar
                 (lambda (l)
                   (-map-indexed
                    (lambda (index item)
                      (if (= index 0) (concat prefix item) item))
                    l))
                 result))

          ;; (mapcar 'cons)
          (cons `(sslk ,prefix nil)
                (mapcar (lambda (l) (cons 'sslk l)) result))

          ;; (-slice result 1)
          )))


;; Put some hydras in here


;; I should make hydras and select bindings for org mode. This way I can map all the keys and learn the whole lot.



;; (use-package selected
;;   :ensure t
;;   :commands selected-minor-mode
;;   :bind (:map selected-keymap
;;               ("q" . selected-off)
;;               ("u" . upcase-region)
;;               ("d" . downcase-region)
;;               ("w" . count-words-region)
;;               ("m" . apply-macro-to-region-lines)))

;; end VISUAL

(require 'my-yasnippet)

;; NORMAL below

;; This is not allowed
;; (dolist (key
;;          '("M-l"
;;            "M-c"
;;            "M-L"
;;            "M-'"))
;;   (global-unset-key (kbd key)))



(global-unset-key "\e'")

;; TODO build macros for defining key bindings and remove hydra

;; This is way nicer than hydra. But keys must be redefined one at a time...
;; I should start creating some list convenience functions
;; (setq my/prefixkey "\e' ")

;; Ideally, I would simpy use these kinds of bindings, but I need to make macros for this first
;; I need M-' and M-l to work exactly the same way. So disable this for now
;; (progn ()
;;        (setq my/prefixkey "M-' ")
;;        (define-key my-mode-map (kbd (concat my/prefixkey "M-l")) 'copy-current-line-position-to-clipboard)
;;        (define-key global-map (kbd (concat my/prefixkey "M-n")) 'helm-buffers-list)
;;        (define-key global-map (kbd (concat my/prefixkey "M-e")) 'my-revert)
;;        (define-key global-map (kbd (concat my/prefixkey "M-h")) 'toggle-evil)
;;        (define-key global-map (kbd (concat my/prefixkey "M-w")) 'my-save)
;;        (define-key my-mode-map (kbd (concat my/prefixkey "M-l")) 'my/yas-complete)
;;        (define-key global-map (kbd (concat my/prefixkey "M-s M-d")) 'yas-visit-snippet-file)
;;        (define-key global-map (kbd (concat my/prefixkey "M-s M-n")) 'yas-new-snippet)
;;        (define-key global-map (kbd (concat my/prefixkey "M-s M-l")) 'yas-expand)

;;        (defun my/quote () (interactive) (cfilter "q -ftln"))
;;        (defun my/unquote () (interactive) (cfilter "uq -ftln"))
;;        (defun my/quotenoends () (interactive) (cfilter "qne -ftln"))
;;        (defun my/erase-free-whitespace () (interactive) (bash (concat "sed -i 's/\\s\\+$//' \"" buffer-file-name "\"")) "erase free whitespace")
;;        (define-key global-map (kbd (concat my/prefixkey "M-q M-q")) #'my/quote)
;;        (define-key global-map (kbd (concat my/prefixkey "M-q M-u")) #'my/unquote)
;;        (define-key global-map (kbd (concat my/prefixkey "M-q M-n")) #'my/quotenoends)
;;        (define-key global-map (kbd (concat my/prefixkey "M-r M-e")) #'my/erase-free-whitespace)
;;        (define-key global-map (kbd (concat my/prefixkey "M-a M-h")) #'rotate:even-vertical) ; I like to swap these around. It makes more sense to me
;;        (define-key global-map (kbd (concat my/prefixkey "M-a M-v")) #'rotate:even-horizontal)
;;        (define-key global-map (kbd (concat my/prefixkey "M-a M-t")) #'rotate:tiled)
;;        (define-key global-map (kbd (concat my/prefixkey "M-a M-r")) #'rotate-layout)
;;        (define-key global-map (kbd (concat my/prefixkey "M-k M-l")) #'helm-show-kill-ring)
;;        (define-key global-map (kbd (concat my/prefixkey "M-k M-p")) #'org-plot/gnuplot)
;;        (define-key global-map (kbd (concat my/prefixkey "M-k M-f")) #'helm-do-grep-ag)
;;        (define-key global-map (kbd (concat my/prefixkey "M-k M-c")) #'org-capture))


(require 'my-syntax-extensions)
(my-load "$MYGIT/config/emacs/config/hydra-org.el")

;; This is very slow to load
;; (my-load "$MYGIT/config/emacs/config/hydra-elfeed.el")

(defvar norm/hydra-stack nil)

(defun norm/hydra-push (expr)
  (push `(lambda () ,expr) norm/hydra-stack))

(defun norm/hydra-pop ()
  (interactive)
  (let ((x (pop norm/hydra-stack)))
    (when x
      (funcall x))))

(defun prehydra ()
"Code to execute before hydra appears."
;; (linum-mode 1)
)

(defun posthydra ()
"Code to execute after hydra disappears."
;; (linum-mode -1)
)

;; At the moment this hydra is used for both VISUAL and NORMAL.
;; Create separate hydras.

;; Visual is defined somewhere else. Where? selected.el

(require 'helm-config)

(defun helm-copy-to-clipboard ()
  "Copy selection or marked candidates to `helm-current-buffer'.
Note that the real values of candidates are copied and not the
display values."
  (interactive)
  (with-helm-alive-p
    (helm-run-after-exit
     (lambda (cands)
       (with-helm-current-buffer
         (insert (mapconcat (lambda (c)
                              (format "%s" c))
                            cands "\n"))))
     (helm-marked-candidates))))

;; Blue heads quit hydra. But I dont get a hydra until one of them is started
;; ("q" (cfilter "c wrl q") "wrl quote" :color blue)
;; :exit t makes all heads exit. no longer need :color blue
;; Single sexps are surrounded with (lambda () (interactive) ...)
;; Lispy breaks 'f' key. It's able to interfere with hydra. So use meta keys

; only for evil
;;(global-set-key
;; (kbd "M-L") 'h_nx/body)

;; (define-key evil-insert-state-map (kbd "M-L") 'h_nx/body)
;; (define-key evil-normal-state-map (kbd "M-L") 'h_nx/body)

; keep this. it's so much better for Holy mode
;; (define-key my-mode-map (kbd "M-l") 'h_nx/body)

;; (convert-hydra-to-sslk "lf"
;; (defhydra h_nf (:exit t :pre (prehydra) :post (posthydra) :color blue :hint nil :columns 4) ;; "NORMAL: filtering"
;;   "NORMAL: filtering"
;;   ("u" (df uniq (cfilter "s uniq")) "uniq no sort")
;;   ("m" (df mnm (cfilter "mnm")) "minimise")
;;   ("M" (df umn (cfilter "umn")) "unminimise")
;;   ("a" (df sort-anum (cfilter "s sort-anum")) "sort anum")
;;   ("A" (df c-anum (cfilter "c anum")) "[:anum:]")
;;   ("S" (df c-nosymbol (cfilter "c nosymbol")) "no-symbols")
;;   ("b" (df bibclean (cfilter "bibclean")) "bibclean. syntax check")
;;   ;; ("q" (cfilter "q -ftln") "wrl quote")
;;   ("q" (df qftln (filter-selection 'qftln)) "wrl quote")
;;   ("U" (df uqftln (cfilter "uq -ftln")) "wrl unquote")
;;   ("N" (df qneftln (cfilter "qne -ftln")) "wrl quote no ends")
;;   ;; (","  sel/hydra-pop "exit" :color blue)
;;   ))

(defun tmux-kill-other ()
  ""
  (interactive)
  (b tm kill-other))

(defun other-window-1 ()
  ""
  (interactive)
  (other-window 1))

;; This unbinds M-l so it must come first
(convert-hydra-to-sslk "l"
                       (defhydra h_nx (;; "NORMAL"
                                       :exit t
                                       :pre (prehydra)
                                       :post (posthydra)
                                       :color blue
                                       :hint nil
                                       :columns 4

                                       global-map "l"
                                       )
                         "NORMAL"

                         ("*" #'my/evil-star "evil star")
                         ;; ("8" #'my/evil-star "evil star")
                         ;; ("q"  norm/hydra-pop "exit")
                         ;; This works. It uses the first caption and combines the commands
                         ;; ("w" #'hydra-window/body "window hydra")
                         ;; purcell doesn't like ov-highlight
                         ;; ("|" #'ov-highlight/body "ov-highlight hydra")
                         ;; ("K" #'tmux-kill-other "Kill other tmux")
                         ;; (")" #'tmux-kill-other "Kill other tmux")
                         ("(" 'fz-find-dir "fz-find-dir")
                         ("O" 'fz-find-ws "fz-find-ws")
                         (")" 'fz-find-src "fz-find-src")
                         ("T" #'fz-find-file "fz-find-config")
                         ;; Use the hydra under "commands"
                         ;; ("~" #'menu-bar-open "Menu bar")
                         ("~" #'lacarte-execute-menu-command "helm menu bar")
                         ("'" #'magit-diff-unstaged-this "vim diff unstaged here")
                         ("\"" #'magit-diff-unstaged "vim diff unstaged")
                         ("J" #'magit-log "magit log")
                         ;; ("'" #'evil-insert-digraph "insert digraph")
                         ;; ("'" #'git-d-cached "git d cached")
                         ;; Can't do this because I need w to be a prefix key
                         ;; ("w" #'my-save "Save Buffer")
                         ;; ("`" 'other-window "Other window") ; the first 2 args here don't work
                         (";" #'other-window-1 "Other window")

                         ;; This may have broken it. Can't have a menu and key the same
                         ;; ("o" #'other-window-1 "Other window")
                         ("m" #'switch-to-previous-buffer "alternate buffer")
                         ;; ("f" #'link-hint-open-link "open link")
                         ("y" #'link-hint-copy-link "copy link")
                         ;; ("q" #'my-quit "quit emacs frame")
                         ;; ("e" #'my-revert "revert")
                         ;; Apps menu
                         ;; ("a" #'kill-buffer-and-window "Kill buffer and window")
                         ("K" #'kill-buffer-and-reopen "Kill buffer and load file")
                         ;; ("k" (kill-buffer) "Kill buffer")
                         ;; ("r" #'rotate-layout "Rotate layout")
                         (">" #'rotate-layout "Rotate layout")
                         ("O" #'rotate:even-horizontal "Horizontal")
                         ;; ("u" #'undo-tree-undo "undo")
                         ("u" #'new-buffer-from-tmux-pane-capture "capture pane")
                         ("U" #'new-buffer-from-tmux-main-capture "capture localhost")
                         ("R" #'new-buffer-from-tmux-main-capture-to-english "capture localhost to english")
                         ("1" #'delete-other-windows "only")
                         ("0" #'delete-window "close")
                         ("2" #'split-window-below "hsplit")
                         ("3" #'split-window-right "vsplit")
                         ;; ("h" #'spv "sh v split")
                         ;; ("H" #'sph "sh h split")
                         ("S" #'spv "sh v split")

                         ;; ("i" #'package-install "Install Package")
                         ("D" #'my-swipe "swiper")
                         ("M" #'git-timemachine "git timemachine")
                         ;; ("t" #'x/git-add-all-below "add all below")

                         ("9" #'describe-foo-at-point "describe")
                         ;; ("E" #'my-revert "Revert Buffer")
                         ("h" #'toggle-evil "Toggle Evil")
                         ("l" #'my/yas-complete "yasnippet menu")
                         ("b" #'list-buffers "List buffers")
                         ;; ("p" (progn (save-excursion (h_n_normal_properties/body) (norm/hydra-push '(h_nx/body)))) "properties")
                         ;; ("c" (progn (save-excursion (h_n_normal_customize/body) (norm/hydra-push '(h_nx/body)))) "customize")
                         ;; ("1" (progn (save-excursion (h_n_lingo/body) (norm/hydra-push '(h_nx/body)))) "customize")
                         ;; ("f" (progn (save-excursion (h_nf/body) (norm/hydra-push '(h_nx/body)))) "filtering")
                         ;; ("o" (progn (save-excursion (h_no/body) (norm/hydra-push '(h_nx/body)))) "occur")
                         ;; ("q" (progn (save-excursion (h_nq/body) (norm/hydra-push '(h_nx/body)))) "quoting")
                         ;; ("s" (progn (save-excursion (h_ns/body) (norm/hydra-push '(h_nx/body)))) "snippets")
                         ;; ("r" (progn (save-excursion (h_nr/body) (norm/hydra-push '(h_nx/body)))) "refactoring")
                         ;; ("a" (progn (save-excursion (h_na/body) (norm/hydra-push '(h_nx/body)))) "appearance")
                         ;; ("k" (progn (save-excursion (h_nc/body) (norm/hydra-push '(h_nx/body)))) "commands")
                         ;; ("g" (progn (save-excursion (h_ng/body) (norm/hydra-push '(h_nx/body)))) "git")
                         ;; ("t" (progn (save-excursion (h_nt/body) (norm/hydra-push '(h_nx/body)))) "tmux")

                         ;; DISCARD this is now tmux menu
                         ;; ("t" #'tvipe "tvipe")
                         ;; ("t" #'tvipe "tvipe")

                         ;; ("e" (progn (save-excursion (h_ne/body) (norm/hydra-push '(h_nx/body)))) "emacs")
                         ;; ("p" (progn (save-excursion (h_np/body) (norm/hydra-push '(h_nx/body)))) "packages")
                         ;; ("/" (progn (save-excursion (h_nAC/body) (norm/hydra-push '(h_nx/body)))) "auto-complete")
                         ;; ("j" (progn (save-excursion (h_normal_fuzzy_select/body) (norm/hydra-push '(h_nx/body)))) "fuzzy select")
                         ;; ("/" (progn (save-excursion (h_n_normal_search/body) (norm/hydra-push '(h_nx/body)))) "search")
                         ;; ("x" (progn (save-excursion (h_n_normal_x/body) (norm/hydra-push '(h_nx/body)))) "search")
                         ;; ("v" (hya_versioncontrol) "version control")
                         ))

(convert-hydra-to-sslk "lo"
                       (defhydra h_o (:exit t :pre (prehydra) :post (posthydra) :color blue :hint nil :columns 4) ;; "VISUAL: tools"
                         "VISUAL: tools"
                         ("e" (dff (rfilter (lambda (s) (concat "[[egr:" s "]]")))) "egr")
                         ("l" (df h-org-clink (cfilter "oc")) "oc")
                         ("L" (df h-org-clink-u (cfilter "org clink -u")) "org clink -u")
                         ("g" (df h-org-clink-g (cfilter "org clink -g")) "org clink -g")
                         ("u" 'h-org-clink-u "org clink -u")))


;; I'm not sure why this was broken
;; (convert-hydra-to-sslk "lO"
;;                        (defhydra h_no (:exit t :pre (prehydra) :post (posthydra) :color blue :hint nil :columns 4) ;; "NORMAL: occur"
;;                          "NORMAL: occur"
;;                          ("a" #'all-occur "all-occur")))




;; transformations
(convert-hydra-to-sslk "lf"
                       (defhydra h_f (:exit t :pre (prehydra) :post (posthydra) :color blue :hint nil :columns 4) ;; "VISUAL: filtering"
                         "VISUAL: filtering"
                         ;; ("z" #'filter-selection-with-fzf "apply selected filter from fzf")
                         ("z" #'my/fwfzf "filter by external filter")
                         ("Z" #'fz-filter-by-elisp-function "filter by elisp function")
                         ("d" #'major-mode-filter "filter by major mode function")
                         ("f" (df fi-with-fzf (cfilter "tm filter")) "filter with fzf")
                         ("E" (df erase-starting-ws () (sh-notty (concat "sed -i 's/^\\s\\+//' " (q buffer-file-name)))) "erase starting whitespace")
                         ("e" (df efs () (sh-notty (concat "sed -i 's/\\s\\+$//' " (q buffer-file-name)))) "erase free/end whitespace")
                         ("8" (df pep8 () (bash (concat "autopep8 -i \"" buffer-file-name "\""))) "autopep8")
                         ("W" (df fixup-whitespace-line (fixup-whitespace)) "fixup whitespace") ; this only works on a single line
                         ("U" (df fi-uniqnosort (cfilter "s uniq")) "uniq no sort")
                         ("u" (df fi-uqftln (cfilter "uq -ftln")) "wrl unquote")
                         (")" (df fi-wrl-parens (cfilter "wrlp surround '(' ')'")) "wrl parens")
                         ("m" (df fi-mnm (cfilter "mnm")) "minimise")
                         ("b" (df fi-abbreviate (cfilter "abbreviate")) "acronymise / abbreviate")
                         ("M" (df fi-umn (cfilter "umn")) "unminimise")
                         ("o" (df fi-sort-anum (cfilter "s sort-anum")) "sort anum")
                         ("a" (df fi-ascify (cfilter "c ascify")) "ascify")
                         ("A" (df fi-anum (cfilter "c anum")) "[:anum:]")
                         ;; this is save
                         ;; ("s" (df fi-summarize (cfilter "s summarize")) "summarize")
                         ;; Might as well get the extra bindings by redefining it
                         ;; ("s" 'save-buffer "save-buffer")
                         ("s" 'my-save "save-buffer")
                         ("S" (df fi-nosymbol (cfilter "c nosymbol")) "no-symbols")
                         ("q" (df fi-qftln (cfilter "q -ftln")) "wrl quote")
                         ;; ("q" (df fi-qftln (filter-selection 'qftln)) "wrl quote")
                         ("c" (df fi-upcase (filter-selection 'upcase)) "ucase")
                         ;; ("n" (df fi-uqftln) (cfilter "uq -ftln") "wrl unquote")
                         ("N" (df fi-qneftln (cfilter "qne -ftln")) "wrl quote no ends")
                         ;; (","  sel/hydra-pop "exit" :color blue)
                         ("l" #'downcase-region "lcase")
                         ("p" (df fi-text-to-paras (cfilter "text-to-paras")) "text-to-paras")
                         ;; ("u" upcase-region "ucase")
                         ("-" (df fi-underline (filter-selection 'udl)) "underline")
                         ("<" (df fi-orgunindent (cfilter "orgindent -1")) "org unindent")
                         (">" (df fi-orgindent (cfilter "orgindent")) "org indent")
                         ("," 'fi-unindent "org unindent")
                         ("." 'fi-indent "org indent")
                         ;; ("M--" (filter-selection 'udl) "underline")
                         ;; ("M-u" upcase-region "ucase")
                         ;; ("M-h" (cfilter "c html-decode") "html-decode")

                         ("t" (df fi-titlecase (cfilter "c title-case")) "title-case")
                         ;; ("m-,"  sel/hydra-pop "exit" :color blue)
                         ;; Add quoting for the transform hydra too
                         ;; ("q" (cfilter "q -ftln") "wrl quote")
                         ;; ("M-q" (cfilter "q -ftln") "wrl quote")
                         ;; ("Q" (cfilter "uq -ftln") "wrl unquote")
                         ))


(convert-hydra-to-sslk "lg"
                       (defhydra h_ng (:exit t :pre (prehydra) :post (posthydra) :color blue :hint nil :columns 4) ;; "NORMAL: git"
                         "NORMAL: git"
                         ("b" #'my/magit-blame-toggle "toggle magit blame")
                         ("q" #'magit-blame-quit "quit magit blame")
                         ("a" #'x/git-add-all-below "add all below")
                         ("t" #'sh/git-add-all-below "add all below")
                         ("m" #'sh/git-amend-all-below "amend below")
                         ("'" #'git-d-cached "git d cached")))

;; "lt" broke it because a "t" bindings existed in the "l" menu
(convert-hydra-to-sslk "lX"
                       (defhydra h_nt (:exit t :pre (prehydra) :post (posthydra) :color blue :hint nil :columns 4) ;; "NORMAL: tmux"
                         "NORMAL: tmux"
                         ("a" #'x/git-add-all-below "git add -A .")))

;; this will actually eval ((sslk...)) if it is left here in the init
;; file. (sslk...) is not a function or macro, but ssl is.
;; I should use this for expansion only.
;; Otherwise, I'd need a (cons 'progn m), where m is the macro result.
;;;; Use M-w to expand and test the macro

;;  TODO reinstitute this
;;  I think my-hydra is being loaded twice
;;  It's not idempotent atm

(defmacro unbind-sslk (prefix-chars)
  "Do not return anything."
  ;; body
  `(progn (,@body) nil))

;; ;; prefix with l at least
(convert-hydra-to-sslk "le"
                       (defhydra h_ne (:exit t :pre (prehydra) :post (posthydra) :color blue :hint nil :columns 4) ;; "NORMAL: emacs"
                         "NORMAL: emacs"
                         ("e" #'my-revert "revert")
                         ("x" #'kill-emacs "kill emacs")
                         ("c" #'revert-and-quit-emacsclient-without-killing-server "kill emacsclient")
                         ("m" #'kill-music "kill-music")
                         ("d" (df show-daemonp ()
                                  (let ((d (daemonp)))
                                    (if d
                                        (message d)
                                      (message "not a daemon")
                                      nil))))
                         ("r" #'restart-emacs "restart emacs")
                         ("q" #'my-quit "quit emacs frame")))

(convert-hydra-to-sslk "lq"
                       (defhydra h_nq (:exit t :pre (prehydra) :post (posthydra) :color blue :hint nil :columns 4) ;; "NORMAL: quoting"
                         "NORMAL: quoting"
                         ;; ("q" (cfilter "q -ftln") "wrl quote")
                         ("d" #'major-mode-function "run major mode function")
                         ("q" (df fi-wrl-quote (cfilter "qftln")) "wrl quote")
                         ("l" (df fi-wrl-quote (cfilter "qftln")) "wrl quote")
                         ("u" (df fi-wrl-unquote (cfilter "uq -ftln")) "wrl unquote")
                         ("n" (df fi-wrl-quote-ne (cfilter "qne -ftln")) "wrl quote no ends")))

(convert-hydra-to-sslk "lj"
                       (defhydra h_normal_fuzzy_select (:exit t :pre (prehydra) :post (posthydra) :color blue :hint nil :columns 4) ;; "NORMAL: fuzzy-select"
                         "NORMAL: fuzzy-select"
                         ("i" #'insert-function "select function to insert")
                         ("j" #'helm-switch-major-mode "helm switch major mode")
                         ("d" #'detect-language-set-mode "detect and switch mode")
                         ("a" #'helm-apropos "apropos")))

;; annot breaks spacemacs beg, start end
;; (require 'annot)

(defun copy-current-major-mode ()
  (interactive)
  (my/copy (current-major-mode-string)))

(convert-hydra-to-sslk "lr"
                       (defhydra h_nr (:exit t :pre (prehydra) :post (posthydra) :color blue :hint nil :columns 4) ;; "NORMAL: refactoring"
                         "NORMAL: emacs"
                         ("e" (df efs () (sh-notty (concat "sed -i 's/\\s\\+$//' " (q buffer-file-name)))) "erase free/end whitespace")
                         ("m" #'record-keyboard-macro-string "yank keys")
                         (">" (dff (e "~/.myrc.yaml")) "myrc")
                         ("M" #'copy-keybinding-as-table-row-or-macro-string "yank key binding as table row")
                         ("b" #'copy-keybinding-as-elisp "yank key binding as elisp")
                         ("n" #'yank-function-from-binding "yank function")
                         ("h" #'describe-mode "describe mode")
                         ("k" #'ead-binding "ead binding")
                         ("f" #'goto-function-from-binding "goto function from binding")
                         ("w" #'edit-var-elisp "edit var containing elisp")
                         ("o" #'get-map-for-key-binding "copy the map that provides binding")
                         ("l" #'locate-key-binding "locate key binding binding")
                         ;; ("a" #'annot-edit/add "annotate here")
                         ;; lrr is reserved for a prefix
                         ;; vim +/"lrre" "$EMACSD/config/my-spacemacs.el"
                         ;; ("r" #'annot-remove "remove annotation")
                         ;; ("-" #'annot-remove "remove annotation")
                         ;; ("]" #'annot-goto-next "next annotation")
                         ;; ("[" #'annot-goto-previous "previous annotation")
                         ("F" #'find-function "find function")
                         ("g" #'find-function "find function")
                         ("v" #'find-variable "find variable")
                         ;; ("t" #'helpful-at-point "helpful thing at point")
                         ("t" 'describe-thing-at-point "describe thing at point")
                         ("." #'helpful-at-point "helpful thing at point")
                         ("p" #'show-map "fz show map")
                         ("P" #'copy-current-major-mode "copy current major mode")
                         ("i" (df sh-interpreter (term "sh-interpreter")))))

(convert-hydra-to-sslk "lW"
                       (defhydra h_nW (:exit t :pre (prehydra) :post (posthydra) :color blue :hint nil :columns 4) ;; "NORMAL: action/appearance"
                         "NORMAL: action/appearance"
                         ("p" (df my-toggle-prettify (call-interactively 'prettify-symbols-mode)) "Pretty Mode")
                         ("l" (df my-toggle-linum (call-interactively 'linum-mode)) "Line Numbering")
                         ("i" (df toggle-my-mode (call-interactively 'my-mode)) "My minor mode")
                         ("v" #'rotate:even-horizontal "Arrange vertically")
                         ("h" #'rotate:even-vertical "Arrange horizontally")
                         ("t" #'rotate:tiled "Tile windows")
                         ("5" #'rotate:tiled "Tile windows")
                         ("r" #'rotate-layout "Rotate layout")
                         ("b" #'balance-windows "Balance windows")
                         ("f" #'all-over-the-screen "3 columns and follow")))

(convert-hydra-to-sslk "lw"
                       (defhydra h_nw (:exit t :pre (prehydra) :post (posthydra) :color blue :hint nil :columns 4)
                         "NORMAL: windows"
                         ("1" #'delete-other-windows "delete other windows")
                         ("0" #'delete-window "delete window")))


;; (defun correct-word ()
;;   (flyspell-buffer)
;;   (flyspell-correct-previous (point)))


(convert-hydra-to-sslk "lv"
                       (defhydra h_nv (:exit t :pre (prehydra) :post (posthydra) :color blue :hint nil :columns 4) ;; "ANY: version control"
                         "ANY: version control"
                         ("h" #'magit-sps-current-file "Add all and commit")
                         ("m" #'magit-sph "Add all and commit")
                         ("C" #'my/add-all-commit "Add all and commit")
                         ("M" #'sh/git-amend-all-below "amend below")))


(defun goto-file-and-search (fp pattern)
  (interactive)
  (find-file fp))


(defun gen-elisp-gy ()
  (interactive)
  (let ((sel (my/thing-at-point))
        (fp (buffer-file-path)))))

(convert-hydra-to-sslk "li"
                       (defhydra h_open-repl (:exit t :pre (prehydra) :post (posthydra) :color blue :hint nil :columns 4) ;; "ANY: repl"
                         "ANY: repl"
                         ("p" #'my/repl-py "python")
                         ("P" 'xpti-with-package "xpti")
                         ("l" #'my/repl-lisp "lisp (slime)")
                         ("s" #'my/repl-lisp "lisp (slime)")
                         ("R" #'run-racket "racket (geiser")
                         ("r" #'racket-repl "racket")
                         ("h" #'haskell-interactive-switch "haskell")
                         ;; ("i" #'ielm "ielm")
                         ("c" (df repl-clisp (term "clisp")) "clisp")
                         ("e" #'ielm "ielm")
                         ("2" (df repl-tcl (et "tclsh")) "tcl")
                         ("M" (df repl-mathematica (et "rlwrap" wolframscript)) "et-mma")
                         ("m" (df tm-repl-mathematica (etm rlwrap wolframscript)) "etm-mma")
                         ("K" (df repl-racket (term-nsfa "racket -iI racket || pak")) "et-racket")
                         ("k" #'ghci "ghci")
                         ("w" (df repl-wolframalpha (et "rlwrap replify waf")) "et-wa")
                         ("L" (df repl-lucene (et "rlwrap replify cl-lucene")) "et-lucene")))

(defun select-repl ()
  "Start the repl select hydra"
  (interactive)
  ;; (sleep 1)
  (tsk "M-l")
  (tsk "M-E"))


;; (sslk "l;c" (df sel-clisp (b tm sel localhost_current_repls:cl-clisp.0)))


(df show-advised ;; (pp-to-string ad-advised-functions)
    ;; (tvd (list2str ad-advised-functions))
    (tvd (list2string (let ((fns))
                    (ad-do-advised-functions (function)
                      (add-to-list 'fns function))
                    fns)))
    )

(convert-hydra-to-sslk "ld"
                       (defhydra h_advice (:exit t :pre (prehydra) :post (posthydra) :color blue :hint nil :columns 4) ;; "ANY: advice"
                         "ANY: advice"
                         ("e" #'show-advised "show advised functions")))

(defmacro my/mbind (key &rest h_params)
  (let ((nkey (concat "M-" key)))
    `(,key ,@h_params)
    `(,@h_params)))

;; Make a different
;; (define-key global-map (kbd "M-q M-r M-f") 'generalized-shell-command)

(df get-clql-verbose (get-clql t))
(df get-clql-terse (get-clql nil))

(convert-hydra-to-sslk "lk"
                       (defhydra h_nc (:exit t :pre (prehydra) :post (posthydra) :color blue :hint nil :columns 4) ;; "NORMAL: commands"
                         "NORMAL: commands"

                         ("1" #'get-clql-verbose "CLQL for selection")
                         ("2" #'get-clql-terse "CLQL for selection (short)")
                         ("a" #'helm-system-packages "apt / system packages")
                         ("A" #'org-agenda-list "org agenda list")
                         ;; ("b" #'org-brain-visualize "org-brain visualise")
                         ;; ("b" #'org-brain-visualize-goto "org-brain visualise goto")
                         ("b" 'org-brain-go-index "org-brain visualise index/billboard")
                         ("c" #'org-capture "org capture")
                         ("\\" #'my-columnate-window "fill with columns")
                         ;; ("d" (progn (save-excursion (h_advice/body) (norm/hydra-push '(h_nx/body)))) "advice")
                         ;; ("d" (progn (save-excursion (h_advice/body) (norm/hydra-push '(h_nx/body)))) "advice")
                         ;; ("e" (progn (save-excursion (h_open-repl/body) (norm/hydra-push '(h_nx/body)))) "open repl")
                         ;; ("e" (progn (save-excursion (h_open-repl/body) (norm/hydra-push '(h_nx/body)))) "open repl")
                         ("e" #'change-file-extension "change file extension")
                         ("f" #'helm-do-grep-ag "ag silversercher")
                         ("g" #'evil-insert-digraph "Insert digraph")
                         ("i" #'global-rainbow-identifiers-always-mode "Rainbow identifiers")
                         ("j" #'compile-run "compile-run")
                         ("J" #'compile-run-term "compile-run-term")
                         ("," #'compile-run-compile "compile-run compile")
                         ("<" #'compile-run-tm-ecompile "compile-run tm ecompile")
                         ("M" #'git-timemachine "git timemachine")
                         ("h" #'schema-run "schema-run")
                         (")" (df tmux-kill-other (b tm kill-other)) "Kill other tmux")
                         ("k" #'evil-insert-digraph "insert digraph")
                         ("l" #'copy-current-line-position-to-clipboard "copy line position")
                         ("L" #'helm-show-kill-ring "Show clipboard history")
                         ;; ("'" #'menu-bar-open "Menu bar")
                         ("~" #'menu-bar-open "Menu bar")
                         ;; ("M" #'helm-imenu-anywhere "imenu anywhere")
                         ;; ("m" #'helm-imenu "imenu")
                         ("m" (df switch-to-messages (switch-to-buffer "*Messages*")) "messages")
                         ;; ("m" #'view-echo-area-messages "messages")
                         ;; ("M" #'view-echo-area-messages "messages")
                         ("n" #'helm-buffers-list "Helm Buffers list")
                         ("o" (df h-checkprose (flycheck-compile 'proselint)) "check prose")
                         ("O" #'rotate:even-horizontal "Horizontal")
                         ("p" #'org-plot/gnuplot "GnuPlot")
                         ;; ("p" #'org-plot/gnuplot "GnuPlot") ; projectile, aboove
                         ("P" #'paradox-list-packages "Paradox List Packages")
                         ;; ("p" (progn (save-excursion (hydra-projectile/body) (norm/hydra-push '(h_nx/body)))) "projectile hydra")
                         ("q" #'get-clql-verbose "CLQL for selection")
                         (">" #'rotate-layout "Rotate layout")
                         ("r" #'re-builder "Regex builder")
                         ;; ("s" #'sx-search "StackExchange search")
                         ("s" #'sx-search-quickly "StackExchange search")
                         ("t" #'tvipe "tvipe")
                         ("U" #'term-ranger "term ranger")
                         ("u" #'ranger "ranger")
                         ("v" #'visual-line-mode "Visual Line Mode")
                         ;; ("w" #'correct-word "correct previous word")
                         ("w" #'my-auto-correct-word "auto correct word")
                         ("W" #'my-flyspell-add-word "add word to dictionary")
                         ;; ("W" #'wttrin "weather")
                         ("x" #'eval-defun "eval defun")
                         ("y" #'call-graph "Call graph")))

(convert-hydra-to-sslk "ls"
                       (defhydra h_ns (:exit t :pre (prehydra) :post (posthydra) :color blue :hint nil :columns 4) ;; "NORMAL: snippets"
                         "NORMAL: snippets"
                         ("n" #'yas-new-snippet "New snippet")
                         ("l" #'yas-expand "Expand")
                         ("i" #'my-yas-insert-snippet "Expand")
                         ("d" #'yas-describe-tables "Show snippets")
                         ("r" #'yas/reload-all "Reload snippets")))

;; yas-describe-tables
;; yas-visit-snippet-file

;; Need to learn to use dolist

;; (dolist (tuple
;;          '('("M-l"
;;             'copy-current-line-position-to-clipboard)))
;;   (define-key global-map (kbd (car tuple)) (car (last tuple))))

;; Hydra for modes that toggle on and off
;; I disabled it because I have my own prefix map. Hydras are incompatible with help
;; $EMACSD/config/my-prefix-maps.el
;; (global-set-key
;;  (kbd "C-x t")
;;  (defhydra toggle (:color blue)
;;    "toggle"
;;    ("a" abbrev-mode "abbrev")
;;    ("s" flyspell-mode "flyspell")
;;    ("d" toggle-debug-on-error "debug")
;;    ("c" fci-mode "fCi")
;;    ("v" visual-line-mode "fCi")
;;    ("f" auto-fill-mode "fill")
;;    ("t" toggle-truncate-lines "truncate")
;;    ("w" whitespace-mode "whitespace")
;;    ("q" nil "cancel")))


(global-set-key
 (kbd "C-x j")
 (defhydra gotoline (:pre (prehydra) :post (posthydra) :columns 4) ;; "goto"
   "goto"
   ("t" (lm (move-to-window-line-top-bottom 0)) "top")
   ("b" (lm (move-to-window-line-top-bottom -1)) "bottom")
   ("m" (lm (move-to-window-line-top-bottom)) "middle")
   ("e" (lm (end-of-buffer)) "end")
   ("c" recenter-top-bottom "recenter")
   ("n" next-line "down")
   ("p" (lm (forward-line -1)) "up")
   ("g" goto-line "goto-line")))
;; Hydra for navigation

;; Maybe add some more hydras
;; https://github.com/abo-abo/hydra/wiki/Org-clock-and-timers

(defhydra hydra-org (:color blue :timeout 12 :columns 4)
  "Org commands"
  ("i" (lambda () (interactive) (org-clock-in '(4))) "Clock in")
  ("o" org-clock-out "Clock out")
  ("q" org-clock-cancel "Cancel a clock")
  ("<f10>" org-clock-in-last "Clock in the last task")
  ("j" (lambda () (interactive) (org-clock-goto '(4))) "Go to a clock")
  ("m" make-this-message-into-an-org-todo-item "Flag and capture this message"))
(global-set-key (kbd "<f10>") 'hydra-org/body)

;; Hydra for some org-mode stuff
(global-set-key
 (kbd "C-c t")
 (defhydra hydra-global-org (:color blue :columns 4) ;; "Org"
   "Org"
   ("t" org-timer-start "Start Timer")
   ("s" org-timer-stop "Stop Timer")
   ("r" org-timer-set-timer "Set Timer") ; This one requires you be in an orgmode doc, as it sets the timer for the header
   ("p" org-timer "Print Timer")         ; output timer value to buffer
   ("w" (org-clock-in '(4)) "Clock-In") ; used with (org-clock-persistence-insinuate) (setq org-clock-persist t)
   ("o" org-clock-out "Clock-Out")   ; you might also want (setq org-log-note-clock-out t)
   ("j" org-clock-goto "Clock Goto") ; global visit the clocked task
   ("c" org-capture "Capture") ; Don't forget to define the captures you want http://orgmode.org/manual/Capture.html
   ("l" rg-capture-goto-last-stored "Last Capture")))


;;(defhydra hydra-launcher (:color blue :columns 2) ;; "Launch"
;;  "Launch"
;;  ("h" #'man "man")
;;  ("r" (df go-reddit (browse-url "http://www.reddit.com/r/emacs/")) "reddit")
;;  ("w" (df go-emacswiki (browse-url "http://www.emacswiki.org/")) "emacswiki")
;;  ("s" #'shell "shell")
;;  ;;("q" nil "cancel")
;;  )
;;
;;(global-set-key (kbd "C-c r") 'hydra-launcher/body)


(defhydra hydra-undo-tree (:color yellow :hint nil :columns 4)
  "
_p_: undo  _n_: redo _s_: save _l_: load   "
  ("p" undo-tree-undo)
  ("n" undo-tree-redo)
  ("s" undo-tree-save-history)
  ("l" undo-tree-load-history)
  ("u" undo-tree-visualize "visualize" :color blue)
  ("q" nil "quit" :color blue))

(global-set-key (kbd "M-,") 'hydra-undo-tree/undo-tree-undo) ;; or whatever

(define-key global-map (kbd "M-' n") nil)
(define-key my-mode-map (kbd "M-' n") nil)
(define-key my-mode-map (kbd "M-l n") nil)
(define-key global-map (kbd "M-l n") nil)

(convert-hydra-to-sslk "ln"
                       (defhydra hydra-projectile (:color blue ;; "Projectile"
                                                          :columns 4)
                         "Projectile"
                         ("a" #'projectile-ag "ag")
                         ("n" #'open-next-file "open-next-file")
                         ("p" #'open-prev-file "open-prev-file")
                         ("j" #'projectile-switch-project "switch")
                         ("b" #'projectile-switch-to-buffer "switch to buffer")
                         ("c" #'projectile-invalidate-cache "cache clear")
                         ("d" #'projectile-find-dir "dir")
                         ("s-f" #'projectile-find-file "file")
                         ("ff" #'projectile-find-file-dwim "file dwim")
                         ("fd" #'projectile-find-file-in-directory "file curr dir")
                         ("g" #'ggtags-update-tags "update gtags")
                         ("i" #'projectile-ibuffer "Ibuffer")
                         ("K" #'projectile-kill-buffers "Kill all buffers")
                         ("o" #'projectile-multi-occur "multi-occur")
                         ("r" #'projectile-recentf "recent file")
                         ("x" #'projectile-remove-known-project "remove known")
                         ("X" #'projectile-cleanup-known-projects "cleanup non-existing")
                         ("z" #'projectile-cache-current-file "cache current")))
                         ;; ("q" nil "cancel"))

(define-key global-map (kbd "M-' /") nil)
(define-key my-mode-map (kbd "M-' /") nil)
(define-key my-mode-map (kbd "M-l /") nil)
(define-key global-map (kbd "M-l /") nil)

(convert-hydra-to-sslk "l/"
                       (defhydra h_d (:exit t ;; "VISUAL: codesearch / autocomplete"
                                            :pre (prehydra)
                                            :post (posthydra)
                                            :color blue
                                            :hint nil
                                            :columns 4)
                         "VISUAL: codesearch"
                         ("o" #'all-occur "all-occur")
                         ("n" #'search_code "searchcode")
                         ;; ("e" #'egr "egr")
                         ("d" #'my-rat-dockerhub-search "dockerhub")
                         ("D" #'gl-find-deb "ubuntu deb")
                         ("k" #'my-k8s-hub-search "k8s hub")
                         ("j" #'eegr "Google")
                         ("g" #'my-egr-guru99 "guru99")
                         ("w" 'wiki-summary "wiki summary")
                         ("9" #'my-egr-guru99 "guru99")
                         ("x" #'google_example "google example")
                         ("a" #'my-github-awesome-search-and-clone "github awesome search and clone")
                         ("m" #'my-github-docker-compose-search-and-clone "github docker-compose search and clone")
                         ("E" #'find-repo-by-ext "find repo by extension")
                         ("h" #'my-github-search-and-clone "github search and clone")
                         ("p" #'gh-path-search "github path search")
                         ("H" #'hn "hacker news search")
                         ("r" #'tpb "the pirate bay")
                         ("y" #'search-play-yt "youtube search and play")
                         ("v" 'find-in-video "find in video")
                         ("V" 'find-in-youtube "find in youtube")
                         ("Y" 'ytt "youtube vid search and play")
                         ("i" #'ieee-search "ieee search")
                         ("I" #'Info-search-toc "info search")
                         ("7" #'protocol-search "eww protocol search")
                         ("r" #'my-github-search-and-clone-cookiecutter "github search and clone cookiecutter")
                         ("q" #'eegr-maybeselected "google")
                         ("t" #'my-github-search-and-clone-template "github search and clone template")
                         ;; ("T" #'my-github-search-and-clone-template-lang "github search and clone template lang")
                         ("l" #'google_example_literal "google example literal")
                         ;; ("s" #'tvipe-completions "Show completions in vim.")
                         ;; ("d" #'dack-selection-top "dack top")
                         ;; ("e" #'eack-selection-top "eack top")
                         ("f" #'fz-cq-functions "cq functions")
                         ("R" #'cscope-gen "regen cscope, ctags, etc.")
                         ("s" #'fz-cq-symbols "cq symbols")
                         ("c" #'fz-cq-classes "cq classes")
                         ("/" #'eack-selection-top "eack top")
                         ("?" #'eack-selection "eack selection")
                         ("`" #'eack-selection-top "eack top")))

(define-key global-map (kbd "M-' x") nil)
(define-key my-mode-map (kbd "M-' x") nil)
(define-key my-mode-map (kbd "M-l x") nil)
(define-key global-map (kbd "M-l x") nil)

(convert-hydra-to-sslk "lx"
                       (defhydra h_n_normal_x (:exit t :pre (prehydra) :post (posthydra) :color blue :hint nil :columns 4) ;; "NORMAL: x automation"
                         "NORMAL: x automation"
                         ("e" #'x/eack-thing "x eack / thing under cursor")
                         ("s" #'get-arxiv-summary "get arxiv summary for thing under cursor")
                         ("/" #'x/eack-thing-top "x eack / thing under cursor (vc top)")
                         ("`" #'x/eack-thing-top "x eack / thing under cursor (vc top)")
                         ("M-`" #'x/eack-thing-top "x eack / thing under cursor (vc top)")))

(define-key global-map (kbd "M-' @") nil)
(define-key my-mode-map (kbd "M-' @") nil)
(define-key my-mode-map (kbd "M-l @") nil)
(define-key global-map (kbd "M-l @") nil)

(convert-hydra-to-sslk "l@"
                       (defhydra h_n_lingo (:exit t :pre (prehydra) :post (posthydra) :color blue :hint nil :columns 4) ;; "NORMAL: lingo"
                         "NORMAL: properties"
                         ("." (df edit-my-hydra (e "$MYGIT/config/emacs/config/my-hydra.el")) "edit hydra")
                         ("g" #'clpl-rewrite "Run rewrites on pipeline")
                         ("b" #'clpl-get-rewrite-branches "Get rewrite branches")
                         ("j" #'lingo-simplify-review-dump "simplify review json dump")
                         ("s" #'open-in-sublime "open in sublime")
                         ("i" #'indent-clql-for-yaml "indent clql for yaml")
                         ("a" #'clql-annotate "annotate clql")
                         ("e" #'clql-remove-probable-extraneous-properties "clql rm probable extra properties")
                         ("i" #'paste-clql-in-yaml "paste clql into yaml")
                         ("s" #'lingo-strip-clql-from-yaml "strip clql")
                         ("c" #'lingo-extract-clql-from-yaml "extract clql")
                         ("p" #'lingo-insert-project-name "insert project name")))

(define-key global-map (kbd "M-' p") nil)
(define-key my-mode-map (kbd "M-' p") nil)
(define-key my-mode-map (kbd "M-l p") nil)
(define-key global-map (kbd "M-l p") nil)

(convert-hydra-to-sslk "lp"
                       (defhydra h_n_normal_properties (:exit t :pre (prehydra) :post (posthydra) :color blue :hint nil :columns 4) ;; "NORMAL: properties"
                         "NORMAL: properties"
                         ("b" #'etv-buffer-properties-json "tvipe buffer properties")
                         ("o" #'parent-modes "parent modes")
                         ("v" #'etv-buffer-variables-json "tvipe buffer variables")
                         ("g" #'etv-global-variables-json "tvipe global variables")
                         ("e" #'etv-emacs-properties-json "tvipe emacs properties")
                         ("p" #'etv-properties-json "tvipe properties")
                         ("i" #'package-install "Install Package")
                         ("r" #'my/reload-config-file "reload config file")
                         ("y" #'copy-button-action "copy button action")
                         ("l" #'my/tvipe-package-list "list packages")
                         ("P" #'paradox-list-packages "Paradox List Packages")
                         ("m" #'list-packages "Package Manager")
                         ;; ("f" #'customize-face "customize face")
                         ("f" #'what-face "what face")
                         ("t" #'etv-textprops "text properties")
                         ("u" #'etv-urls-in-region "selected urls")))

(define-key global-map (kbd "M-' z") nil)
(define-key my-mode-map (kbd "M-' z") nil)
(define-key my-mode-map (kbd "M-l z") nil)
(define-key global-map (kbd "M-l z") nil)

(convert-hydra-to-sslk "lz"
                       (defhydra h_n_normal_properties (:exit t :pre (prehydra) :post (posthydra) :color blue :hint nil :columns 4) ;; "NORMAL: fuzzy"
                         ;; Can I start clisp inside of emacs?
                         ("s" (df fz-scriptnames (e (fz (mnm (scriptnames)) nil nil "scriptnames-goto:" t))))
                         ("c" (df fz-tm-config (e (fz (mnm (b tm-list-config)) nil nil "tm-config-goto:" t))))
                         ("b" 'fz-org-tidbits)
                         ("k" 'fz-org-tidbits-tasks)
                         ("d" (df fz-tm-shortcuts (e (fz (mnm (b cd $NOTES\; tm-list-shortcuts)) nil nil "tm-shortcuts-goto:" t))))
                         ("n" (df fz-copy-ns-func (my/copy (fz-namespaces-func))))
                         ("p" (df fz-go-snippet (e (fz (mnm (b find $HOME/notes/ws/lists/snippets -type f -name "*.txt"))))))
                         ("f" #'fz-insert-function)
                         ("g" #'go-to-glossary)
                         ("t" #'go-to-todo-list)
                         ("r" #'go-to-remember-file)
                         ;; ("r" (df fz-sh-repl (ansi-term "fz-repl")))
                         ("i" (df fz-sh-repl (term "fz-repl"))) ;; TODO make this start an emacs fz-repl instead; interpreter
                         ))


(defun my-flycheck-list-errors ()
  (interactive)
  (setq flycheck-check-syntax-automatically '(save idle-change new-line mode-enabled))
  (call-interactively 'flycheck-buffer)
  (call-interactively 'flycheck-list-errors))

(require 'flycheck)

(df fi-text-to-paras-nosegregate (cfilter "tpp"))


;; (switch-to-buffer "*Messages*")


;; TODO
;; set these key-bindings
;; (define-key my-mode-map (kbd "M-' p t") 'run-tests)
;; (define-key my-mode-map (kbd "M-' p m") 'my/bpr/make)
;; (sslk "l." (df edit-my-spacemacs (e "$MYGIT/config/emacs/config/my-spacemacs.el")))
;; (sslk "l," (df edit-my-hydra (e "$MYGIT/config/emacs/config/my-hydra.el")))



;; Hydra floats -- I don't need it
;; https://github.com/Ladicle/hydra-posframe?hmsr=joyk.com&utm_source=joyk.com&utm_medium=referral

;; (use-package hydra
;;   :config
;;   (use-package hydra-posframe
;;     :load-path "~/Developments/src/github.com/Ladicle/hydra-posframe"
;;     :custom
;;     (hydra-posframe-parameters
;;       '((left-fringe . 5)
;;         (right-fringe . 5)))
;;     :custom-face
;;     (hydra-posframe-border-face ((t (:background "#6272a4"))))
;;     :hook (after-init . hydra-posframe-enable)))


(defhydra hydra-apropos (:color blue)
  "Apropos"
  ("a" apropos "apropos")
  ("c" apropos-command "cmd")
  ("d" apropos-documentation "doc")
  ("e" apropos-value "val")
  ("l" apropos-library "lib")
  ("o" apropos-user-option "option")
  ("u" apropos-user-option "option")
  ("v" apropos-variable "var")
  ("i" info-apropos "info")
  ("t" tags-apropos "tags")
  ("z" hydra-customize-apropos/body "customize"))

(defhydra hydra-customize-apropos (:color blue)
  "Apropos (customize)"
  ("a" customize-apropos "apropos")
  ("f" customize-apropos-faces "faces")
  ("g" customize-apropos-groups "groups")
  ("o" customize-apropos-options "options"))





(defmacro hb (name bindings_list)
  )

(defhydra h_ne (:exit t :pre (prehydra) :post (posthydra) :color blue :hint nil :columns 4) ;; "NORMAL: emacs"
  "NORMAL: emacs"
  ("e" #'my-revert "revert")
  ("x" #'kill-emacs "kill emacs")
  ("c" #'revert-and-quit-emacsclient-without-killing-server "kill emacsclient")
  ("d" (df show-daemonp () (message (daemonp))) "(daemonp)")
  ("r" #'restart-emacs "restart emacs")
  ("q" #'my-quit "quit emacs frame"))

(use-package hydra
  :defer 2
  :bind ("C-c f" . hydra-flycheck/body))



(defhydra hydra-flycheck (:color blue)
  "
  ^
  ^Flycheck^          ^Errors^            ^Checker^
  ^────────^──────────^──────^────────────^───────^─────
  _q_ quit            _<_ previous        _?_ describe
  _M_ manual          _>_ next            _d_ disable
  _v_ verify setup    _f_ check           _m_ mode
  ^^                  _l_ list            _s_ select
  ^^                  ^^                  ^^
  "
  ("q" nil)
  ("<" flycheck-previous-error :color pink)
  (">" flycheck-next-error :color pink)
  ("?" flycheck-describe-checker)
  ("M" flycheck-manual)
  ("d" flycheck-disable-checker)
  ("f" flycheck-buffer)
  ("l" flycheck-list-errors)
  ("m" flycheck-mode)
  ("s" flycheck-select-checker)
  ("v" flycheck-verify-setup))


;; Language agnostic handle-based hydra
(global-set-key
 (kbd "H-j")
 (defhydra handlenav (:pre (prehydra) :post (posthydra) :columns 4) ;; "handle nav"
   "goto"
   ("j" handle-navdown "down")
   ("k" handle-navup "up")
   ("h" handle-navleft "left")
   ("l" handle-navright "right")
   ("q" nil "quit" :color blue)))

(defmacro dr (&rest body)
  "Define and run"
  `(let ((h (progn ,@body)))
     (call-interactively h)))

(defmacro hydrate (&rest body)
  "Define and run hydra"
  `(dr (defhydra ,@body)))

(defalias 'h 'hydrate)

;; (h h_yn (:exit t)
;;    "Yes or No"
;;    ("y" (ns "yes"))
;;    ("n" (ns "no")))

(defmacro hyn (question ifyes &optional ifno default-yes-predicate)
  (let ((hydrasym (str2sym (concat "h_yn_" (slugify question))))
        (hydrabodysym (str2sym (concat "h_yn_" (slugify question) "/body"))))
    (if (not ifno)
        (setq ifno '(progn nil)))
    (if question
        (setq question (concat question " [yn]"))
      (setq question "[yn]"))
    `(progn
       (if ,default-yes-predicate
           ,ifyes
           (progn
             (defhydra ,hydrasym (:exit t)
               ,question
               ("y" ,ifyes)
               ("n" ,ifno))
             (,hydrabodysym))))))

;; (hyn "beep?"
;;      (ns "beep")
;;      (ns "nobeep"))

;; TODO To get an interactive function such as a hydra to return a value, I may need to use threads
;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Threads.html

(provide 'my-hydra)