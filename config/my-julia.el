;; [[https://emacs.stackexchange.com/questions/18775/how-to-get-a-fully-functional-julia-repl-in-emacs?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa][term - How to get a fully functional Julia REPL in emacs? - Emacs Stack Exchange]]

(defun julia-repl ()
  "Runs Julia in a screen session in a `term' buffer."
  (interactive)
  
  (require 'term)
  
  (let ((termbuf (apply 'make-term "Julia REPL" "screen" nil (split-string-and-unquote "julia"))))
    (set-buffer termbuf)
    (term-mode)
    (term-char-mode)
    (switch-to-buffer termbuf)))
(global-set-key (kbd "C-x j") 'julia-repl)