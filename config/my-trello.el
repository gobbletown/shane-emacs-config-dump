(require 'org-trello)

(custom-set-variables
 '(orgtrello-log-level orgtrello-log-debug)      ;; log level to debug
 '(org-trello-current-prefix-keybinding "C-c x") ;; C-c x as the default prefix
 '(orgtrello-setup-use-position-in-checksum-computation nil) ;; checksum without position
 '(org-trello-files '("/home/shane/notes2018/ws/trello/doc.trello"
                      "/home/shane/notes2018/ws/trello/doc.org")))

(provide 'my-trello) ;; automatic org-trello on files