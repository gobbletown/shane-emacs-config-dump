;; This file should contain my own implementations of convenience functions
;; Only pure implementations are allowed. No requires. No cl-loop.

(defun my/oddp (n)
  (zerop (mod n 2)))

(provide 'my-lispier)