(require 'scheme)
(require 'my-aliases)

(load "/var/smulliga/source/git/config/emacs/packages27/org-20200316/org.el")
(require 'evil-org)


;; This only checks the first line
(add-to-list 'magic-mode-alist '("^#lang racket" . racket-mode))
(add-to-list 'magic-mode-alist '("^#lang scribble" . scribble-mode))
(add-to-list 'magic-mode-alist '("^#lang " . racket-mode))
(add-to-list 'magic-mode-alist '("^#.*env stack$" . haskell-mode))
(add-to-list 'magic-mode-alist '("^#.*sbcl" . lisp-mode))
(add-to-list 'magic-mode-alist '("^#.*xsh" . sh-mode))
(add-to-list 'magic-mode-alist '("#!/sbin/runscript$" . sh-mode))

;; pyramid scheme -- one day I will have  a racket mode
(add-to-list 'auto-mode-alist '("\\.pmd\\'" . racket-mode))
(add-to-list 'auto-mode-alist '("\\(\\.network\\|\\.netdev\\|\\.path\\|\\.socket\\|\\.slice\\|\\.automount\\|\\.mount\\|\\.target\\|\\.timer\\|\\.service\\)\\'" . systemd-mode))

;; This may be causing extreme lag from parsing, similar to semantic
;; It was certainly slowing down python

;; Flycheck -- not just with spacemacs, but enabled for all emacs servers
(add-hook 'after-init-hook #'global-flycheck-mode)
(remove-hook 'after-init-hook #'global-flycheck-mode)

(add-to-list 'auto-mode-alist '("\\.kt\\'" . kotlin-mode))
;; associates MajorModes with a pattern to match a buffer filename when it is first opened
(add-to-list 'auto-mode-alist '("/\\.[^/]*\\'" . fundamental-mode))
;; When building REGEXPs for auto-mode-alist, keep in mind that the string matched is the full pathname. In the examples below, replace the modes with your preference.
;; https://www.emacswiki.org/emacs/AutoModeAlist
;; (add-to-list 'auto-mode-alist '("\\.ssh/config" . ssh-config-mode))
;; 17:30 < twb> You should have \\' in the regex and almost certainly a leading /
;; 17:31 < twb> (rx (or (and bos "/etc/ssh/ssh_config" eos) (and "/.ssh/config" eos)))
;;(add-to-list 'auto-mode-alist '("/\\.ssh/config\\'" . ssh-config-mode))

(add-to-list 'auto-mode-alist '("\\.ssh/config" . ssh-config-mode))

(add-to-list 'auto-mode-alist '("/etc/ansible/hosts" . conf-mode))

;; Still unsure why this doesn't work
;; (add-to-list 'auto-mode-alist '((rx (or (and bos "/etc/ssh/ssh_config" eos) (and "/.ssh/config" eos))) . ssh-config-mode))

;; This is how to test auto-mode-alist entries
;; (string-match "\\.toml\\'" (buffer-file-name))
(add-to-list 'auto-mode-alist '("/[^\\./]*\\'" . fundamental-mode))
(add-to-list 'auto-mode-alist '("\\.json\\'" . json-mode))
(add-to-list 'auto-mode-alist '("\\.jsonl\\'" . jsonl-mode))
;; (remove-from-list 'auto-mode-alist '("\\.jsonl\\'" . json-mode))
(add-to-list 'auto-mode-alist '("\\.python-gitlab.cfg\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\(\\.tmpl\\|\\.j2\\)\\'" . jinja2-mode))
(add-to-list 'auto-mode-alist '("\\.tcshrc\\'" . csh-mode))
(add-to-list 'auto-mode-alist '("\\.asciidoc\\'" . adoc-mode))
(add-to-list 'auto-mode-alist '("\\.mac\\'" . asm-mode))
(add-to-list 'auto-mode-alist '("\\.csv\\'" . csv-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js-mode))
;; (add-to-list 'auto-mode-alist '("\\.java\\'" . jdee-mode))
(ignore-errors (remove-from-list 'auto-mode-alist '("\\.java\\'" . jdee-mode)))
(add-to-list 'auto-mode-alist '("\\.java\\'" . java-mode))
(add-to-list 'auto-mode-alist '("\\.sln\\'" . sln-mode))
(add-to-list 'auto-mode-alist '("\\.xsh\\'" . sh-mode))

(ignore-errors (remove-from-list 'auto-mode-alist '("\\.pp$" pollen-mode t)))
(add-to-list 'auto-mode-alist '("\\.pp\\'" . puppet-mode))

;; auto-mode-alist matches the full path
;; ansible hosts files, but not /etc/hosts
;; $MYGIT/ansible/ansible-examples/mongodb/hosts
(add-to-list 'auto-mode-alist '("/home.*/hosts" . conf-mode))
;; This means that it will recognise .hashibot.hcl
(add-to-list 'auto-mode-alist '(".*\\.hcl\\'" . hcl-mode))
(add-to-list 'auto-mode-alist '(".*\\.gradle\\'" . groovy-mode))
;; (remove-from-list 'auto-mode-alist '(".*\\.gradle\\'" . gradle-mode))
(add-to-list 'auto-mode-alist '("\\.ghci.*\\'" . ghci-script-mode))
(add-to-list 'auto-mode-alist '("\\(\\.git/config\\|\\.gitconfig\\|gitconfig\\)\\'" . gitconfig-mode))
(add-to-list 'auto-mode-alist '("\\(\\.gitignore\\|\\.npmignore\\|\\.hgignore\\|\\.dockerignore\\)\\'" . gitignore-mode))
(add-to-list 'auto-mode-alist '("\\.gitmodules\\'" . gitconfig-mode))
(add-to-list 'auto-mode-alist '("\\.gitattributes\\'" . gitattributes-mode))
(add-to-list 'auto-mode-alist '(".*xmobarrc" . haskell-mode))
(add-to-list 'auto-mode-alist '("\\.jq\\'" . jq-mode))

(add-to-list 'auto-mode-alist '("\\.cl\\'" . lisp-mode))

(add-to-list 'auto-mode-alist '("\\.asd\\'" . lisp-mode))
(add-to-list 'auto-mode-alist '("\\(\\.babelrc\\)\\'" . json-mode)) ;not sure if should be javascript-mode
(add-to-list 'auto-mode-alist '("\\(\\.eslintrc\\)\\'" . javascript-mode))        ;I think this one is javascript. jq doesn't like it
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
(add-to-list 'auto-mode-alist '("\\.mermaid\\'" . mermaid-mode))
(add-to-list 'auto-mode-alist '("rr_gdbinit\\'" . gdb-script-mode))
(add-to-list 'auto-mode-alist '("\\.adoc\\'" . adoc-mode))
(add-to-list 'auto-mode-alist '("\\(\\.puml\\|\\.iuml\\|\\.uml\\)\\'" . plantuml-mode))
;; What causes this to fail? $HOME/.aminal.toml
;; (string-match "\\.toml\\'" (buffer-file-name))
(add-to-list 'auto-mode-alist '("\\.toml\\'" . toml-mode))
(add-to-list 'auto-mode-alist '("\\(\\.sh\\|.zsh\\)\\'" . sh-mode))
(add-to-list 'auto-mode-alist '("\\(conf\\|\\.conf\\)\\'" . conf-mode))
;; I think cdf files need to be converted
;; (add-to-list 'auto-mode-alist '("\\(\\.cdf\\)\\'" . wolfram-mode))
;; .wls is the proper wolframscript extension. .nb is also a text format
(add-to-list 'auto-mode-alist '("\\(\\.wls\\|\\.nb\\|\\.wl\\)\\'" . wolfram-mode))
(add-to-list 'auto-mode-alist '("\\(\\.pxd\\|\\.pyx\\)\\'" . cython-mode))
(add-to-list 'auto-mode-alist '("\\(\\.scrbl\\)\\'" . scribble-mode))
(add-to-list 'auto-mode-alist '("\\(\\.ghci\\)\\'" . haskell-mode))
(add-to-list 'auto-mode-alist '("\\(\\.sparql\\)\\'" . sparql-mode))
(add-to-list 'auto-mode-alist '("\\(Jenkinsfile\\)\\'" . jenkinsfile-mode))
(add-to-list 'auto-mode-alist '("\\(Procfile\\|procfile\\)\\'" . procfile-mode))
;; The pest-mode plugin provides this
;; (add-to-list 'auto-mode-alist '("\\(\\.pest\\)\\'" . pest-mode))
(add-to-list 'auto-mode-alist '("\\(Gemfile\\)\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\(Pipfile\\)\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\(crontab\\)\\'" . crontab-mode))
(add-to-list 'auto-mode-alist '("\\(cron.d/\\)" . crontab-mode))
(add-to-list 'auto-mode-alist '("\\(GNUmakefile\\)\\'" . makefile-mode))
(add-to-list 'auto-mode-alist '("\\(Cask\\)\\'" . cask-mode))
(add-to-list 'auto-mode-alist '("\\(Caddyfile\\)\\'" . caddyfile-mode))
(add-to-list 'auto-mode-alist '("\\(Dockerfile\\)\\'" . dockerfile-mode))
(add-to-list 'auto-mode-alist '("\\(Vagrantfile\\)\\'" . ruby-mode))
;; $MYGIT/ApexAI/performance_test/tools/Dockerimage.crossbuild
;; This broke the following
;; /home/shane/org-brain/Docker.org
;; (remove-from-list 'auto-mode-alist '("\\(Docker.*\\)\\'" . dockerfile-mode))
;; (add-to-list 'auto-mode-alist '("\\(Docker.*\\)\\'" . dockerfile-mode))
(add-to-list 'auto-mode-alist '("\\(.docker\\)\\'" . dockerfile-mode))
(add-to-list 'auto-mode-alist '("\\(\\.make\\)\\'" . makefile-mode))
(add-to-list 'auto-mode-alist '("\\(\\.ttl\\)\\'" . ttl-mode))
(add-to-list 'auto-mode-alist '("\\(\\.project\\)\\'" . haskell-cabal-mode))
(add-to-list 'auto-mode-alist '("\\.zsh-theme\\'" . sh-mode))
(add-to-list 'auto-mode-alist '("\\.scm\\'" . scheme-mode))
(add-to-list 'auto-mode-alist '("\\.screenrc\\'" . conf-mode))
;; I'm not sure why this required the \\' gone
(add-to-list 'auto-mode-alist '("\\.editorconfig" . editorconfig-conf-mode))
(add-to-list 'auto-mode-alist '("\\.latexrc\\'" . latex-mode))
(add-to-list 'auto-mode-alist '("\\pylintrc\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\yarn\\.lock\\'" . yarn-mode))

(add-to-list 'auto-mode-alist '("\\.rcp\\'" . emacs-lisp-mode))
(add-to-list 'auto-mode-alist '("\\.ini\\'" . conf-mode))

(add-to-list 'auto-mode-alist '("\\.bzl\\'" . bazel-mode))

;; .pl is always perl on systems with perl, but prolog files often use .pl
;; Therefore, when perl loads, check if the language is actual perl or prolog
;; \\.pl\\|
(add-to-list 'auto-mode-alist '("\\(\\.pl\\|\\.pm\\)\\'" . perl-mode))
(add-to-list 'auto-mode-alist '("\\(\\.pro\\|\\.problog\\)\\'" . prolog-mode))
(add-to-list 'auto-mode-alist '("\\(\\.yas\\|\\.snippet\\)\\'" . snippet-mode))
(add-to-list 'auto-mode-alist '("\\(shellrc\\|\\.shell_aliases\\|profile\\|\\.profile\\|\\.bashrc\\|\\.bash_logout\\|\\.bash_profile\\|\\.zshrc\\|\\.shell_environment\\|\\.shell_functions\\|zshrc\\)\\'" . sh-mode))
(add-to-list 'auto-mode-alist '("\\(\\.aderc\\)\\'" . sh-mode))
(add-to-list 'auto-mode-alist '("\\(\\.Xresources\\|\\.Xdefaults\\)\\'" . conf-xdefaults-mode))

;; (add-to-list 'auto-mode-alist '("\\.clql\\'" . yaml-mode))

(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.prompt\\'" . prompt-description-mode))
;; (remove-from-list 'auto-mode-alist '("\\.prompt\\'" . yaml-mode))

(add-to-list 'auto-mode-alist '("\\.gitlab-ci\\.yml\\'" . gitlab-ci-mode))
;; This is an incorrect name but still want it to load correctly
(add-to-list 'auto-mode-alist '("\\gitlab-ci\\.yml\\'" . gitlab-ci-mode))

;; .hlint.yaml
(add-to-list 'auto-mode-alist '(".*\\.yaml\\'" . yaml-mode))


(add-to-list 'auto-mode-alist '(".*\\.clql\\'" . clql-mode))

(add-to-list 'auto-mode-alist '("\\.restc\\'" . restclient-mode))
(add-to-list 'auto-mode-alist '("\\.vbs\\'" . basic-mode))
(add-to-list 'auto-mode-alist '("\\.restclient\\'" . restclient-mode))
(add-to-list 'auto-mode-alist '("\\.annotations\\'" . emacs-lisp-mode))

;; yaml is provided by plugin

;; I should create my/lisp-mode
;; Then I should hook everything into that
;; This would be more efficient

;; Unlike major modes, all matching minor modes are enabled, not only the first match.
;; Instead of auto-minor-mode I can do the following:
;; (when (require 'lispy nil 'noerror)
;;     (add-hook 'hy-mode-hook '(lambda () (lispy-mode 1)))
;;     )
(require 'auto-minor-mode)
;; evil-org-mode doesn't actually work very well with my M-hjkl evil bindings
(add-to-list 'auto-minor-mode-alist '("\\.org\\'" . evil-org-mode))

;; Need an emacs macro for writing strings without quotes

;; (defmacro Q (&rest body)
;;   (tvipe body)
;;   `(mapconcat 'str ',body " "))

;; (add-to-list 'auto-mode-alist '("\\(\\.vim\\|.vimrc\\|vimrc\\)\\'" . vimrc-mode))
;; (add-to-list 'auto-mode-alist `(,(bs "(.vim|.vimrc|vimrc|pentadactylrc)'" ".()'|") . vimrc-mode))
(add-to-list 'auto-mode-alist `(,(bs "(.vim|.vimrc|vimrc|pentadactylrc)'" ".()'|") . vimrc-mode))
(add-to-list 'auto-mode-alist '("\\(\\.py\\|.pythonrc\\)\\'" . python-mode))
(add-to-list 'auto-mode-alist '("\\(\\.psh\\)\\'" . powershell-mode))
;;(add-to-list 'auto-mode-alist '("\\.py\\'" . elpy-mode))
(add-to-list 'auto-mode-alist '("\\.exs\\'" . elixir-mode))
(add-to-list 'auto-mode-alist '("\\.exs\\'" . alchemist-mode))

;; GitHub Semmle / CodeQL
(add-to-list 'auto-mode-alist '("\\.ql\\'" . ql-mode-base))
(add-to-list 'auto-mode-alist '("\\.dbscheme\\'" . dbscheme-mode))

(add-to-list 'auto-mode-alist '("\\.gnus\\'" . emacs-lisp-mode))
;; Hash table stored in file
(add-to-list 'auto-mode-alist '("\\.elht\\'" . emacs-lisp-mode))

(add-to-list 'auto-mode-alist '("\\.classpath\\'" . xml-mode))

(add-to-list 'auto-mode-alist '("\\.C\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("\\(\\.rkt\\|\\.racketrc\\)\\'" . racket-mode))
(add-to-list 'auto-mode-alist '("\\.scm\\'" . scheme-mode))

;; I want lisp mode and emacs-lisp mode at the same time
;; I think emacs-lisp-mode is derived from lisp-mode. It's more complicated that I understand.
(add-to-list 'auto-mode-alist '("\\(\\.el\\|emacs\\)\\'" . emacs-lisp-mode))
(add-to-list 'auto-mode-alist '("\\.hy\\'" . hy-mode))
;; (add-to-list 'auto-mode-alist '("\\.phpt\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.closhrc\\'" . lisp-mode))
(add-to-list 'auto-mode-alist '("\\.fishrc\\'" . fish-mode))
(add-to-list 'auto-mode-alist '("\\.gntrc\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\(\\.clisprc\\|\\.clojurerc\\)\\'" . lisp-mode))
;; (add-to-list 'auto-mode-alist '("\\(\\.clj\\|\\.lsp\\)\\'" . lisp-mode))
(add-to-list 'auto-mode-alist '("\\(CONTRIBUTING\\|\\.md\\|\\.markdown\\|\\.Rmd\\)\\'" . markdown-mode))

(add-to-list 'auto-mode-alist '("\\(\\.clj\\|\\.clojurerc\\|\\.repl\\)\\'" . clojure-mode))
;; (if (cl-search "SPACEMACS" my-daemon-name)
;;     (add-to-list 'auto-mode-alist '("\\(\\.clj\\|\\.clojurerc\\|\\.repl\\)\\'" . clojure-mode)))

(add-to-list 'auto-minor-mode-alist '("\\.clj\\'" . helm-cider-mode))

(add-to-list 'auto-mode-alist '("\\.lsp\\'" . lisp-mode))
(add-to-list 'auto-mode-alist '("\\.cljs\\'" . clojurescript-mode))
(add-to-list 'auto-mode-alist '("\\.cs\\'" . csharp-mode))
(add-to-list 'auto-mode-alist '("\\.rpl\\'" . rpl-mode))

(remove-from-list 'auto-mode-alist '("\\.clj$" . clj-mode))
;; This is to ensure that it doesnt reload somehow
(add-hook 'clj-mode (lm (remove-from-list 'auto-mode-alist '("\\.clj$" . clj-mode))))

(add-to-list 'auto-mode-alist '("\\(\\.clj\\)\\'" . clojure-mode))
;; (add-to-list 'auto-mode-alist '("\\(\\.clj\\|\\.clje\\)\\'" . clojure-mode))
;; (remove-from-list 'auto-mode-alist '("\\(\\.clj\\|\\.clje\\)\\'" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\(\\.clje\\)\\'" . clojerl-mode))

(add-to-list 'auto-mode-alist '("\\.sol\\'" . solidity-mode))
(add-to-list 'auto-mode-alist '("\\.julia\\'" . julia-mode))

;; Should complete this list
;; (add-to-list 'auto-mode-alist '("\\.\\(360\\|6502\\|6800\\|8051\\|8080\\|8086\\|68000\\|arm\\|as\\)\\'" . asm-mode))
(add-to-list 'auto-mode-alist `(,(bs ".(360|6502|6800|8051|8080|8086|68000|arm|as)'" ".()'|") . asm-mode))

;; I don't think there is a not in emacs regex
;; I could also try emacs-pcre, but I don't think I can do that here
;; (add-to-list 'auto-mode-alist `(,(bs ".(el|rkt|cl)'" ".()'|") . selected-mode))

(require 'selected)

;; Annoyingly, this seems like the only way to enable selected. Using a whitelist
;; Also add-to-list is for major modes. Use hooks for selected
;; (add-to-list 'auto-mode-alist `(,(bs ".(org|txt)'" ".()'|") . selected-minor-mode))

(defun disable-visual-line-mode ()
  (visual-line-mode -1))

(add-hook 'dired-mode-hook 'disable-visual-line-mode)

(defun my/emacs-lisp-mode-hook-body ()
  "What happens when emacs lisp mode loads"
  (my/lisp-mode 1)
  (remove-hook 'activate-mark-hook #'selected--on) ;Why wont it just die
  (selected-off)
  ;; (nameless-mode 1) ;; this would scramble emacs formatting
  ;; sometimes, for example scribble-mode.el
  ;; $EMACSD/packages27/scribble-mode-20160124.2328/scribble-mode.el
  ;; (semantic-mode 1)

  ;; HOLY SHIT DISABLE SEMANTIC, it KILLS emacs lisp
  )


;; Disable this so C-c C-s works
(add-hook 'magit-popup-mode-hook (lambda () (my-mode -1)))
;; Also, fix it here, just in case
;; (defun my-save-buffer ()
;;        (interactive)
;;        (if (minor-mode-enabled 'magit-popup-mode-hook)
;;            (let ((my-mode nil))
;;              (ekm "C-c C-s")            ;For magit-popu
;;              )
;;            ;; (shut-up (annotate-save-annotations))
;;          (save-buffer)))


(add-hook 'magit-status-mode-hook #'my/magit-status-hook-body)
(add-hook 'emacs-lisp-mode-hook #'my/emacs-lisp-mode-hook-body)
(add-hook 'ielm-mode-hook #'my/emacs-lisp-mode-hook-body)
(add-hook 'hy-mode-hook '(lambda () (my/lisp-mode 1)))
(add-hook 'per-mode-hook '(lambda () (my/lisp-mode 1)))
(add-hook 'clojure-mode-hook '(lambda () (my/lisp-mode 1)))
(add-hook 'lisp-mode-hook '(lambda () (my/lisp-mode 1)))
(add-hook 'lfe-mode-hook '(lambda () (my/lisp-mode 1)))
(add-hook 'cider-repl-mode-hook '(lambda () (my/lisp-mode 1)))
(add-hook 'inferior-hy-mode-hook '(lambda () (my/lisp-mode 1)))
(add-hook 'scheme-mode-hook '(lambda () (my/lisp-mode 1)))

(add-hook 'org-mode-hook '(lambda () (selected-minor-mode 1)))

;; (add-hook 'fundamental-mode-hook '(lambda () (selected-minor-mode 1)))

;; this should work but it doesnt
;; (add-hook 'occur-mode-hook '(lambda () (toggle-truncate-lines 1)))
;; This works!
(add-hook 'occur-hook '(lambda () (toggle-truncate-lines 1)))

;; This does it. Not sure why, but this makes org-mode actually truncate the lines
;; Or not... So frustrating.
;; (add-hook 'org-hook '(lambda () (setq truncate-lines -1)))

;; (add-hook 'org-mode-hook '(lambda () (toggle-truncate-lines 1)))
;; This did it!
;; I want truncate-lines to be ENABLED in org mode.
;; Tables look horrendous
;; Not even making it append works


;; You need to remove and then add to enforce the 'after', otherwise, it will not go to the end of the list if it already exists
(defun enable-chop-lines ()
  (visual-line-mode -1)
  (toggle-truncate-lines 1))

(remove-hook 'org-mode-hook #'enable-chop-lines)

;; Not even this works
;; (with-eval-after-load "org" (add-hook 'org-mode-hook #'enable-chop-lines t))


;; works
(add-hook 'yas-minor-mode-hook '(lambda () (toggle-truncate-lines 1))) ;This is for snippets


;; This appears not to work
;; (add-hook 'geiser-repl-mode-hook '(lambda () (my/lisp-mode 1)))


(defmacro enable-major-mode (mode_symbol)
  (quote mode_symbol))

;; This is how to enable a minor mode. How to enable a major mode?
;; (my/lisp-mode 1)

(defun fix-completion ()
  "Sometimes the completion function is not removed after leaving a mode. This is the fix."
  (progn
    (setq completion-at-point-functions
          '())))

(add-hook 'org-mode-hook '(lambda () (fix-completion)))

;; this works but background highlighting is removed
;;(add-hook 'sx-question-mode-hook '(lambda () (my-keywords-mode 1)))
;;(add-hook 'org-mode-hook '(lambda () (fix-completion) (my-keywords-mode 1)))
;;(add-hook 'messages-buffer-mode-hook '(lambda () (my-keywords-mode 1)))
;;(add-hook 'text-mode-hook '(lambda () (my-keywords-mode 1)))


;; There is a bug with org-trello which is breaking my org-mode indenting
;; (add-hook 'org-mode-hook '(lambda () (org-trello-mode 1)))


;; I take it back! Don't do it at all. I want asterisks back. It's also nice in vt100
;; spacemacs already does this. Don't do it twice
;; (if (not (cl-search "SPACEMACS" my-daemon-name))
;;     (progn (require 'org-bullets)
;;            (add-hook 'org-mode-hook '(lambda () (org-bullets-mode 1)))))


(add-hook 'javascript-mode-hook '(lambda () (fix-completion)))


;; (add-hook 'help-mode-hook '(lambda () (rainbow-identifiers-mode t)))


(defun my/auto-clojure-minor-modes ()
  (interactive)
  ;; Don't use parinfer mode
  ;; (parinfer-mode 1)
  (my/lisp-mode 1)
  ;; (cider-hydra-mode 1)
  (if (cl-search "SPACEMACS" my-daemon-name)
      ;; I don't want this to run for org-mode
      (helm-cider-mode 1)))

(add-hook 'clojure-mode-hook #'my/auto-clojure-minor-modes)

(add-hook 'helm-cider-mode-hook '(lambda () (my/lisp-mode 1)))
(add-hook 'clojurescript-mode-hook '(lambda () (my/lisp-mode 1)))
(add-hook 'racket-mode-hook '(lambda () (my/lisp-mode 1)))
(add-hook 'racket-repl-mode-hook '(lambda () (my/lisp-mode 1)))

;; This is perfect! -- for all programming language modes
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)

(progn
  ;; c sharp
  ;; (add-hook 'csharp-mode-hook 'omnisharp-mode)
  ;; (add-hook 'csharp-mode-hook #'company-mode)
  ;; (add-hook 'csharp-mode-hook #'flycheck-mode)

  (eval-after-load
      'company
    '(add-to-list 'company-backends 'company-omnisharp))

  (defun my-csharp-mode-setup ()
    (omnisharp-mode)
    (company-mode)
    (flycheck-mode)

    (setq indent-tabs-mode nil)
    (setq c-syntactic-indentation t)
    (c-set-style "ellemtel")
    (setq c-basic-offset 4)
    (setq truncate-lines t)
    (setq tab-width 4)
    (setq evil-shift-width 4)

                                        ;csharp-mode README.md recommends this too
                                        ;(electric-pair-mode 1)       ;; Emacs 24
                                        ;(electric-pair-local-mode 1) ;; Emacs 25

    (local-set-key (kbd "C-c r r") 'omnisharp-run-code-action-refactoring)
    (local-set-key (kbd "C-c C-c") 'recompile))

  (add-hook 'csharp-mode-hook 'my-csharp-mode-setup t))


(defun my-lisp-mode-autoload ()
  (interactive)
  (highlight-indent-guides-mode)
  (lispy-mode 1)
  ;;(selected-minor-mode -1)
  )

(add-hook 'my/lisp-mode-hook #'my-lisp-mode-autoload)


;; See this for how to enable it
;; $MYGIT/config/emacs/config/my-manage-minor-mode.el

;; fun my-lispy-mode-autoload ()
;;  (interactive)
;;  (selected-minor-mode -1))
;;
;;(add-hook 'lispy-mode-hook #'my-lispy-mode-autoload)



;; This worked nicely but I don't want it anymore
;; (add-hook 'helm-major-mode-hook '(lambda () (rainbow-identifiers-mode 1)))
                                        ; colorful helm


;; (add-to-list 'auto-minor-mode-alist '("\\(\\.el\\|emacs\\)\\'" . org-link-minor-mode))
;; (remove-from-list 'auto-minor-mode-alist '("\\(\\.el\\|emacs\\)\\'" . org-link-minor-mode))
;; This means when I edit strings in emacs lisp, org-link-minor-mode comes back on.
;; When that happens, the mode switches to lispy-string-edit-mode and back, but doesn't reopen, so doesnt trigger auto-minor-mode-alist
(add-hook 'emacs-lisp-mode-hook 'org-link-minor-mode)

;; I can't enable it for clojure because clojure uses [[]] fairly often
;; (add-hook 'clojure-mode-hook 'org-link-minor-mode)
(remove-hook 'clojure-mode-hook 'org-link-minor-mode)


(add-to-list 'auto-minor-mode-alist '("\\(\\.go\\)\\'" . org-link-minor-mode))
(add-to-list 'auto-minor-mode-alist '("\\(\\.txt\\)\\'" . org-link-minor-mode))
(add-to-list 'auto-minor-mode-alist '("\\(\\.rkt\\)\\'" . org-link-minor-mode))

;; Don't do this tests such as the following will become hidden \[\[ -e \]\]  [[ -e ]]
;; (add-to-list 'auto-minor-mode-alist '("\\(\\.sh\\)\\'" . org-link-minor-mode))
                                        ; I tried to use a hook instead but it shell-script-mode doesn't have a hook


;; How to remove from list, if you make a mistake
;; (delete '("\\.md\\'" . csharp-mode) auto-mode-alist)

(add-to-list 'auto-mode-alist '("\\(/\\|\\`\\)[Mm]akefile" . makefile-gmake-mode))
(add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Guardfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\(\\.irbrc\\|\\.pryrc\\)" . ruby-mode))


(when (> emacs-major-version 24)
  (progn
    ;; this require was breaking spacemacs
    ;;(require 'lsp-javascript-typescript)
    (add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))))


(defun haskell-mode-config ()
  "Start modes and options for haskell"
  (interactive)

  ;; Can these be used together?
  (haskell-mode)

  ;; I don't think so
  ;; (haskell-interactive-mode)

  ;; (message "Lisp Code '%s'..." (buffer-name))
  )


(add-to-list 'auto-mode-alist '("\\.hs\\'" . haskell-mode-config))

;; I disabled intero (after i got it working)
;; I want to try out haskell-ide-engine now
;;(if (not (cl-search "SPACEMACS" my-daemon-name))
;;  )

;; Enable intero everywhere. Just use vim if intero is slow
;; (add-hook 'haskell-mode-hook 'intero-mode)
                                        ;This automatically sets things up and is meant to be fast; [[https://www.reddit.com/r/haskell/comments/4m68zp/the_infamous_editoride_situation/][The infamous editor/IDE situation : haskell]]

(add-hook 'haskell-mode-hook 'haskell-doc-mode)
(add-hook 'haskell-mode-hook 'haskell-decl-scan-mode) ;This creates a menu. Access with M-l 

;; Forget jedi until I know it's working.
;;(add-hook 'python-mode-hook 'jedi:setup)
;;(add-hook 'python-mode-hook 'jedi-mode)
;;(setq jedi:complete-on-dot t) 

;; Forget jedi until I know it's working.
;; (eval-after-load "python"
;;   '(define-key python-mode-map "\C-cx" 'jedi-direx:pop-to-buffer))
;; (add-hook 'jedi-mode-hook 'jedi-direx:setup)

;; (remove-from-list 'auto-mode-alist '("\\.cl\\'" . slime-mode))

(add-to-list 'auto-mode-alist '("\\.asd\\'" . lisp-mode))
;; (cond
;;  ((string= my-lisp-mode "slime")
;;   (when (require 'slime nil 'noerror)
;;     ;; (add-to-list 'auto-mode-alist '("\\.cl\\'" . slime-mode))
;;     (add-to-list 'auto-mode-alist '("\\.asd\\'" . slime-mode))))
;;  ((string= my-lisp-mode "sly")
;;   (when (require 'sly nil 'noerror)
;;     (add-to-list 'auto-mode-alist '("\\.cl\\'" . sly-mode))
;;     (add-to-list 'auto-mode-alist '("\\.asd\\'" . sly-mode)))))
;;;; (remove-from-list 'auto-mode-alist '("\\.asd\\'" . slime-mode))


;; I do this instead of activating lispy the way I do below
;; ;; (add-hook 'my/lisp-mode-hook '(lambda () (lispy-mode 1)))

;; (when (require 'lispy nil 'noerror)

;;   (add-hook 'hy-mode-hook '(lambda () (lispy-mode 1)))
;;   (add-hook 'emacs-lisp-mode-hook '(lambda () (lispy-mode 1)))
;;   (add-hook 'lisp-mode-hook '(lambda () (lispy-mode 1)))
;;     (add-hook 'clojure-mode-hook '(lambda () (lispy-mode 1)))

;;   (when (require 'racket-mode nil 'noerror)
;;     (add-hook 'racket-mode-hook '(lambda () (lispy-mode 1)))))


(defun c-mode-customizations () (define-key c-mode-map (kbd "C-M-h") nil))
(add-hook 'c-mode-hook #'c-mode-customizations)

(global-diff-hl-mode 1)                 ; gui version only
(global-git-gutter+-mode 1)

;; (require 'git-gutter-fringe+) ; fringe is gui version only. it wont display in terminal emacs
;; (setq git-gutter-fr+-side 'right-fringe)
;; (git-gutter-fr+-minimal)

(yas-global-mode 1)
;; This makes it so all those yasnippet bindings work in all the emacs distros


                                        ; (longlines-mode 1) 


;; This is how to disable yasnippet for certain modes when yas-global-mode is on
;; (add-hook 'certain-major-mode-hook (lambda () (yas-minor-mode -1)))


(require 'cff)
;; (add-hook 'c++-mode-hook '(lambda () (define-key c-mode-base-map (kbd "M-o") 'cff-find-other-file)))
;; (add-hook 'c-mode-hook '(lambda () (define-key c-mode-base-map (kbd "M-o") 'cff-find-other-file)))


(add-to-list 'auto-mode-alist '("\\.jq$" . jq-mode))

(add-to-list 'auto-mode-alist '("\\.g4$" . antlr-mode))

(add-to-list 'auto-mode-alist '("\\.vtt$" . subed-mode))

(provide 'auto-mode-load)