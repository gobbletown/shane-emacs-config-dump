(require 'my-custom)

;; https://asciinema.org/a/I7DmFZ9IWdTkU0dwMZjl9uwiS

;; This may also contain a subgroup with the :group option
(defgroup system-custom nil
  "My system config"
  :prefix "system-custom-")


;; TODO Make a function for the toggle cloud to select from custom options


;; Can't use nil for a variable of type string
;; custom will error
(defcustom tor-country ""
  "TOR country"
  :type 'string
  :group 'system-custom
  :initialize #'custom-initialize-default
  :options (list "all"
                 "au"
                 "de"
                 "fr")
  :set (lambda (_sym value)
         (if (string-equal value "all")
             (setq value ""))
         (set _sym (or value ""))
         (try
          (if (string-or value nil)
              (progn
                (sn "sudo sed -i \"s/^# \\\\(ExitNodes\\\\)/\\\\1/\" /etc/tor/torrc")
                (sn (format "sudo sed -i \"/^ExitNodes {/s/^\\\\(.*{\\\\)[^}]*\\\\(}.*\\\\)$/\\\\1%s\\\\2/\" \"/etc/tor/torrc\"" value)))
            (sn "sudo sed -i \"s/^\\\\(ExitNodes\\\\)/# \\\\1/\" /etc/tor/torrc"))
          nil)
         (tor-new-id))
  ;; The default :initialize is custom-initialize-reset
  ;; And uses the :set function
  ;; :initialize (lambda
  :get (lambda (_sym)
         (try
          (progn (let ((cfgval (string-or (chomp (sn "sed -n \"/^ExitNodes {/s/.*{\\([^}]\\+\\)}.*/\\1/p\" \"/etc/tor/torrc\""))
                                          nil)))
                   (if cfgval
                       (set _sym cfgval)))
                 (eval (string-or _sym nil)))
          "")))


(defcustom spacy-model ""
  "spaCy model"
  :type 'string
  :group 'system-custom
  :initialize #'custom-initialize-default
  :options (list "en"
                 "en_core_web_trf"
                 "en_core_web_sm"
                 "en_pytt_bertbaseuncased_lg"
                 "de_core_news_sm"
                 "fr")
  :set (lambda (_sym value)
         (myrc-set (tr "-" "_" (sym2str _sym)) value)
         (set _sym (sor value)))
  ;; The default :initialize is custom-initialize-reset
  ;; And uses the :set function
  ;; :initialize (lambda
  :get (lambda (_sym)
         (let* ((yaml (yamlmod-read-file "/home/shane/notes/myrc.yaml"))
                (cfgval (sor (ht-get yaml (tr "-" "_" (sym2str _sym))))))

           (if cfgval
               (set _sym cfgval)
             ""))))


(defcustom default-gpt-summarizer ""
  "Which GPT-3 based summarization script to use"
  :type 'string
  :group 'system-custom
  :initialize #'custom-initialize-default
  :options (list "eli5"
                 "summarize"
                 "tldr")
  :set (lambda (_sym value)
         (myrc-set (tr "-" "_" (sym2str _sym)) value)
         (set _sym (sor value)))
  ;; The default :initialize is custom-initialize-reset
  ;; And uses the :set function
  ;; :initialize (lambda
  :get (lambda (_sym)
         (let* ((yaml (yamlmod-read-file "/home/shane/notes/myrc.yaml"))
                (cfgval (sor (ht-get yaml (tr "-" "_" (sym2str _sym))))))

           (if cfgval
               (set _sym cfgval)
             "tldr"))))

(defcustom google-ngrams-corpus ""
  "Google ngrams corpus"
  :type 'string
  :group 'system-custom
  :initialize #'custom-initialize-default
  :options (list "15 # english 2012"
                 "16 # english fiction"
                 "26 # english 2019")
  :set (lambda (_sym value)
         (myrc-set (tr "-" "_" (sym2str _sym)) value)
         (set _sym (sor value)))
  ;; The default :initialize is custom-initialize-reset
  ;; And uses the :set function
  ;; :initialize (lambda
  :get (lambda (_sym)
         (let* ((yaml (yamlmod-read-file "/home/shane/notes/myrc.yaml"))
                (cfgval (sor (ht-get yaml (tr "-" "_" (sym2str _sym))))))

           (if cfgval
               (set _sym cfgval)
             "26 # english 2019"))))


(defcustom sh-update ""
  "Export UPDATE=y when executing sn and such"
  :type 'boolean
  :group 'system-custom
  ;; TODO Find out what the proper args are
  ;; #'custom-initialize-default
  :initialize (lambda(_sym _exp)
                (custom-initialize-default _sym nil)))


;; ;; 2nd var is default val
;; (defcustom weechat-matrix-password ""
;;   "List of enabled Custom Themes, highest precedence first.
;; Setting this variable through Customize calls `enable-theme' or
;; `load-theme' for each theme in the list."
;;   :group 'system
;;   ;; :type '(repeat symbol)
;;   :type  'string
;;   :set-after '(custom-theme-directory custom-theme-load-path
;;                                       custom-safe-themes)
;;   :risky t
;;   ;; :set; a function to set the value of the symbol
;; 	;; when using the Customize user interface.  It takes two arguments,
;; 	;; the symbol to set and the value to give it.
;;   :set (lambda (symbol themes)
;;          (let (failures)
;;            (setq themes (delq 'user (delete-dups themes)))
;;            ;; Disable all themes not in THEMES.
;;            (dolist (theme (and (boundp symbol)
;;                                (symbol-value symbol)))
;;              (unless (memq theme themes)
;;                (disable-theme theme)))
;;            ;; Call `enable-theme' or `load-theme' on each of THEMES.
;;            (dolist (theme (reverse themes))
;;              (condition-case nil
;;                  (if (custom-theme-p theme)
;;                      (enable-theme theme)
;;                    (load-theme theme))
;;                (error (push theme failures)
;;                       (setq themes (delq theme themes)))))
;;            (enable-theme 'user)
;;            (custom-set-default symbol themes)
;;            (when failures
;;              (message "Failed to enable theme(s): %s"
;;                       (mapconcat #'symbol-name failures ", "))))))

(defun customize-system ()
  (interactive)
  (customize-group 'system-custom))

(define-key global-map (kbd "H-c") 'customize-system)
(define-key global-map (kbd "H-C") 'customize-system)

(provide 'my-system-custom)