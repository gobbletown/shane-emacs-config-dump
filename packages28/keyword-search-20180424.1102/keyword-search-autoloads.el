;;; keyword-search-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "keyword-search" "keyword-search.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from keyword-search.el

(defvar keyword-search-alist '((alc . "http://eow.alc.co.jp/search?q=%s") (cookpad-ja . "http://cookpad.com/search/%s") (cookpad-us . "https://cookpad.com/us/search/%s") (debpkg . "http://packages.debian.org/search?keywords=%s") (debpkg-contents . "https://packages.debian.org/file:%s") (dict-org . "http://www.dict.org/bin/Dict?Form=Dict2&Database=*&Query=%s") (duckduckgo . "https://duckduckgo.com/?q=%s") (emacswiki . "https://duckduckgo.com/?q=%s+site%%3Aemacswiki.org&ia=web") (foldoc . "http://foldoc.org/%s") (github . "https://github.com/search?q=%s") (google . "http://www.google.com/search?q=%s") (google-books . "https://www.google.com/search?q=%s&tbm=bks") (google-finance . "http://www.google.com/finance?q=%s") (google-lucky . "http://www.google.com/search?btnI=I%%27m+Feeling+Lucky&q=%s") (google-images . "http://images.google.com/images?sa=N&tab=wi&q=%s") (google-groups . "http://groups.google.com/groups?q=%s") (google-news . "http://news.google.com/news?sa=N&tab=dn&q=%s") (google-scholar . "https://scholar.google.com/scholar?q=%s") (google-translate . "http://translate.google.com/?source=osdd#auto|auto|%s") (google-translate-en-ja . "http://translate.google.com/?source=osdd#en|ja|%s") (google-translate-ja-en . "http://translate.google.com/?source=osdd#ja|en|%s") (hackage . "http://hackage.haskell.org/package/%s") (hayoo . "http://holumbus.fh-wedel.de/hayoo/hayoo.html?query=%s") (hdiff . "http://hdiff.luite.com/cgit/%s") (jisho-org . "http://jisho.org/search/%s") (koji . "http://koji.fedoraproject.org/koji/search?match=glob&type=package&terms=%s") (melpa . "http://melpa.org/#/%s") (pypi . "https://pypi.python.org/pypi?%%3Aaction=search&term=%s&submit=search") (readthedocs-org . "https://readthedocs.org/search/?q=%s") (slashdot . "http://www.osdn.com/osdnsearch.pl?site=Slashdot&query=%s") (startpage . "https://startpage.com/do/search?cat=web&query=%s") (ubupkg . "http://packages.ubuntu.com/search?keywords=%s") (weblio-en-ja . "http://ejje.weblio.jp/content/%s") (wikipedia . "http://en.wikipedia.org/wiki/%s") (wikipedia-ja . "http://ja.wikipedia.org/wiki/%s") (yahoo . "http://search.yahoo.com/search?p=%s") (youtube . "http://www.youtube.com/results?search_query=%s")) "\
An alist of pairs (KEYWORD . URL) where KEYWORD is a keyword symbol and URL string including '%s' is the search url.

\"%\" should be replaced with \"%%\".")

(custom-autoload 'keyword-search-alist "keyword-search" t)

(defvar keyword-search-default 'google "\
Default search engine used by `keyword-search' and `keyword-search-quick' if none given.")

(custom-autoload 'keyword-search-default "keyword-search" t)

(autoload 'keyword-search "keyword-search" "\
Read a keyword KEY from `keyword-search-alist' with completion and then read a search term QUERY defaulting to the symbol at point.
It then does a websearch of the url associated to KEY using `browse-url'.

When called interactively, if variable `browse-url-new-window-flag' is
non-nil, load the document in a new window, if possible, otherwise use
a random existing one.  A non-nil interactive prefix argument reverses
the effect of `browse-url-new-window-flag'.

When called non-interactively, optional third argument NEW-WINDOW is
used instead of `browse-url-new-window-flag'.

\(fn KEY QUERY &optional NEW-WINDOW)" t nil)

(autoload 'keyword-search-at-point "keyword-search" "\
Read a keyword KEY from `keyword-search-alist' with completion and does a websearch of the symbol at point using `browse-url'.

When called interactively, if variable `browse-url-new-window-flag' is
non-nil, load the document in a new window, if possible, otherwise use
a random existing one.  A non-nil interactive prefix argument reverses
the effect of `browse-url-new-window-flag'.

When called non-interactively, optional second argument NEW-WINDOW is
used instead of `browse-url-new-window-flag'.

\(fn KEY &optional NEW-WINDOW)" t nil)

(autoload 'keyword-search-quick "keyword-search" "\
A wrapper of `keyword-search' which read the keyword and search query in a single input as argument TEXT from the minibuffer.

\(fn TEXT)" t nil)

(autoload 'keyword-search-quick-additionally "keyword-search" "\
In addition to a query of `keyword-search-get-query', read a string TEXT from the minibuffer.

This is a wrapper of `keyword-search-quick'

\(fn TEXT)" t nil)

(register-definition-prefixes "keyword-search" '("keyword-search-get-query"))

;;;***

;;;### (autoloads nil "keyword-search-extra" "keyword-search-extra.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from keyword-search-extra.el

(defvar keyword-search-extra-mode nil "\
Non-nil if Keyword-Search-Extra mode is enabled.
See the `keyword-search-extra-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `keyword-search-extra-mode'.")

(custom-autoload 'keyword-search-extra-mode "keyword-search-extra" nil)

(autoload 'keyword-search-extra-mode "keyword-search-extra" "\
Mode for an alist of extra language services.
There are so many languages that it will be late at load time if this mode is ON.
It takes 90 seconds to load it on an old computer.

If called interactively, enable Keyword-Search-Extra mode if ARG
is positive, and disable it if ARG is zero or negative.  If
called from Lisp,  also enable the mode if ARG is omitted or nil,
and toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

  If you believe \"Simple is best\", deactivate this mode.

\(fn &optional ARG)" t nil)

(defvar keyword-search-dessert-stomach-mode nil "\
Non-nil if Keyword-Search-Dessert-Stomach mode is enabled.
See the `keyword-search-dessert-stomach-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `keyword-search-dessert-stomach-mode'.")

(custom-autoload 'keyword-search-dessert-stomach-mode "keyword-search-extra" nil)

(autoload 'keyword-search-dessert-stomach-mode "keyword-search-extra" "\
User-customizable mode.
You can append functions to `keyword-search-dessert-stomach-mode-hook' by `add-hook'.

If called interactively, enable Keyword-Search-Dessert-Stomach
mode if ARG is positive, and disable it if ARG is zero or
negative.  If called from Lisp,  also enable the mode if ARG is
omitted or nil, and toggle it if ARG is `toggle'; disable the
mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

If you want to turn ON/OFF this mode, please append functions to `keyword-search-dessert-stomach-mode-toggle-hook'.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "keyword-search-extra" '("keyword-search-"))

;;;***

;;;### (autoloads nil "keyword-search-mad" "keyword-search-mad.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from keyword-search-mad.el

(defvar keyword-search-mad-mode nil "\
Non-nil if Keyword-Search-Mad mode is enabled.
See the `keyword-search-mad-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `keyword-search-mad-mode'.")

(custom-autoload 'keyword-search-mad-mode "keyword-search-mad" nil)

(autoload 'keyword-search-mad-mode "keyword-search-mad" "\
Mode for additional websites where experts or manias only use.

If called interactively, enable Keyword-Search-Mad mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp,  also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

Don't turn on this mode unless you choose to be mad.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "keyword-search-mad" '("keyword-search-"))

;;;***

;;;### (autoloads nil nil ("keyword-search-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; keyword-search-autoloads.el ends here
