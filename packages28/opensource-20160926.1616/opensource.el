;;; opensource.el --- Client for Opensource API

;; Author: Nicolas Lamirault <nicolas.lamirault@gmail.com>
;; URL: https://github.com/OpenSourceOrg/el-opensourceorg
;; Version: 0.2.0
;; Keywords: opensource

;; Package-Requires: ((s "1.11.0") (dash "2.12.1") (pkg-info "0.6.0") (request "0.2.0"))

;; Copyright (C) 2016 Nicolas Lamirault <nicolas.lamirault@gmail.com>

;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at

;;     http://www.apache.org/licenses/LICENSE-2.0

;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.

;;; Commentary:

;; Provides an Opensource API client.

;;; Installation:

;; opensource is available on the two major community maintained repositories -                                                                                                     
;; Melpa stable (https://stable.melpa.org), and Melpa (https://melpa.org)

;; (add-to-list 'package-archives
;;              '("melpa" . "https://melpa.org/packages/") t)
;;
;; M-x package-install opensource

;;; Usage:



;;; Code:

(require 's)

;; Customization

(defgroup opensource nil
  "Opensource API client."
  :group 'applications
  :link '(url-link :tag "Github" "https://github.com/OpenSourceOrg/el-opensourceorg")
  :link '(emacs-commentary-link :tag "Commentary" "opensource API client"))

;; The library

(require 'opensource-version)
(require 'opensource-api)
(require 'opensource-http)
(require 'opensource-utils)
(require 'opensource-licenses)

(provide 'opensource)
;;; opensource.el ends here
