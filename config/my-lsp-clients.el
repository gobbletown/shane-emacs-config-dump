(require 'lsp)

(add-to-list 'lsp-language-id-configuration '(nix-mode . "nix"))
(lsp-register-client
 (make-lsp-client :new-connection (lsp-stdio-connection '("rnix-lsp"))
                  :major-modes '(nix-mode)
                  :server-id 'nix))


;; (add-to-list 'lsp-language-id-configuration '(sql-mode . "sql"))
;; (add-to-list 'lsp-language-id-configuration '(sql-interactive-mode . "sql"))
;; (lsp-register-client
;;  (make-lsp-client :new-connection (lsp-stdio-connection '("sqls"))
;;                   :major-modes '(sql-mode, sql-interactive-mode)
;;                   :server-id 'sql))

(provide 'my-lsp-clients)