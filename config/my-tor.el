(defun tor-new-id ()
  (interactive)
  (compile "journalctl --no-pager -f -u tor")
  (sn "sudo /etc/init.d/tor restart"))

(provide 'my-tor)