;;; frame-purpose-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "frame-purpose" "frame-purpose.el" (0 0 0 0))
;;; Generated autoloads from frame-purpose.el

(defvar frame-purpose-mode nil "\
Non-nil if Frame-Purpose mode is enabled.
See the `frame-purpose-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `frame-purpose-mode'.")

(custom-autoload 'frame-purpose-mode "frame-purpose" nil)

(autoload 'frame-purpose-mode "frame-purpose" "\
Toggle `frame-purpose-mode', allowing the easy creation of purpose-specific frames.
This works by overriding `buffer-list' in frames which have their
`buffer-predicate' parameter set.  If any unusual behavior is
noticed in Emacs as a result of the override, disabling this mode
should restore correct behavior.

If called interactively, enable Frame-Purpose mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(autoload 'frame-purpose-make-directory-frame "frame-purpose" "\
Make a purpose-specific frame for buffers associated with DIRECTORY.
DIRECTORY defaults to the current buffer's directory.

\(fn &optional (DIRECTORY default-directory))" t nil)

(autoload 'frame-purpose-make-mode-frame "frame-purpose" "\
Make a purpose-specific frame for buffers in major MODE.
MODE defaults to the current buffer's major mode.

\(fn &optional (MODE major-mode))" t nil)

(autoload 'frame-purpose-show-sidebar "frame-purpose" "\
Show list of purpose-specific buffers on SIDE of this frame.
When a buffer in the list is selected, the last-used window
switches to that buffer.  Makes a new buffer if necessary.  SIDE
is a symbol, one of left, right, top, or bottom.

\(fn &optional (SIDE \\='right SIDE-SET-P))" t nil)

(autoload 'frame-purpose-make-frame "frame-purpose" "\
Make a new, purpose-specific frame.
The new frame will only display buffers with the specified
attributes.

ARGS is a plist of keyword-value pairs, including:

`:modes': One or a list of major modes, matched against buffers'
major modes.

`:filenames': One or a list of regular expressions matched
 against buffers' filenames.

`:buffer-predicate': A function which takes a single argument, a
buffer, and returns non-nil when the buffer matches the frame's
purpose.  When set, `:modes' and `:filenames' must not also be
set.

`:buffer-sort-fns': A list of sorting functions which take one
argument, a list of buffers, and return the list sorted as
desired.  By default, buffers are sorted by modified status and
name.

`:sidebar': When non-nil, display a sidebar on the given side
showing buffers matching `:sidebar-buffers-fn'.  One of `top',
`bottom', `left', or `right'.

`:sidebar-buffers-fn': A function which takes no arguments and
returns a list of buffers to be displayed in the sidebar.  If
nil, `buffer-list' is used.  Using a custom function for this
when possible may substantially improve performance.

`:sidebar-update-fn': A function which updates the sidebar
buffer.  By default, `frame-purpose--update-sidebar'.  You may
override this if you know what you're doing.

`:sidebar-header': Value for `header-line-format' in the sidebar.

`:sidebar-auto-update': Whether to automatically update the
sidebar buffer whenever `buffer-list-update-hook' is called.  On
by default, but may degrade Emacs performance.

`:sidebar-update-on-buffer-switch': Whether to automatically
update the sidebar when the user selects a buffer from the
sidebar.  Disabled by default.  If `:sidebar-auto-update' is
non-nil, this should remain nil.

`:require-mode': If nil, don't require `frame-purpose-mode' to be
activated before making the frame.  By default, this option is
non-nil.  Note that if the mode is disabled, the `buffer-list'
function will not be overridden, so commands in the frame that
call `buffer-list' will act on all buffers, not just ones related
to the frame's purpose.  It may be useful to disable this
requirement when customizing the sidebar options, because
overriding `buffer-list' can sometimes have adverse effects on
Emacs.

In effect, you can have a \"light\" version of
`frame-purpose-mode' by writing your own `:sidebar-buffers-fn',
disabling `frame-purpose-mode', and updating the sidebar buffer
manually.  For example, `frame-purpose-make-frame' returns the
frame it creates, so that value can be used to write your own
code to call `frame-purpose--update-sidebar' in the frame when
appropriate (e.g. on user action, on a hook, on a network event,
on a timer, etc).

Remaining keywords are transformed to non-keyword symbols and
passed as frame parameters to `make-frame', which see.

\(fn &rest ARGS)" nil nil)

(register-definition-prefixes "frame-purpose" '("frame-purpose-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; frame-purpose-autoloads.el ends here
