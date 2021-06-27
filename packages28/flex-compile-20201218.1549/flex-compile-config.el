;;; flex-compile-config.el --- Configuration based compiler for flex-compile  -*- lexical-binding: t; -*-

;; Copyright (C) 2015 - 2020 Paul Landes

;; Author: Paul Landes
;; Maintainer: Paul Landes
;; Keywords: compilation integration processes
;; URL: https://github.com/plandes/flex-compile
;; Package-Requires: ((emacs "26.1"))
;; Package-Version: 0

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; This file contains an abstract compiler that provides configuration
;; functionality (minibuffer and persistance to the configuraiton file) and
;; basic meta data properties for configuration.

;;; Code:

(require 'dash)
(require 'eieio)
(require 'choice-program-complete)
(require 'config-manage-prop)
(require 'flex-compile-base)

(defclass conf-flex-compiler (flex-compiler)
  ()
  :abstract true
  :method-invocation-order :c3
  :documentation "A property based configurable compiler.
All properties are added in each sub class's `initialize-instance' method as
the :props plist argument in SLOTS.

Important: Extend from this class _last_ so that it captures all proprties
since this class sets :pslots in the `config-persistent' subclass.")

(cl-defmethod flex-compile-clear ((this conf-flex-compiler))
  "Wipe all values for THIS compiler."
  (dolist (prop (config-prop-by-order this))
    (config-prop-set this prop nil))
  (dolist (prop (config-prop-by-order this))
    (flex-compile-clear prop))
  (message "Cleared %s configuration" (config-entry-name this)))


;; configuration based compiler
(defclass conf-file-flex-compiler (conf-flex-compiler)
  ((config-file :initarg :config-file
		:initform nil
		:type (or null string)
		:documentation "\
The file to use for *configuring* the compiler.")
   (start-directory :initarg :start-directory
		    :initform nil
		    :type (or null string)
		    :documentation "\
The directory for starting the compilation.  The `default-directory' is set to
this when the compile starts"))
  :abstract true
  :method-invocation-order :c3
  :documentation "A configurable compiler with a configuration file.

All subclass compilers have a confiugration file slot that determines what file
is compiled, evaluated etc.  When this slot is set, the `start-directory' slot,
which is used as the `default-directory', is unset.")

(cl-defmethod initialize-instance ((this conf-file-flex-compiler)
				   &optional slots)
  "Initialize instance THIS with arguments SLOTS."
  (let* ((modes (plist-get slots :validate-modes))
	 (desc (plist-get slots :description))
	 (name (plist-get slots :object-name))
	 (prompt (format "%s file" (or desc (capitalize name))))
	 (props (list (config-directory-prop :object-name 'start-directory
					     :prop-entry this
					     :prompt "Start directory"
					     :input-type 'last)
		      (config-file-prop :object-name 'config-file
					:prompt prompt
					:prop-entry this
					:validate-modes modes
					:input-type 'last
					:required t
					:order 0))))
    (setq slots (plist-put slots :props
			   (append (plist-get slots :props) props))))
  (cl-remf slots :validate-modes)
  (cl-call-next-method this slots))

(cl-defmethod eieio-object-name-string ((this conf-file-flex-compiler))
  "Return a string as a representation of the in memory instance of THIS."
  (->> (format " config-file=%s" (slot-value this 'config-file))
       (concat (cl-call-next-method this))))

(cl-defmethod config-prop-entry-configure ((this conf-file-flex-compiler)
					   config-options)
  "Configure the prop-entry of THIS instance with CONFIG-OPTIONS.

See `config-manage-prop' class's method documentation."
  (if (eq config-options 'immediate)
      (setq config-options (list 'prop-name 'config-file (buffer-file-name))))
  (cl-call-next-method this config-options))

(cl-defmethod config-prop-set ((this conf-file-flex-compiler) prop val)
  "Set property PROP to VAL on THIS compiler."
  (if (eq (config-prop-name prop) 'config-file)
      (with-slots (start-directory) this
	(config-prop-validate prop val)
	(setq start-directory (file-name-directory val))))
  (cl-call-next-method this prop val))

(cl-defmethod flex-compiler-conf-file-buffer ((this conf-file-flex-compiler))
  "Return a new buffer of the configuration file for THIS compiler."
  (config-prop-entry-set-required this)
  (find-file-noselect (slot-value this 'config-file)))

(cl-defmethod flex-compiler-conf-file-display ((this conf-file-flex-compiler))
  "Pop THIS compilers' configuration file buffer to the current buffer/window."
  (pop-to-buffer (flex-compiler-conf-file-buffer this)))


(provide 'flex-compile-config)

;;; flex-compile-config.el ends here
