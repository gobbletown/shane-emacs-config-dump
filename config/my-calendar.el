(require 'lunar)

(defun vs-lunar-phases ()
  (interactive)
  (lunar-phases)
  ;; (with-current-buffer "*Phases of Moon*" (tm-edit-vs-in-nw))
  (with-current-buffer "*Phases of Moon*" (e/open-in-vim))
  (kill-buffer "*Phases of Moon*"))

(provide 'my-calendar)