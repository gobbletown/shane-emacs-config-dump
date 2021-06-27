(require 'my-utils)
(require 'my-nix)

;; lsof -i :55555
;; (port2pid 55555)
(defun port2process (port)
  (sh-notty (concat "lsof -i:" (str port))))
(defalias 'portgrep 'port2process)
(defalias 'port2pid 'port2process)
