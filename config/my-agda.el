(add-hook 'agda2-mode-hook
          '(lambda ()
            ; If you do not want to use any input method:
            (deactivate-input-method)
            ; (In some versions of Emacs you should use
            ; inactivate-input-method instead of
            ; deactivate-input-method.)

            ; If you want to use the X input method:
            (set-input-method "X")))

(provide 'my-agda)