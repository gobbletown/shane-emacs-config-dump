;; THIS FILE IS NOT LOADED


(defun anaconda-mode-documentation-view (result)
  "Show documentation view for rpc RESULT, and return buffer."
  (let ((buf (get-buffer-create "*Anaconda*")))
    (with-current-buffer buf
      (view-mode -1)
      (erase-buffer)
      (mapc
       (lambda (it)
         (insert (propertize (aref it 0) 'face 'bold))
         (insert "\n")
         (insert (s-trim-right (aref it 1)))
         (insert "\n\n"))
       result)
      (view-mode 1)
      (goto-char (point-min))
      buf)))

;; old-fashioned advice
;; can't remove advice
(defadvice anaconda-mode-documentation-view (after libertyprime/use-markdown-mode-instead activate)
  (markdown-mode 1))

;; nadvice (new advice)
;; e ia nadvice
;; It's for backwards compatibility
;; (to help users of defadvice move to the new advice system without dropping support for Emacs)
(advice-add
 'anaconda-mode-documentation-view
 :after (lambda () ;; (markdown-mode 1)
          (markdown-mode)))

(advice-remove
 'anaconda-mode-documentation-view
 (lambda () (markdown-mode)))

;; Unfortunately advice doesnt work (maybe because it opens a new buffer) so I need to redefine the function

(defun anaconda-mode-documentation-view (result)
  "Show documentation view for rpc RESULT, and return buffer."
  (let ((buf (get-buffer-create "*Anaconda*")))
    (with-current-buffer buf
      (markdown-mode)
      (view-mode -1)
      (erase-buffer)
      (mapc
       (lambda (it)
         (insert (propertize (aref it 0) 'face 'bold))
         (insert "\n")
         (insert (s-trim-right (aref it 1)))
         (insert "\n\n"))
       result)
      (view-mode 1)
      (goto-char (point-min))
      buf)))