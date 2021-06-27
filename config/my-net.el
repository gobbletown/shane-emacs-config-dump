(require 'parse-csv)

;; What I really need is a list of services + ports then work on that
;; But I'm using nmap, so nah.

(defun csv-load (data)
  (parse-csv-string-rows data ?, ?\" "\n"))

(defun n-list-open-ports (&optional hn fast)
  (if (not hn)
      (setq hn "localhost"))
  (csv-load (snc (concat
                  (if fast
                      (cmd "n-list-open-ports" "-F" hn)
                    (cmd "n-list-open-ports" hn))
                  "|sed 1d"))))
(defalias 'list-open-ports 'n-list-open-ports)
;; (list-open-ports nil)

(defun n-get-free-port (&optional from to)
  (setq from (or from "40000"))
  (setq to (or to "65535"))
  (snc (cmd "n-get-free-port-from-range" from to)))

(provide 'my-net)