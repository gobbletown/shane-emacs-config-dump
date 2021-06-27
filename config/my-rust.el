(provide 'my-rust)

  ;; Rust settings
  (require 'rust-mode)
  (with-eval-after-load 'rust-mode
    ;; Rust Formatter. Run rustfmt before saving rust buffers
    (setq rust-format-on-save t))


;; racer-rust-src-path

;; (add-hook 'rust-mode-hook
;;           '(lambda ()
;;              (setq tab-width 2)
;;              (setq racer-cmd (concat (getenv "HOME") "/.cargo/bin/racer")) ;; Rustup binaries PATH
;;              (setq racer-rust-src-path (concat (getenv "HOME") "/.rust/rust/src"))
;;              (setq company-tooltip-align-annotations t)
;;          (add-hook 'rust-mode-hook #'racer-mode)
;;              (add-hook 'racer-mode-hook #'eldoc-mode)
;;              (add-hook 'racer-mode-hook #'company-mode)
;;              (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
;;          (add-hook 'rust-mode-hook 'cargo-minor-mode)
;;              (local-set-key (kbd "TAB") #'company-indent-or-complete-common)
;;              (local-set-key (kbd "C-c <tab>") #'rust-format-buffer)))

;;(use-package racer
;;  :config (progn
;;            (setq company-tooltip-align-annotations t ;
;;                  racer-cmd (expand-file-name "~/.cargo/bin/racer") 
;;                  racer-rust-src-path (expand-file-name (getenv "RUST_SRC_PATH")))
;;            (add-hook 'rust-mode-hook  #'racer-mode)
;;            (add-hook 'racer-mode-hook #'eldoc-mode)
;;            (add-hook 'racer-mode-hook #'company-mode)))


;; ;Don't use flymake
;; (require 'flymake-rust)
;; (add-hook 'rust-mode-hook 'flymake-rust-load)


;; (add-hook 'rust-mode-hook #'racer-mode)
;; (add-hook 'racer-mode-hook #'eldoc-mode)
;; (add-hook 'racer-mode-hook #'company-mode)

;; (define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
;; (setq company-tooltip-align-annotations t)

;; If you want to use rustc compiler, you must add following string:
(setq flymake-rust-use-cargo 1)

(defun set-rust-env ()
  (setq tab-width 2)
  (setq racer-cmd (concat (getenv "HOME") "/.cargo/bin/racer")) ;; Rustup binaries PATH
  (setq racer-rust-src-path (shell-command-to-string "echo -n `rustc --print sysroot`/lib/rustlib/src/rust/src"))
  (setq company-tooltip-align-annotations t)
  (add-hook 'rust-mode-hook #'racer-mode)
  (add-hook 'racer-mode-hook #'eldoc-mode)
  (add-hook 'racer-mode-hook #'company-mode)
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
  (add-hook 'rust-mode-hook 'cargo-minor-mode)
  (local-set-key (kbd "TAB") #'company-indent-or-complete-common)
  (local-set-key (kbd "C-c <tab>") #'rust-format-buffer))

(use-package rustic
  :config
  (setq rustic-lsp-client nil))


;; don't forget to install racer:
;; rustup toolchain add nightly
;; cargo +nightly install racer
;; rustup component add rust-src
;; rustup component add rustfmt
(use-package racer
  :ensure t
  :config
  (add-hook 'racer-mode-hook #'company-mode)
  (setq company-tooltip-align-annotations t)
  (setq racer-rust-src-path "~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src"))

(use-package rust-mode
  :ensure t
  :config
  (add-hook 'rust-mode-hook #'racer-mode)
  (add-hook 'racer-mode-hook #'eldoc-mode)
  (setq rust-format-on-save t))

(use-package cargo
  :ensure t
  :config
  (setq compilation-scroll-output t)
  (add-hook 'rust-mode-hook 'cargo-minor-mode))

(use-package flycheck-rust
  :ensure t
  :config
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
  (add-hook 'rust-mode-hook 'flycheck-mode))

(require 'rustic)
(define-key rustic-mode-map (kbd "C-c C-c") nil)
(setq rustic-mode-map
      (let ((map (make-sparse-keymap)))
        (define-key map (kbd "C-c C-p") 'rustic-popup)
        (define-key map (kbd "C-c C-u") 'rustic-compile)
        (define-key map (kbd "C-c C-i") 'rustic-recompile)
        (define-key map (kbd "C-c C-k") 'rustic-cargo-check)
        (define-key map (kbd "C-c C-c") 'rustic-cargo-current-test)
        (define-key map (kbd "C-c C-o") 'rustic-format-buffer)
        (define-key map (kbd "C-c C-d") 'rustic-racer-describe)
        (define-key map (kbd "C-c ,") 'rustic-docstring-dwim)

        ;; The below are already defined in the popup
        (define-key map (kbd "C-c C-b") 'rustic-cargo-build)
        (define-key map (kbd "C-c C-r") 'rustic-cargo-run)
        (define-key map (kbd "C-c C-f") 'rustic-cargo-fmt)
        (define-key map (kbd "C-c C-t") 'rustic-cargo-test)
        (define-key map (kbd "C-c C-l") 'rustic-cargo-clippy)
        (define-key map (kbd "C-c C-n") 'rustic-cargo-outdated)
        map))

;; (define-key rustic-mode-map (kbd "C-c C-d") 'rustic-racer-describe)

;; Run this to install sources for rust, so this works: rustup component add rust-src
(add-hook 'rust-mode-hook #'set-rust-env)