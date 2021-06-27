(defun buffer-binary-p (&optional buffer)
  "Return whether BUFFER or the current buffer is binary.

A binary buffer is defined as containing at least on null byte.

Returns either nil, or the position of the first null byte."
  (with-current-buffer (or buffer (current-buffer))
    (save-excursion
      (goto-char (point-min))
      (search-forward (string ?\x00) nil t 1))))

(defun hexl-if-binary ()
  "If `hexl-mode' is not already active, and the current buffer
is binary, activate `hexl-mode'."
  (interactive)
  (unless (eq major-mode 'hexl-mode)
    ;; (when (buffer-binary-p)
    ;;   (hexl-mode))
    ))

(add-hook 'find-file-hooks 'hexl-if-binary)



;; This is modified with
;; ;; (hexl-mode--setq-local '(current-local-map . use-local-map) hexl-mode-map)
;; Commented out so my-mode is not disabled.
(defun hexl-mode (&optional arg)
  "\\<hexl-mode-map>A mode for editing binary files in hex dump format.
This is not an ordinary major mode; it alters some aspects
of the current mode's behavior, but not all; also, you can exit
Hexl mode and return to the previous mode using `hexl-mode-exit'.

This function automatically converts a buffer into the hexl format
using the function `hexlify-buffer'.

Each line in the buffer has an \"address\" (displayed in hexadecimal)
representing the offset into the file that the characters on this line
are at and 16 characters from the file (displayed as hexadecimal
values grouped every `hexl-bits' bits, and as their ASCII values).

If any of the characters (displayed as ASCII characters) are
unprintable (control or meta characters) they will be replaced by
periods.

If `hexl-mode' is invoked with an argument the buffer is assumed to be
in hexl format.

A sample format:

  HEX ADDR: 0011 2233 4455 6677 8899 aabb ccdd eeff     ASCII-TEXT
  --------  ---- ---- ---- ---- ---- ---- ---- ----  ----------------
  00000000: 5468 6973 2069 7320 6865 786c 2d6d 6f64  This is hexl-mod
  00000010: 652e 2020 4561 6368 206c 696e 6520 7265  e.  Each line re
  00000020: 7072 6573 656e 7473 2031 3620 6279 7465  presents 16 byte
  00000030: 7320 6173 2068 6578 6164 6563 696d 616c  s as hexadecimal
  00000040: 2041 5343 4949 0a61 6e64 2070 7269 6e74   ASCII.and print
  00000050: 6162 6c65 2041 5343 4949 2063 6861 7261  able ASCII chara
  00000060: 6374 6572 732e 2020 416e 7920 636f 6e74  cters.  Any cont
  00000070: 726f 6c20 6f72 206e 6f6e 2d41 5343 4949  rol or non-ASCII
  00000080: 2063 6861 7261 6374 6572 730a 6172 6520   characters.are
  00000090: 6469 7370 6c61 7965 6420 6173 2070 6572  displayed as per
  000000a0: 696f 6473 2069 6e20 7468 6520 7072 696e  iods in the prin
  000000b0: 7461 626c 6520 6368 6172 6163 7465 7220  table character
  000000c0: 7265 6769 6f6e 2e0a                      region..

Movement is as simple as movement in a normal Emacs text buffer.
Most cursor movement bindings are the same: use \\[hexl-backward-char], \\[hexl-forward-char], \\[hexl-next-line], and \\[hexl-previous-line]
to move the cursor left, right, down, and up.

Advanced cursor movement commands (ala \\[hexl-beginning-of-line], \\[hexl-end-of-line], \\[hexl-beginning-of-buffer], and \\[hexl-end-of-buffer]) are
also supported.

There are several ways to change text in hexl mode:

ASCII characters (character between space (0x20) and tilde (0x7E)) are
bound to self-insert so you can simply type the character and it will
insert itself (actually overstrike) into the buffer.

\\[hexl-quoted-insert] followed by another keystroke allows you to insert the key even if
it isn't bound to self-insert.  An octal number can be supplied in place
of another key to insert the octal number's ASCII representation.

\\[hexl-insert-hex-char] will insert a given hexadecimal value (if it is between 0 and 0xFF)
into the buffer at the current point.

\\[hexl-insert-octal-char] will insert a given octal value (if it is between 0 and 0377)
into the buffer at the current point.

\\[hexl-insert-decimal-char] will insert a given decimal value (if it is between 0 and 255)
into the buffer at the current point.

\\[hexl-mode-exit] will exit `hexl-mode'.

Note: saving the file with any of the usual Emacs commands
will actually convert it back to binary format while saving.

You can use \\[hexl-find-file] to visit a file in Hexl mode.

\\[describe-bindings] for advanced commands."
  (interactive "p")
  (unless (eq major-mode 'hexl-mode)
    (let ((modified (buffer-modified-p))
	        (inhibit-read-only t)
	        (original-point (- (point) (point-min))))
      (and (eobp) (not (bobp))
	         (setq original-point (1- original-point)))
      ;; If `hexl-mode' is invoked with an argument the buffer is assumed to
      ;; be in hexl format.
      (when (memq arg '(1 nil))
        ;; If the buffer's EOL type is -dos, we need to account for
        ;; extra CR characters added when hexlify-buffer writes the
        ;; buffer to a file.
        ;; FIXME: This doesn't take into account multibyte coding systems.
	      (when (eq (coding-system-eol-type buffer-file-coding-system) 1)
          (setq original-point (+ (count-lines (point-min) (point))
                                  original-point))
          (or (bolp) (setq original-point (1- original-point))))
        (hexlify-buffer)
        (restore-buffer-modified-p modified))
      (set (make-local-variable 'hexl-max-address)
           (+ (* (/ (1- (buffer-size)) (hexl-line-displen)) 16) 15))
      (condition-case nil
	        (hexl-goto-address original-point)
        (error nil)))

    ;; We do not turn off the old major mode; instead we just
    ;; override most of it.  That way, we can restore it perfectly.

    ;; (hexl-mode--setq-local '(current-local-map . use-local-map) hexl-mode-map)

    (hexl-mode--setq-local 'mode-name "Hexl")
    (hexl-mode--setq-local 'isearch-search-fun-function
                           'hexl-isearch-search-function)
    (hexl-mode--setq-local 'major-mode 'hexl-mode)

    (hexl-mode--setq-local '(syntax-table . set-syntax-table)
                           (standard-syntax-table))

    (add-hook 'write-contents-functions 'hexl-save-buffer nil t)

    (hexl-mode--setq-local 'require-final-newline nil)


    (hexl-mode--setq-local 'font-lock-defaults '(hexl-font-lock-keywords t))

    (hexl-mode--setq-local 'revert-buffer-function
                           #'hexl-revert-buffer-function)
    (add-hook 'change-major-mode-hook 'hexl-maybe-dehexlify-buffer nil t)

    ;; Set a callback function for eldoc.
    (add-function :before-until (local 'eldoc-documentation-function)
                  #'hexl-print-current-point-info)
    (eldoc-add-command-completions "hexl-")
    (eldoc-remove-command "hexl-save-buffer"
			                    "hexl-current-address")

    (if hexl-follow-ascii (hexl-follow-ascii 1)))
  (run-mode-hooks 'hexl-mode-hook))




(provide 'my-hexl)