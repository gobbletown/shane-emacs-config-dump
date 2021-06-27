(require 'mastodon)

(let ((path (umn "~/.config/mastodon"))
      (fn "mastodon.plstore"))
  (snc (cmd "mkdir" "-p" path))
  (setq mastodon-client--token-file (concat path "/" fn)))

(setq mastodon-auth-source-file "~/.authinfo")

(provide 'my-mastodon)