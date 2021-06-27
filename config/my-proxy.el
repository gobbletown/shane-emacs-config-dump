;; (setq url-proxy-services '(("no_proxy" . "my-corp-proxy")
;;                            ("http" . "my-corp-proxy:8080")
;;                            ("https" . "my-port-proxy:8080")))

(setq url-proxy-services '(
                           ;; ("no_proxy" . "work\\.com")
                           ("http" . "localhost:8555")
                           ("https" . "localhost:8555")))
(never
 (setq url-proxy-services nil))

;; (setq url-proxy-services nil)

(defun sp-mitm ()
  (interactive)
  (nw "sp-mitm"))

(defun mitmproxy ()
  (interactive)
  (snc "tm sel localhost_current:mitmproxy-8555.0"))

(provide 'my-proxy)