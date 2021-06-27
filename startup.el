; I am not currently using this file

; One alternative to the hook is to set the initial-buffer-choice
; variable. This is particularly useful if there are multiple buffers or a
; number of functions on the hook. The function on this variable needs to
; return a buffer. Naively this might be:

; (setq initial-buffer-choice (lambda ()
;     (org-agenda-list 1)
;     (get-buffer "*Org Agenda*")))    