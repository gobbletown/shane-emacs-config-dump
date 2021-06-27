(require 'url-cache)

;; (require 'ulr-domsurf)

;; This may save a slight amount of time
;; Barley though. It's just a large list
(memoize 'url-domsuf-parse-file)
;; (memoize-restore 'url-domsuf-parse-file)
;; (length url-domsuf-domains)

;; TODO Cache this function
;; j:url-http

;; This caching doesnt work on anything but images, I think
(setq url-cache-expire-time 900000000)
(setq url-automatic-caching t)

(setq url-debug '(all))

(never (load "/home/shane/local/emacs28/share/emacs/28.0.50/lisp/url/url.el.gz"))

;; (defun my-url-log (m)
;;   (append-to-file (concat (format-time-string "%S") m "\n") "/tmp/emacsurl.txt"))

(defun my-url-log (m))

(write-to-file "" "/tmp/emacsurl.txt")
(append-to-file "hi\n" "/tmp/emacsurl.txt")

(defun url-retrieve-synchronously (url &optional silent inhibit-cookies timeout)
  "Retrieve URL synchronously.
Return the buffer containing the data, or nil if there are no data
associated with it (the case for dired, info, or mailto URLs that need
no further processing).  URL is either a string or a parsed URL.

If SILENT is non-nil, don't do any messaging while retrieving.
If INHIBIT-COOKIES is non-nil, refuse to store cookies.  If
TIMEOUT is passed, it should be a number that says (in seconds)
how long to wait for a response before giving up."
  (url-do-setup)
  ;; (message (concat "url-retrieve-synchronously: " url))
  (my-url-log (concat "url-retrieve-synchronously: " url))

  (let (
        ;; (inhibit-quit t)
        (retrieval-done nil)
        (start-time (current-time))
        (url-asynchronous nil)
        (asynch-buffer nil)
        (timed-out nil)
        ;; (quit-flag nil)
        )
    (setq asynch-buffer
          (url-retrieve url (lambda (&rest ignored)
                              (let ((inhibit-quit t))
                                (url-debug 'retrieval "Synchronous fetching done (%S)" (current-buffer))
                                (setq retrieval-done t
                                      asynch-buffer (current-buffer))))
                        nil silent inhibit-cookies))
    (if (null asynch-buffer)
        ;; We do not need to do anything, it was a mailto or something
        ;; similar that takes processing completely outside of the URL
        ;; package.
        (progn
          ;; (message "donothing")
          nil)
      (let ((proc (get-buffer-process asynch-buffer))
            (counter 0))
        ;; If the access method was synchronous, `retrieval-done' should
        ;; hopefully already be set to t.  If it is nil, and `proc' is also
        ;; nil, it implies that the async process is not running in
        ;; asynch-buffer.  This happens e.g. for FTP files.  In such a case
        ;; url-file.el should probably set something like a `url-process'
        ;; buffer-local variable so we can find the exact process that we
        ;; should be waiting for.  In the mean time, we'll just wait for any
        ;; process output.
        (while (and (not retrieval-done)
                    ;; (not (input-pending-p))
                    (or (not timeout)
                        (not (setq timed-out
                                   (time-less-p timeout
                                                (time-since start-time))))))
          (my-url-log ".")
          (url-debug 'retrieval
                     "Spinning in url-retrieve-synchronously: %S (%S)"
                     retrieval-done asynch-buffer)
          (if (buffer-local-value 'url-redirect-buffer asynch-buffer)
              (progn
                (my-url-log "getting process")
                (setq proc (get-buffer-process
                            (setq asynch-buffer
                                  (buffer-local-value 'url-redirect-buffer
                                                      asynch-buffer)))))
            (my-url-log "other")
            (if (and proc (memq (process-status proc)
                                '(closed exit signal failed))
                     ;; Make sure another process hasn't been started.
                     (eq proc (or (get-buffer-process asynch-buffer) proc)))
                ;; FIXME: It's not clear whether url-retrieve's callback is
                ;; guaranteed to be called or not.  It seems that url-http
                ;; decides sometimes consciously not to call it, so it's not
                ;; clear that it's a bug, but even then we need to decide how
                ;; url-http can then warn us that the download has completed.
                ;; In the mean time, we use this here workaround.
                ;; XXX: The callback must always be called.  Any
                ;; exception is a bug that should be fixed, not worked
                ;; around.
                (progn
                  (my-url-log "delete-process retrieval done")
                  ;; Call delete-process so we run any sentinel now.
                  (delete-process proc)
                  (setq retrieval-done t)))
            ;; We used to use `sit-for' here, but in some cases it wouldn't
            ;; work because apparently pending keyboard input would always
            ;; interrupt it before it got a chance to handle process input.
            ;; `sleep-for' was tried but it lead to other forms of
            ;; hanging.  --Stef
            ;; (message (concat "later: " url))
            ;; (ignore-errors (discard-input))

            ;; input-pending-p is wrong quite often
            ;; That is why I can't always read like this.
            (with-local-quit
              ;; (keyboard-quit)
              (never
               (if (input-pending-p)
                   (progn
                     (setq counter (1+ counter))
                     ;; (append-to-file (concat (char-to-string (read-key)) "\n"))
                     (my-url-log (concat ">input pending" (str counter)))
                     (if (> counter 20)
                         (progn
                           (my-url-log (concat "QUIT" (str counter)))
                           (keyboard-quit))
                       ;; This discards the input
                       ;; (read-key-sequence-vector nil nil t)
                       ;; (never
                       ;;  (let ((k (read-key)))
                       ;;    (my-url-log (concat "discarding: " (char-to-string k)))))
                       ))
                 (my-url-log "input not pending"))))
            (my-url-log "next")
            (if (or
                 ;; (never
                 ;;  (while-no-input
                 ;;    (with-local-quit
                 ;;      (accept-process-output proc 1))))
                 ;; (my-log-url "accept-process-output")
                 (ignore-errors
                   (with-local-quit
                     ;; (sleep 0.5)
                     (my-log-url "accept-process-output")
                     (accept-process-output proc 1)))
                 (null proc))
                (progn
                  (my-log-url "condt"))

              (my-log-url "condnil")
              ;; accept-process-output returned nil, maybe because the process
              ;; exited (and may have been replaced with another).  If we got
              ;; a quit, just stop.
              ;; (message "deleting proces")
              (my-url-log url)
              (if (input-pending-p)
                  (progn
                    ;; (append-to-file (concat (char-to-string (read-key)) "\n"))
                    (my-url-log "<input pending")))
              (when quit-flag
                (progn
                  (my-url-log "deleting process")
                  (delete-process proc))
                (my-url-log "not deleting process"))
              (progn
                (setq proc (and (not quit-flag)
                                (get-buffer-process asynch-buffer)))
                (my-url-log "proc error")
                proc)
              ;; (setq proc (get-buffer-process asynch-buffer))
              )
            (my-url-log (concat "very late: " url))))
        (my-url-log "finishing")
        ;; On timeouts, make sure we kill any pending processes.
        ;; There may be more than one if we had a redirect.
        (when timed-out
          (my-url-log "timed out")
          (when (process-live-p proc)
            (delete-process proc))
          (when-let ((aproc (get-buffer-process asynch-buffer)))
            (when (process-live-p aproc)
              (delete-process aproc))))))
    (my-url-log "done")
    (my-url-log (buffer-to-string asynch-buffer))
    (my-url-log url)
    ;; (redraw-display)
    asynch-buffer))

(defun url-retrieve-synchronously (url &optional silent inhibit-cookies timeout)
  "Retrieve URL synchronously.
Return the buffer containing the data, or nil if there are no data
associated with it (the case for dired, info, or mailto URLs that need
no further processing).  URL is either a string or a parsed URL.

If SILENT is non-nil, don't do any messaging while retrieving.
If INHIBIT-COOKIES is non-nil, refuse to store cookies.  If
TIMEOUT is passed, it should be a number that says (in seconds)
how long to wait for a response before giving up."
  (url-do-setup)

  (let ((inhibit-quit t)
        (retrieval-done nil)
        (start-time (current-time))
        (url-asynchronous nil)
        (asynch-buffer nil)
        (timed-out nil)
        (abort-hang nil))
    (setq asynch-buffer
          (url-retrieve url (lambda (&rest ignored)
                              (url-debug 'retrieval "Synchronous fetching done (%S)" (current-buffer))
                              (setq retrieval-done t
                                    asynch-buffer (current-buffer)))
                        nil silent inhibit-cookies))
    (if (null asynch-buffer)
        ;; We do not need to do anything, it was a mailto or something
        ;; similar that takes processing completely outside of the URL
        ;; package.
        nil
      (let ((proc (get-buffer-process asynch-buffer))
            (counter 0))
        ;; If the access method was synchronous, `retrieval-done' should
        ;; hopefully already be set to t.  If it is nil, and `proc' is also
        ;; nil, it implies that the async process is not running in
        ;; asynch-buffer.  This happens e.g. for FTP files.  In such a case
        ;; url-file.el should probably set something like a `url-process'
        ;; buffer-local variable so we can find the exact process that we
        ;; should be waiting for.  In the mean time, we'll just wait for any
        ;; process output.
        (while (and (not retrieval-done)
                    (not abort-hang)
                    (or (not timeout)
                        (not (setq timed-out
                                   (time-less-p timeout
                                                (time-since start-time))))))
          (url-debug 'retrieval
                     "Spinning in url-retrieve-synchronously: %S (%S)"
                     retrieval-done asynch-buffer)
          (if (buffer-local-value 'url-redirect-buffer asynch-buffer)
              (setq proc (get-buffer-process
                          (setq asynch-buffer
                                (buffer-local-value 'url-redirect-buffer
                                                    asynch-buffer))))
            (if (and proc (memq (process-status proc)
                                '(closed exit signal failed))
                     ;; Make sure another process hasn't been started.
                     (eq proc (or (get-buffer-process asynch-buffer) proc)))
                ;; FIXME: It's not clear whether url-retrieve's callback is
                ;; guaranteed to be called or not.  It seems that url-http
                ;; decides sometimes consciously not to call it, so it's not
                ;; clear that it's a bug, but even then we need to decide how
                ;; url-http can then warn us that the download has completed.
                ;; In the mean time, we use this here workaround.
                ;; XXX: The callback must always be called.  Any
                ;; exception is a bug that should be fixed, not worked
                ;; around.
                (progn ;; Call delete-process so we run any sentinel now.
                  (delete-process proc)
                  (setq retrieval-done t)))
            ;; We used to use `sit-for' here, but in some cases it wouldn't
            ;; work because apparently pending keyboard input would always
            ;; interrupt it before it got a chance to handle process input.
            ;; `sleep-for' was tried but it lead to other forms of
            ;; hanging.  --Stef
            (if (input-pending-p)
                (progn
                  (setq counter (1+ counter))
                  (if (> counter 20)
                      (setq abort-hang t))))
            ;; accept-process-output hangs without while-no-input; input has
            ;; nowhere to go. So avoid it.
            (unless (or
                     (while-no-input
                       (with-local-quit
                         (accept-process-output proc 0.1)))
                     (null proc))
              ;; accept-process-output returned nil, maybe because the process
              ;; exited (and may have been replaced with another).  If we got
              ;; a quit, just stop.
              (when quit-flag
                (delete-process proc))
              (setq proc (and (not quit-flag)
                              (get-buffer-process asynch-buffer))))))
        ;; On timeouts, make sure we kill any pending processes.
        ;; There may be more than one if we had a redirect.
        (when timed-out
          (when (process-live-p proc)
            (delete-process proc))
          (when-let ((aproc (get-buffer-process asynch-buffer)))
            (when (process-live-p aproc)
              (delete-process aproc))))))
    asynch-buffer))


;; ev:url-cache-creation-function
(defun url-cache-create-filename-around-advice (proc &rest args)
  (message-no-echo "url-cache-create-filename called with args %S" args)
  (let ((res (apply proc args)))
    (message-no-echo "url-cache-create-filename returned %S" res)
    res))
(advice-add 'url-cache-create-filename :around #'url-cache-create-filename-around-advice)
(advice-remove 'url-cache-create-filename #'url-cache-create-filename-around-advice)


(defun url-store-in-cache-around-advice (proc &rest args)
  (message "url-store-in-cache called with args %S" args)
  (let ((res (apply proc args)))
    (message "url-store-in-cache returned %S" res)
    res))
(advice-add 'url-store-in-cache :around #'url-store-in-cache-around-advice)
(advice-remove 'url-store-in-cache #'url-store-in-cache-around-advice)

(defun url-fetch-from-cache-around-advice (proc &rest args)
  (message "url-fetch-from-cache called with args %S" args)
  (let ((res (apply proc args)))
    (message "url-fetch-from-cache returned %S" res)
    res))
(advice-add 'url-fetch-from-cache :around #'url-fetch-from-cache-around-advice)
(advice-remove 'url-fetch-from-cache #'url-fetch-from-cache-around-advice)



;; I actually dont wanna mess with this. I want to cache in eww
(never
 (defun url-http-parse-headers ()
   "Parse and handle HTTP specific headers.
Return t if and only if the current buffer is still active and
should be shown to the user."
   ;; The comments after each status code handled are taken from RFC
   ;; 2616 (HTTP/1.1)
   (url-http-mark-connection-as-free (url-host url-current-object)
				                             (url-port url-current-object)
				                             url-http-process)
   ;; Pass the https certificate on to the caller.
   (when (gnutls-available-p)
     (let ((status (gnutls-peer-status url-http-process)))
       (when (or status
		             (plist-get (car url-callback-arguments) :peer))
	       (setcar url-callback-arguments
		             (plist-put (car url-callback-arguments)
			                      :peer status)))))
   (if (or (not (boundp 'url-http-end-of-headers))
	         (not url-http-end-of-headers))
       (error "Trying to parse headers in odd buffer: %s" (buffer-name)))
   (goto-char (point-min))
   (url-http-debug "url-http-parse-headers called in (%s)" (buffer-name))
   (url-http-parse-response)
   (mail-narrow-to-head)
   ;;(narrow-to-region (point-min) url-http-end-of-headers)
   (let ((connection (mail-fetch-field "Connection")))
     ;; In HTTP 1.0, keep the connection only if there is a
     ;; "Connection: keep-alive" header.
     ;; In HTTP 1.1 (and greater), keep the connection unless there is a
     ;; "Connection: close" header
     (cond
      ((string= url-http-response-version "1.0")
       (unless (and connection
		                (string= (downcase connection) "keep-alive"))
	       (delete-process url-http-process)))
      (t
       (when (and connection
		              (string= (downcase connection) "close"))
	       (delete-process url-http-process)))))
   (let* ((buffer (current-buffer))
          (class (/ url-http-response-status 100))
          (success nil)
          ;; other status symbols: jewelry and luxury cars
          (status-symbol (cadr (assq url-http-response-status url-http-codes))))
     (url-http-debug "Parsed HTTP headers: class=%d status=%d"
                     class url-http-response-status)
     (when (url-use-cookies url-http-target-url)
       (url-http-handle-cookies))

     (pcase class
       ;; Classes of response codes
       ;;
       ;; 5xx = Server Error
       ;; 4xx = Client Error
       ;; 3xx = Redirection
       ;; 2xx = Successful
       ;; 1xx = Informational
       (1                                ; Information messages
        ;; 100 = Continue with request
        ;; 101 = Switching protocols
        ;; 102 = Processing (Added by DAV)
        (url-mark-buffer-as-dead buffer)
        (error "HTTP responses in class 1xx not supported (%d)"
               url-http-response-status))
       (2                                ; Success
        ;; 200 Ok
        ;; 201 Created
        ;; 202 Accepted
        ;; 203 Non-authoritative information
        ;; 204 No content
        ;; 205 Reset content
        ;; 206 Partial content
        ;; 207 Multi-status (Added by DAV)
        (pcase status-symbol
	        ((or 'no-content 'reset-content)
	         ;; No new data, just stay at the same document
	         (url-mark-buffer-as-dead buffer))
	        (_
	         ;; Generic success for all others.  Store in the cache, and
	         ;; mark it as successful.
	         (widen)
	         (if (and url-automatic-caching (equal url-http-method "GET"))
	             (url-store-in-cache buffer))))
        (setq success t))
       (3                                ; Redirection
        ;; 300 Multiple choices
        ;; 301 Moved permanently
        ;; 302 Found
        ;; 303 See other
        ;; 304 Not modified
        ;; 305 Use proxy
        ;; 307 Temporary redirect
        (let ((redirect-uri (or (mail-fetch-field "Location")
			                          (mail-fetch-field "URI"))))
	        (pcase status-symbol
	          ('multiple-choices ; 300
	           ;; Quoth the spec (section 10.3.1)
	           ;; -------------------------------
	           ;; The requested resource corresponds to any one of a set of
	           ;; representations, each with its own specific location and
	           ;; agent-driven negotiation information is being provided so
	           ;; that the user can select a preferred representation and
	           ;; redirect its request to that location.
	           ;; [...]
	           ;; If the server has a preferred choice of representation, it
	           ;; SHOULD include the specific URI for that representation in
	           ;; the Location field; user agents MAY use the Location field
	           ;; value for automatic redirection.
	           ;; -------------------------------
	           ;; We do not support agent-driven negotiation, so we just
	           ;; redirect to the preferred URI if one is provided.
	           nil)
            ('found              ; 302
	           ;; 302 Found was ambiguously defined in the standards, but
	           ;; it's now recommended that it's treated like 303 instead
	           ;; of 307, since that's what most servers expect.
	           (setq url-http-method "GET"
		               url-http-data nil))
            ('see-other       ; 303
	           ;; The response to the request can be found under a different
	           ;; URI and SHOULD be retrieved using a GET method on that
	           ;; resource.
	           (setq url-http-method "GET"
		               url-http-data nil))
	          ('not-modified             ; 304
	           ;; The 304 response MUST NOT contain a message-body.
	           (url-http-debug "Extracting document from cache... (%s)"
			                       (url-cache-create-filename (url-view-url t)))
	           (url-cache-extract (url-cache-create-filename (url-view-url t)))
	           (setq redirect-uri nil
		               success t))
	          ('use-proxy           ; 305
	           ;; The requested resource MUST be accessed through the
	           ;; proxy given by the Location field.  The Location field
	           ;; gives the URI of the proxy.  The recipient is expected
	           ;; to repeat this single request via the proxy.  305
	           ;; responses MUST only be generated by origin servers.
	           (error "Redirection thru a proxy server not supported: %s"
		                redirect-uri))
	          (_
	           ;; Treat everything like '300'
	           nil))
	        (when redirect-uri
	          ;; Handle relative redirect URIs.
	          (if (not (string-match url-nonrelative-link redirect-uri))
                ;; Be careful to use the real target URL, otherwise we may
                ;; compute the redirection relative to the URL of the proxy.
	              (setq redirect-uri
		                  (url-expand-file-name redirect-uri url-http-target-url)))
	          ;; Do not automatically include an authorization header in the
	          ;; redirect.  If needed it will be regenerated by the relevant
	          ;; auth scheme when the new request happens.
	          (setq url-http-extra-headers
		              (cl-remove "Authorization"
			                       url-http-extra-headers :key 'car :test 'equal))
            (let ((url-request-method url-http-method)
		              (url-request-data url-http-data)
		              (url-request-extra-headers url-http-extra-headers))
	            ;; Check existing number of redirects
	            (if (or (< url-max-redirections 0)
		                  (and (> url-max-redirections 0)
			                     (let ((events (car url-callback-arguments))
				                         (old-redirects 0))
			                       (while events
			                         (if (eq (car events) :redirect)
				                           (setq old-redirects (1+ old-redirects)))
			                         (and (setq events (cdr events))
				                            (setq events (cdr events))))
			                       (< old-redirects url-max-redirections))))
		              ;; url-max-redirections hasn't been reached, so go
		              ;; ahead and redirect.
		              (progn
		                ;; Remember that the request was redirected.
		                (setf (car url-callback-arguments)
			                    (nconc (list :redirect redirect-uri)
				                         (car url-callback-arguments)))
		                ;; Put in the current buffer a forwarding pointer to the new
		                ;; destination buffer.
		                ;; FIXME: This is a hack to fix url-retrieve-synchronously
		                ;; without changing the API.  Instead url-retrieve should
		                ;; either simply not return the "destination" buffer, or it
		                ;; should take an optional `dest-buf' argument.
		                (set (make-local-variable 'url-redirect-buffer)
			                   (url-retrieve-internal
			                    redirect-uri url-callback-function
			                    url-callback-arguments
			                    (url-silent url-current-object)
			                    (not (url-use-cookies url-current-object))))
		                (url-mark-buffer-as-dead buffer))
	              ;; We hit url-max-redirections, so issue an error and
	              ;; stop redirecting.
	              (url-http-debug "Maximum redirections reached")
	              (setf (car url-callback-arguments)
		                  (nconc (list :error (list 'error 'http-redirect-limit
					                                      redirect-uri))
			                       (car url-callback-arguments)))
	              (setq success t))))))
       (4                                ; Client error
        ;; 400 Bad Request
        ;; 401 Unauthorized
        ;; 402 Payment required
        ;; 403 Forbidden
        ;; 404 Not found
        ;; 405 Method not allowed
        ;; 406 Not acceptable
        ;; 407 Proxy authentication required
        ;; 408 Request time-out
        ;; 409 Conflict
        ;; 410 Gone
        ;; 411 Length required
        ;; 412 Precondition failed
        ;; 413 Request entity too large
        ;; 414 Request-URI too large
        ;; 415 Unsupported media type
        ;; 416 Requested range not satisfiable
        ;; 417 Expectation failed
        ;; 422 Unprocessable Entity (Added by DAV)
        ;; 423 Locked
        ;; 424 Failed Dependency
        (setq success
              (pcase status-symbol
                ('unauthorized ; 401
                 ;; The request requires user authentication.  The response
                 ;; MUST include a WWW-Authenticate header field containing a
                 ;; challenge applicable to the requested resource.  The
                 ;; client MAY repeat the request with a suitable
                 ;; Authorization header field.
                 (url-http-handle-authentication nil))
                ('payment-required       ; 402
                 ;; This code is reserved for future use
                 (url-mark-buffer-as-dead buffer)
                 (error "Somebody wants you to give them money"))
                ('forbidden     ; 403
                 ;; The server understood the request, but is refusing to
                 ;; fulfill it.  Authorization will not help and the request
                 ;; SHOULD NOT be repeated.
                 t)
                ('not-found              ; 404
                 ;; Not found
                 t)
                ('method-not-allowed     ; 405
                 ;; The method specified in the Request-Line is not allowed
                 ;; for the resource identified by the Request-URI.  The
                 ;; response MUST include an Allow header containing a list of
                 ;; valid methods for the requested resource.
                 t)
                ('not-acceptable         ; 406
                 ;; The resource identified by the request is only capable of
                 ;; generating response entities which have content
                 ;; characteristics not acceptable according to the accept
                 ;; headers sent in the request.
                 t)
                ('proxy-authentication-required ; 407
                 ;; This code is similar to 401 (Unauthorized), but indicates
                 ;; that the client must first authenticate itself with the
                 ;; proxy.  The proxy MUST return a Proxy-Authenticate header
                 ;; field containing a challenge applicable to the proxy for
                 ;; the requested resource.
                 (url-http-handle-authentication t))
                ('request-timeout        ; 408
                 ;; The client did not produce a request within the time that
                 ;; the server was prepared to wait.  The client MAY repeat
                 ;; the request without modifications at any later time.
                 t)
                ('conflict			; 409
                 ;; The request could not be completed due to a conflict with
                 ;; the current state of the resource.  This code is only
                 ;; allowed in situations where it is expected that the user
                 ;; might be able to resolve the conflict and resubmit the
                 ;; request.  The response body SHOULD include enough
                 ;; information for the user to recognize the source of the
                 ;; conflict.
                 t)
                ('gone              ; 410
                 ;; The requested resource is no longer available at the
                 ;; server and no forwarding address is known.
                 t)
                ('length-required        ; 411
                 ;; The server refuses to accept the request without a defined
                 ;; Content-Length.  The client MAY repeat the request if it
                 ;; adds a valid Content-Length header field containing the
                 ;; length of the message-body in the request message.
                 ;;
                 ;; NOTE - this will never happen because
                 ;; `url-http-create-request' automatically calculates the
                 ;; content-length.
                 t)
                ('precondition-failed		; 412
                 ;; The precondition given in one or more of the
                 ;; request-header fields evaluated to false when it was
                 ;; tested on the server.
                 t)
                ((or 'request-entity-too-large 'request-uri-too-large) ; 413 414
                 ;; The server is refusing to process a request because the
                 ;; request entity|URI is larger than the server is willing or
                 ;; able to process.
                 t)
                ('unsupported-media-type	; 415
                 ;; The server is refusing to service the request because the
                 ;; entity of the request is in a format not supported by the
                 ;; requested resource for the requested method.
                 t)
                ('requested-range-not-satisfiable ; 416
                 ;; A server SHOULD return a response with this status code if
                 ;; a request included a Range request-header field, and none
                 ;; of the range-specifier values in this field overlap the
                 ;; current extent of the selected resource, and the request
                 ;; did not include an If-Range request-header field.
                 t)
                ('expectation-failed     ; 417
                 ;; The expectation given in an Expect request-header field
                 ;; could not be met by this server, or, if the server is a
                 ;; proxy, the server has unambiguous evidence that the
                 ;; request could not be met by the next-hop server.
                 t)
                (_
                 ;; The request could not be understood by the server due to
                 ;; malformed syntax.  The client SHOULD NOT repeat the
                 ;; request without modifications.
                 t)))
        ;; Tell the callback that an error occurred, and what the
        ;; status code was.
        (when success
	        (setf (car url-callback-arguments)
	              (nconc (list :error (list 'error 'http url-http-response-status))
		                   (car url-callback-arguments)))))
       (5
        ;; 500 Internal server error
        ;; 501 Not implemented
        ;; 502 Bad gateway
        ;; 503 Service unavailable
        ;; 504 Gateway time-out
        ;; 505 HTTP version not supported
        ;; 507 Insufficient storage
        (setq success t)
        (pcase url-http-response-status
	        ('not-implemented		; 501
	         ;; The server does not support the functionality required to
	         ;; fulfill the request.
	         nil)
	        ('bad-gateway         ; 502
	         ;; The server, while acting as a gateway or proxy, received
	         ;; an invalid response from the upstream server it accessed
	         ;; in attempting to fulfill the request.
	         nil)
	        ('service-unavailable ; 503
	         ;; The server is currently unable to handle the request due
	         ;; to a temporary overloading or maintenance of the server.
	         ;; The implication is that this is a temporary condition
	         ;; which will be alleviated after some delay.  If known, the
	         ;; length of the delay MAY be indicated in a Retry-After
	         ;; header.  If no Retry-After is given, the client SHOULD
	         ;; handle the response as it would for a 500 response.
	         nil)
	        ('gateway-timeout		; 504
	         ;; The server, while acting as a gateway or proxy, did not
	         ;; receive a timely response from the upstream server
	         ;; specified by the URI (e.g. HTTP, FTP, LDAP) or some other
	         ;; auxiliary server (e.g. DNS) it needed to access in
	         ;; attempting to complete the request.
	         nil)
	        ('http-version-not-supported   ; 505
	         ;; The server does not support, or refuses to support, the
	         ;; HTTP protocol version that was used in the request
	         ;; message.
	         nil)
	        ('insufficient-storage       ; 507 (DAV)
	         ;; The method could not be performed on the resource
	         ;; because the server is unable to store the representation
	         ;; needed to successfully complete the request.  This
	         ;; condition is considered to be temporary.  If the request
	         ;; which received this status code was the result of a user
	         ;; action, the request MUST NOT be repeated until it is
	         ;; requested by a separate user action.
	         nil))
        ;; Tell the callback that an error occurred, and what the
        ;; status code was.
        (when success
	        (setf (car url-callback-arguments)
	              (nconc (list :error (list 'error 'http url-http-response-status))
		                   (car url-callback-arguments)))))
       (_
        (error "Unknown class of HTTP response code: %d (%d)"
	             class url-http-response-status)))
     (if (not success)
	       (url-mark-buffer-as-dead buffer)
       ;; Narrow the buffer for url-handle-content-transfer-encoding to
       ;; find only the headers relevant to this transaction.
       (and (not (buffer-narrowed-p))
            (mail-narrow-to-head))
       (url-handle-content-transfer-encoding))
     (url-http-debug "Finished parsing HTTP headers: %S" success)
     (widen)
     (goto-char (point-min))
     success)))



;; This is where I want to cache
(defun url-retrieve-internal (url callback cbargs &optional silent
                                  inhibit-cookies)
  "Internal function; external interface is `url-retrieve'.
The callback function will receive an updated value of CBARGS as
arguments; its first element should be a plist specifying what has
happened so far during the request, as described in the docstring
of `url-retrieve' (if in doubt, specify nil).

If SILENT, don't message progress reports and the like.
If INHIBIT-COOKIES, cookies will neither be stored nor sent to
the server.
If URL is a multibyte string, it will be encoded as utf-8 and
URL-encoded before it's used."
  (url-do-setup)
  (url-gc-dead-buffers)
  (when (stringp url)
    (set-text-properties 0 (length url) nil url)
    (setq url (url-encode-url url)))
  (if (not (url-p url))
      (setq url (url-generic-parse-url url)))
  (if (not (functionp callback))
      (error "Must provide a callback function to url-retrieve"))
  (unless (url-type url)
    (error "Bad url: %s" (url-recreate-url url)))
  (setf (url-silent url) silent)
  (setf (url-asynchronous url) url-asynchronous)
  (setf (url-use-cookies url) (not inhibit-cookies))
  ;; Once in a while, remove old entries from the URL cache.
  (when (zerop (% url-retrieve-number-of-calls 1000))
    (condition-case error
        (url-cache-prune-cache)
      (file-error
       (message "Error when expiring the cache: %s" error))))
  (setq url-retrieve-number-of-calls (1+ url-retrieve-number-of-calls))
  (let ((loader (url-scheme-get-property (url-type url) 'loader))
        (url-using-proxy (if (url-host url)
                             (url-find-proxy-for-url url (url-host url))))
        (buffer nil)
        (asynch (url-scheme-get-property (url-type url) 'asynchronous-p)))
    (if url-using-proxy
        (setq asynch t
              loader 'url-proxy))
    ;; (message-no-echo (concat "url using " (str loader) " for " (pps url)))
    (if asynch
        (let ((url-current-object url))
          (setq buffer (funcall loader url callback cbargs)))
      (setq buffer (funcall loader url))
      (if buffer
          (with-current-buffer buffer
            (apply callback cbargs))))
    (if url-history-track
        (url-history-update-url url (current-time)))
    buffer))


;; DISCARD Modify this function to cache. It's an async function
;; Even this function defers to some other function. Except there is now state hell
;; j:url-http
;; Therefore, the best way to cache is probably a hacky method
;; Why am I even doing this asynchronously? There is no point in doing it asynchronously.


;; This still doesn't cache FML
(never
 (defun url-http-create-request ()
   "Create an HTTP request for `url-http-target-url'.
Use `url-http-referer' as the Referer-header (subject to `url-privacy-level')."
   (let* ((extra-headers)
          (request nil)
          (no-cache nil
                    ;; (cdr-safe (assoc "Pragma" url-http-extra-headers))
                    )
          (using-proxy url-http-proxy)
          (proxy-auth (if (or (cdr-safe (assoc "Proxy-Authorization"
                                               url-http-extra-headers))
                              (not using-proxy))
                          nil
                        (let ((url-basic-auth-storage
                               'url-http-proxy-basic-auth-storage))
                          (url-get-authentication url-http-proxy nil 'any nil))))
          (real-fname (url-filename url-http-target-url))
          (host (url-host url-http-target-url))
          (auth (if (cdr-safe (assoc "Authorization" url-http-extra-headers))
                    nil
                  (url-get-authentication (or
                                           (and (boundp 'proxy-info)
                                                proxy-info)
                                           url-http-target-url) nil 'any nil)))
          (ref-url (url-http--encode-string url-http-referer)))
     (if (equal "" real-fname)
         (setq real-fname "/"))
     (setq no-cache (and no-cache (string-match "no-cache" no-cache)))
     (if auth
         (setq auth (concat "Authorization: " auth "\r\n")))
     (if proxy-auth
         (setq proxy-auth (concat "Proxy-Authorization: " proxy-auth "\r\n")))

     ;; Protection against stupid values in the referrer
     (if (and ref-url (stringp ref-url) (or (string= ref-url "file:nil")
                                            (string= ref-url "")))
         (setq ref-url nil))

     ;; url-http-extra-headers contains an assoc-list of
     ;; header/value pairs that we need to put into the request.
     (setq extra-headers (mapconcat
                          (lambda (x)
                            (concat (car x) ": " (cdr x)))
                          url-http-extra-headers "\r\n"))
     (if (not (equal extra-headers ""))
         (setq extra-headers (concat extra-headers "\r\n")))

     ;; This was done with a call to `format'.  Concatenating parts has
     ;; the advantage of keeping the parts of each header together and
     ;; allows us to elide null lines directly, at the cost of making
     ;; the layout less clear.
     (setq request
           (concat
            ;; The request
            (or url-http-method "GET") " "
            (url-http--encode-string
             (if (and using-proxy
                      ;; Bug#35969.
                      (not (equal "https" (url-type url-http-target-url))))
                 (url-recreate-url url-http-target-url) real-fname))
            " HTTP/" url-http-version "\r\n"
            ;; Version of MIME we speak
            "MIME-Version: 1.0\r\n"
            ;; (maybe) Try to keep the connection open
            "Connection: " (if (or using-proxy
                                   (not url-http-attempt-keepalives))
                               "close" "keep-alive") "\r\n"
                               ;; HTTP extensions we support
            (if url-extensions-header
                (format
                 "Extension: %s\r\n" url-extensions-header))
            ;; Who we want to talk to
            (if (/= (url-port url-http-target-url)
                    (url-scheme-get-property
                     (url-type url-http-target-url) 'default-port))
                (format
                 "Host: %s:%d\r\n" (url-http--encode-string
                                    (puny-encode-domain host))
                 (url-port url-http-target-url))
              (format "Host: %s\r\n"
                      (url-http--encode-string (puny-encode-domain host))))
            ;; Who its from
            (if url-personal-mail-address
                (concat
                 "From: " url-personal-mail-address "\r\n"))
            ;; Encodings we understand
            (if (or url-mime-encoding-string
                    ;; MS-Windows loads zlib dynamically, so recheck
                    ;; in case they made it available since
                    ;; initialization in url-vars.el.
                    (and (eq 'system-type 'windows-nt)
                         (fboundp 'zlib-available-p)
                         (zlib-available-p)
                         (setq url-mime-encoding-string "gzip")))
                (concat
                 "Accept-encoding: " url-mime-encoding-string "\r\n"))
            (if url-mime-charset-string
                (concat
                 "Accept-charset: "
                 (url-http--encode-string url-mime-charset-string)
                 "\r\n"))
            ;; Languages we understand
            (if url-mime-language-string
                (concat
                 "Accept-language: " url-mime-language-string "\r\n"))
            ;; Types we understand
            "Accept: " (or url-mime-accept-string "*/*") "\r\n"
            ;; User agent
            (url-http-user-agent-string)
            ;; Proxy Authorization
            proxy-auth
            ;; Authorization
            auth
            ;; Cookies
            (when (url-use-cookies url-http-target-url)
              (url-http--encode-string
               (url-cookie-generate-header-lines
                host real-fname
                (equal "https" (url-type url-http-target-url)))))
            ;; If-modified-since
            (if (and (not no-cache)
                     (member url-http-method '("GET" nil)))
                (let ((tm (url-is-cached url-http-target-url)))
                  (if tm
                      (concat "If-modified-since: "
                              (url-get-normalized-date tm) "\r\n"))))
            ;; Whence we came
            (if ref-url (concat
                         "Referer: " ref-url "\r\n"))
            extra-headers
            ;; Length of data
            (if url-http-data
                (concat
                 "Content-length: " (number-to-string
                                     (length url-http-data))
                 "\r\n"))
            ;; End request
            "\r\n"
            ;; Any data
            url-http-data))
     ;; Bug#23750
     (unless (= (string-bytes request)
                (length request))
       (error "Multibyte text in HTTP request: %s" request))
     (url-http-debug "Request is: \n%s" request)
     request)))

(provide 'my-url)