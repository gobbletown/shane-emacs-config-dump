;; I have to start organising my shell scripts
;; which language will I use?
;; Initially, I should use elisp but when I've done more with other languages I should use those

;; TODO Make a command to construct and run a shell pipe from these

;; cat actually lets me write to stdin

;; I should be able to chain lots of commonly used pipes together

;; creation/transmitter funcs
(defset anode-scripts '("yes"
                        "cat"
                        ;; "writeto shane"
                        ))

;; mediation funcs
(defset pipe-scripts '("vipe"
                       "awkward"
                       "ised"
                       "pv"
                       "cat"))

;; capture/receiver funcs
(defset cathode-scripts '("v"
                          "cat"
                          "writeto shane"))

(defun zrepl (cmd)
  (sps (concat "zrepl -E " (q cmd))))

(defun zreplcm (cmd)
  (sps (concat "zrepl -cm -E " (q cmd))))

(defun pipe-construct-command (anode pipe cathode)
  (interactive (list (fz anode-scripts nil nil "pipe-construct-command anode: ")
                     (fz pipe-scripts nil nil "pipe-construct-command script: ")
                     (fz cathode-scripts nil nil "pipe-construct-command cathode: ")))
  (zrepl (s-join " | " (list anode (concat "tm pipe " (q pipe)) cathode))))

(define-key global-map (kbd "H-|") 'pipe-construct-command)

(provide 'my-pipe)