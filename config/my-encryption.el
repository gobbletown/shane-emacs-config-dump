(require 'my-utils)

(provide 'my-encryption)

;; Gradually convert scripts like these to elisp equivalents
(_ns encryption
     (defun crc32 (string)
       (interactive)
       ;; The extra bash is only necessary for the tmux version
       ;; (bash "bash -c 'crc32 <(cat)' | s chomp" string t)
       (sh-notty "crc32 <(cat) | s chomp" string))

     (defun my/sha1 (string)
       "Can't replace existing sha1 builtin function."
       (interactive)
       ;; The extra bash is only necessary for the tmux version
       ;; (bash "bash -c 'crc32 <(cat)' | s chomp" string t)

       ;; (sh-notty "zsh -c 'sha1sum =(cat) | cut -d \\  -f 1' | s chomp" string)
       (sh-notty "openssl dgst -sha1 -binary" string)))