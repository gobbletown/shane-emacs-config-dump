;;; gnus-summary-ext-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "gnus-summary-ext" "gnus-summary-ext.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from gnus-summary-ext.el

(defvar gnus-summary-ext-mime-actions nil "\
A list of sets of actions to apply to different mime types.
Each set is a list whose car is a description of the set, and whose cdr is a list
of sublists indicating what to do with a particular mime type. Each sublist contains
the following items:
 1) a predicate function evaluating to true if the mime type matches. It may make use
    of the following variables: handle : the handle for the part, size : number of chars in the part, 
    type : the MIME type (e.g. \"image/png\"), subtype : the subtype (e.g. \"png\"), 
    supertype : the supertype (e.g. \"image\"), filename : the filename.
 2) an action function (one of the functions listed in `gnus-mime-action-alist')
 3) an optional argument for the function (currently only used with `gnus-mime-pipe-part').")

(custom-autoload 'gnus-summary-ext-mime-actions "gnus-summary-ext" t)

(autoload 'gnus-summary-ext-limit-to-mime-type "gnus-summary-ext" "\
Limit the summary buffer to articles containing MIME parts with types matching REGEX.
If REVERSE (the prefix), limit to articles that don't match.

\(fn REGEX &optional REVERSE)" t nil)

(autoload 'gnus-summary-ext-apply-to-marked-safely "gnus-summary-ext" "\
Call function FN for all articles that are process/prefixed.
FN should be a function which takes a single argument - an article number,
and will be called with that article selected, but without running any hooks.
If no articles are marked use the article at point or articles in region, 
and if ARG is non-nil include that many articles forward (if positive) or 
backward (if negative) from the current article. 

See `gnus-summary-apply-to-marked' if you want to run the appropriate hooks after
selecting each article, and see `gnus-summary-iterate' for iterating over articles
without selecting them.

\(fn ARG FN)" t nil)

(autoload 'gnus-summary-ext-apply-to-marked "gnus-summary-ext" "\
Evaluate any lisp expression for all articles that are process/prefixed.
FN should be a function which takes a single argument - the current article number,
and will be called after selecting that article, and running any hooks.
If no articles are marked use the article at point or articles in region, 
and if ARG is non-nil include that many articles forward (if positive) or 
backward (if negative) from the current article. 

See `gnus-summary-ext-apply-to-marked-safely' for selecting each article without running hooks,
and see `gnus-summary-iterate' for iterating over articles without selecting them.

\(fn ARG FN)" t nil)

(autoload 'gnus-summary-ext-limit-to-num-parts "gnus-summary-ext" "\
Limit the summary buffer to articles containing between MIN & MAX attachments.
If MIN/MAX is nil then limit to articles with at most/least MAX/MIN attachments respectively.
If REVERSE (the prefix), limit to articles that don't match.

\(fn MIN MAX &optional REVERSE)" t nil)

(autoload 'gnus-summary-ext-limit-to-size "gnus-summary-ext" "\
Limit the summary buffer to articles of size between MIN and MAX bytes.
If MIN/MAX is nil then limit to sizes below/above MAX/MIN respectively.
If REVERSE (the prefix), limit to articles that don't match.

Note: the articles returned might not match the size constraints exactly, but it should be fairly close.

\(fn MIN MAX &optional REVERSE)" t nil)

(autoload 'gnus-summary-ext-limit-to-filename "gnus-summary-ext" "\
Limit the summary buffer to articles containing attachments with names matching REGEX.
If REVERSE (the prefix), limit to articles that don't match.
Note: REGEX should match the whole filename, so you may need to put .* at the beginning and end.

\(fn REGEX &optional REVERSE)" t nil)

(autoload 'gnus-summary-ext-mime-actions-prompt "gnus-summary-ext" "\
Prompt user for an item from `gnus-summary-ext-mime-actions', or create a new one.
Also prompts for whether to ignore confirmation prompts and errors.
Returns a list containing a pair of booleans indicating whether to ignore prompts and errors
respectively, followed by lists of predicates actions and arguments indicating how to 
act on different mime types." nil nil)

(autoload 'gnus-summary-ext-mime-actions-on-parts "gnus-summary-ext" "\
Perform ACTIONS on all MIME parts in the current buffer. 
NOPROMPT and NOERROR indicate whether to ignore confirmation prompts and errors respectively.
The ACTIONS argument should be a list of sublists with each sublist containing a predicate function
which evaluates to true on the attachments to be acted on, the corresponding action, and any arguments, 
in that order. 
When called interactively an element of  `gnus-summary-ext-mime-actions' will be prompted for.

\(fn ACTIONS &optional NOPROMPT NOERROR)" t nil)

(autoload 'gnus-summary-ext-act-on-parts-in-marked "gnus-summary-ext" "\
Do something with all MIME parts in articles that are process/prefixed.
If ARG is non-nil or a prefix arg is supplied it indicates how many articles forward (if positive) or 
backward (if negative) from the current article to include. Otherwise if region is active, process
the articles within the region, otherwise process the process marked articles.
The ACTIONS, NOPROMPT and NOERROR arguments are the same as for `gnus-summary-ext-mime-actions-on-parts'.
This command just applies that function to the marked articles.

\(fn ACTIONS &optional NOPROMPT NOERROR ARG)" t nil)

(autoload 'gnus-summary-ext-fetch-field "gnus-summary-ext" "\
Same as `mail-fetch-field' but match field name by regular expression instead of string.
FIELD-REGEX is a regular expression matching the field name, LAST ALL and LIST are the
same as in `mail-fetch-field'.

\(fn FIELD-REGEX &optional LAST ALL LIST)" nil nil)

(autoload 'gnus-summary-ext-field-value "gnus-summary-ext" "\
The same as `message-fetch-value', but match field name by regular expression instead of string.
HEADER-REGEX is a regular expression matching the header name.
If NOT-ALL is non-nil then only the first matching header is returned.

\(fn HEADER-REGEX &optional NOT-ALL)" nil nil)

(autoload 'gnus-summary-ext-filter "gnus-summary-ext" "\
Return list of article numbers of articles in summary buffer which match EXPR.
EXPR can be any elisp form to be eval'ed for each article which returns non-nil for required articles.
It can utilize named filters stored in `gnus-summary-ext-saved-filters' (which should be surrounded
in parentheses, e.g: (filter)), and any of the following functions:

 (subject REGEXP) : matches articles with subject field matching REGEXP
 (from REGEXP) : matches articles with from field matching REGEXP 
 (to REGEXP) : matches articles with To: field matching REGEXP
 (cc REGEXP) : matches articles with Cc: field matching REGEXP
 (recipient REGEXP) : matches articles with To: or Cc: field matching REGEXP
 (address REGEXP) : matches articles with To:, Cc: or From: field matching REGEXP
 (read) : matches articles that have been read
 (unread) : matches articles that haven't yet been read (equivalent to (not (read)))
 (replied) : matches articles which have been replied to 
 (unreplied) : matches articles which haven't been replied to (equivalent to (not (replied)))
 (age DAYS) : matches articles received before/after DAYS days ago (see `gnus-summary-limit-to-age')
 (agebetween MIN MAX) : matches articles received between MIN and MAX days ago.
 (marks STR) : matches articles with any of the marks in STR (see `gnus-summary-limit-to-marks')

The following functions can also be used but will be much slower since they are evaluated after selecting
each article:

 (witharticle PRED)     : matches articles for which PRED returns non-nil after selecting article buffer
 (withorigarticle PRED) : matches articles for which PRED returns non-nil after selecting original (unformatted) article buffer
 (content REGEXP)  : matches articles containing text that matches REGEXP 
 (header HDRX REGEXP) : matches articles containing a header matching HDRX whose value matches REGEXP
 (filename REGEXP) : matches articles containing file attachments whose names match REGEXP
 (mimetype REGEXP) : matches articles containing mime parts with type names matching REGEXP
 (numparts MIN MAX) : matches articles with between MIN and MAX parts/attachments (inclusive).
                      Note: html and embedded images count as parts, and often there are several of these in an article.
 (size MIN MAX) : matches articles of approximate size between MIN & MAX bytes. 
                  If MAX is omitted then just check if size is bigger than MIN bytes

For example, to filter messages received within the last week, either from alice or sent to bob:
  (gnus-summary-ext-filter '(and (age -7) (or (from \"alice\") (to \"bob\"))))

To filter unreplied messages that are matched by either of the saved filters 'work' or 'friends':
  (gnus-summary-ext-filter '(and (unreplied) (or (work) (friends))))

\(fn EXPR)" nil nil)

(autoload 'gnus-summary-ext-limit-filter "gnus-summary-ext" "\
Limit the summary buffer to articles which match EXPR.
EXPR can be any elisp form to be eval'ed for each article which returns non-nil for required articles.
It can utilize named filters stored in `gnus-summary-ext-saved-filters' (which should be surrounded
in parentheses, e.g: (filter)), and any of the builtin functions as described in `gnus-summary-ext-filter'.

\(fn EXPR)" t nil)

(autoload 'gnus-summary-ext-uu-mark-filter "gnus-summary-ext" "\
Apply/remove process mark to all articles in the summary buffer which match EXPR.
If ARG is non-nil or a prefix arg is used then remove marks.
EXPR can be any elisp form to be eval'ed for each article which returns non-nil for required articles.
It can utilize named filters stored in `gnus-summary-ext-saved-filters' (which should be surrounded
in parentheses, e.g: (filter)), and any of the builtin functions as described in `gnus-summary-ext-filter'.

\(fn EXPR &optional ARG)" t nil)

(register-definition-prefixes "gnus-summary-ext" '("gnus-summary-ext-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; gnus-summary-ext-autoloads.el ends here
