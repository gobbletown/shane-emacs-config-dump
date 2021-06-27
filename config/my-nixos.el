;; List out all the 'list' commands I want to manage
;; Along with what they do
;; Then I can slugify them to create commands

;; I should also try to associate them with other commands

(defset nix-command-list
  '(("nix-channel --list" "List out the channels")
    ("nix-env -qa" "List packages")))

(defun nix-select-package ()
  (interactive)
  (xc (fzsh "nix-env -qa" t)))

;; TODO Make it so fz also uses comments
;; I want completion annotations
;; https://garethrees.org/2015/02/09/emacs/
;; sp +/"Support :annotation-function of completion-extra-properties." "$EMACSD/packages28/ivy-0.13.4/Changelog.org"
;; TODO Blog about this
;; (never
;;  (defun my-annotation-function (s)
;;    (let ((item (assoc s minibuffer-completion-table)))
;;      (when item (concat "  -- " (second item)))))

;;  (defvar my-completions '(("a" "description of a") ("b" "b's description")))

;;  (let ((completion-extra-properties '(:annotation-function my-annotation-function)))
;;    (completing-read "Prompt: " my-completions)))


(defun nix-run-command ()
  (selectrum-completing-read
   "nix-command: "
   (mapcar 'car nix-command-list)
   nil
   nil
   nil
   nil
   (mapcar 'second nix-command-list))
  (fz nix-command-list nil nil "nix-command: "))


(provide 'my-nixos)