(require 'doc-view)

;; It appears that defining the function first before requiring
;; pdf-tools fixes the problem.
;; Deactivated version
(defun pdf-tools-install (&optional no-query-p skip-dependencies-p
                                    no-error-p force-dependencies-p)
  "Install PDF-Tools in all current and future PDF buffers.

If the `pdf-info-epdfinfo-program' is not running or does not
appear to be working, attempt to rebuild it.  If this build
succeeded, continue with the activation of the package.
Otherwise fail silently, i.e. no error is signaled.

Build the program (if necessary) without asking first, if
NO-QUERY-P is non-nil.

Don't attempt to install system packages, if SKIP-DEPENDENCIES-P
is non-nil.

Do not signal an error in case the build failed, if NO-ERROR-P is
non-nil.

Attempt to install system packages (even if it is deemed
unnecessary), if FORCE-DEPENDENCIES-P is non-nil.

Note that SKIP-DEPENDENCIES-P and FORCE-DEPENDENCIES-P are
mutually exclusive.

Note further, that you can influence the installation directory
by setting `pdf-info-epdfinfo-program' to an appropriate
value (e.g. ~/bin/epdfinfo) before calling this function.

See `pdf-view-mode' and `pdf-tools-enabled-modes'."
  (interactive)
  (if (or (pdf-info-running-p)
          (ignore-errors (pdf-info-check-epdfinfo) t))
      (pdf-tools-install-noverify)
    (let ((target-directory
           (or (and (stringp pdf-info-epdfinfo-program)
                    (file-name-directory
                     pdf-info-epdfinfo-program))
               pdf-tools-directory)))
      (message "PDF Tools not activated"))))

;; This prevents asking to rebuild epdfinfo, which breaks startup
;; Appears to not work
(defadvice pdf-tools-install (around no-y-or-n activate)
  (flet ((yes-or-no-p (&rest args) nil)
         (y-or-n-p (&rest args) nil))
    ad-do-it))

(require 'pdf-tools)

(use-package pdf-tools
  :pin manual ;; manually update
  :config
  ;; initialise. Do not do this. It will hang emacs
  ;; (pdf-tools-install)
  ;; open pdfs scaled to fit page
  (setq-default pdf-view-display-size 'fit-page)
  ;; automatically annotate highlights
  (setq pdf-annot-activate-created-annotations t)
  ;; use normal isearch
  (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
  ;; turn off cua so copy works
  (add-hook 'pdf-view-mode-hook (lambda () (cua-mode 0)))
  ;; more fine-grained zooming
  (setq pdf-view-resize-factor 1.1)
  ;; keyboard shortcuts
  (define-key pdf-view-mode-map (kbd "h") 'pdf-annot-add-highlight-markup-annotation)
  (define-key pdf-view-mode-map (kbd "t") 'pdf-annot-add-text-annotation)
  (define-key pdf-view-mode-map (kbd "D") 'pdf-annot-delete))

;; This should mean that eww uses pdf-tools instead of doc-view for pdfs
(defvar tvipe/prefer-pdf-tools (fboundp 'pdf-view-mode))
(defun tvipe/start-pdf-tools-if-pdf ()
  ;; This isn't being run
  ;; (message "%s" "tvipe/start-pdf-tools-if-pdf")
  (when (and tvipe/prefer-pdf-tools
             (eq doc-view-doc-type 'pdf))
    (pdf-view-mode)))

(add-hook 'doc-view-mode-hook 'tvipe/start-pdf-tools-if-pdf)

(setq tvipe/prefer-pdf-tools t)

;; I actually want to use my own thing
;; Can I configure doc-view?

;; agi elpa-pdf-tools-server
;; Unfortunately, this has to be an absolute path
(setq pdf-info-epdfinfo-program "/home/shane/scripts/epdfinfo")

(provide 'my-pdf-tools)