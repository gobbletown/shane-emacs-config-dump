(provide 'my-marmalade)

(add-to-list 'gnutls-trustfiles
             (expand-file-name
              "~/etc/tls/certificates/comodo.rsa.ca.intermediate.crt"))
(mkdir-p "~/etc/tls/certificates/")

(require 'gnutls)