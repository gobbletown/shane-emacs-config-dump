
;; j:add-hook-last

(defun add-hook-ignore (hook fun-to-add)
  ;; (set hook (append (eval hook) (list fun-to-add)))
  (add-hook hook (eval `(dff (funcall ,fun-to-add)))))

(defun remove-hook-ignore (hook fun-to-remove)
  ;; (set hook (append (eval hook) (list fun-to-remove)))
  (remove-hook hook (eval `(dff (funcall ,fun-to-remove)))))

(defun remove-hook-ignore (hook fun-to-remove)
  ;; (set hook (append (eval hook) (list fun-to-remove)))
  (remove-hook hook fun-to-remove))

;; lrk:kill-buffer-hook

(provide 'my-hooks)