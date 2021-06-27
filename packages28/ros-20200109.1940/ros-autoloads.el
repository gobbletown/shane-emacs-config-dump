;;; ros-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "ros" "ros.el" (0 0 0 0))
;;; Generated autoloads from ros.el

(autoload 'ros-select-workspace "ros" "\
Select current ROS workspace.
Set the variable `ros-current-workspace' to WORKSPACE
and the variable `ros-current-profile' to PROFILE.
If called interactively prompt for WORKSPACE and PROFILE.

\(fn WORKSPACE &optional PROFILE)" t nil)

(autoload 'ros-select-profile "ros" "\
Set the variable `ros-current-profile' to PROFILE.  If called interactively prompt for PROFILE.

\(fn PROFILE)" t nil)

(autoload 'ros-catkin-build-workspace "ros" "\
Build the WORKSPACE with PROFILE or default if not provided.
If called interactively prompt for WORKSPACE and PROFILE.

\(fn WORKSPACE &optional PROFILE)" t nil)

(autoload 'ros-catkin-build-current-workspace "ros" "\
Build the workspace with profile specified in the variables `ros-current-workspace' and `ros-current-profile'." t nil)

(autoload 'ros-catkin-build-package "ros" "\
Build the ROS package PACKAGE.
The packages will be built in the workspace specified
in the variable `ros-current-workspace' and with the profile
specified in the variable`ros-current-profile'.

\(fn PACKAGE)" t nil)

(autoload 'ros-catkin-build-current-package "ros" "\
If the current buffer is part of a ROS package in the workspace specified by the variable `ros-current-workspace', build it." t nil)

(autoload 'ros-catkin-clean-workspace "ros" "\
Run `catkin clean' in WORKSPACE with optional PROFILE.

\(fn WORKSPACE &optional PROFILE)" t nil)

(autoload 'ros-catkin-clean-current-workspace "ros" "\
Run `catkin clean' in workspace with profile specified in the variables `ros-current-workspace' and `ros-current-profile'." t nil)

(autoload 'ros-catkin-clean-package "ros" "\
Clean the ROS PACKAGE.

\(fn PACKAGE)" t nil)

(autoload 'ros-catkin-clean-current-package "ros" "\
If the current buffer is part of a ROS package in the workspace specified by  in the variable `ros-current-workspace', clean it." t nil)

(autoload 'ros-catkin-test-package "ros" "\
Build and run all unittests in PACKAGE.

\(fn PACKAGE)" t nil)

(autoload 'ros-catkin-test-current-package "ros" "\
Build and run all unittests in the package the current buffer lies in." t nil)

(autoload 'ros-catkin-test-workspace "ros" "\
Build and run all unittests in WORKSPACE with profile PROFILE.

\(fn WORKSPACE &optional PROFILE)" t nil)

(autoload 'ros-catkin-test-current-workspace "ros" "\
Build and run all unittests in the current workspace.
The workspace and the profile are specified in the variables
`ros-current-workspace' and `ros-current-profile'." t nil)

(autoload 'ros-catkin-test-file-in-package "ros" "\
Build and run all unittests of a prompted file in PACKAGE.

\(fn PACKAGE)" t nil)

(autoload 'ros-catkin-test-file-in-current-package "ros" "\
Prompt for test file in current package and build and run this test file." t nil)

(autoload 'ros-catkin-test-current-test-file "ros" "\
Build and run the test file in the current buffer." t nil)

(autoload 'ros-catkin-test-at-point "ros" "\
If current file is a gtest test file, build and run the test at point." t nil)

(autoload 'ros-msg-show "ros" "\
Prompt for MSG and show structure.

\(fn MSG)" t nil)

(autoload 'ros-topic-show "ros" "\
Prompt for TOPIC and show subscribers and publishers.

\(fn TOPIC)" t nil)

(autoload 'ros-topic-show-filtered "ros" "\
Prompt for TOPIC filtered by type and show subscribers and publishers.

\(fn TOPIC)" t nil)

(autoload 'ros-service-show "ros" "\
Prompt for active SERVICE and show structure.

\(fn SERVICE)" t nil)

(autoload 'ros-srv-show "ros" "\
Prompt for (not necessarily active) SERVICE and show structure.

\(fn SERVICE)" t nil)

(autoload 'ros-node-show "ros" "\
Prompt for NODE and show published and subscribed topics and provided services.

\(fn NODE)" t nil)

(autoload 'ros-show-thing-at-point "ros" "\
Get thing at point and try to describe it." t nil)

(autoload 'ros-echo-topic-at-point "ros" "\
Get thing at point and if it is a topic echo it." t nil)

(autoload 'ros-call-service-at-point "ros" "\
Get thing at point and if it is a service call it." t nil)

(autoload 'ros-kill-node-at-point "ros" "\
Get thing at point and if it is a node kill it." t nil)

(autoload 'ros-topic-echo "ros" "\
Prompt for TOPIC and echo it.

\(fn TOPIC)" t nil)

(autoload 'ros-topic-echo-filtered "ros" "\
Prompt for TOPIC filtered by type and echo it.

\(fn TOPIC)" t nil)

(autoload 'ros-topic-pub-buffer "ros" "\
Publish the mesage defined in the buffer, if ARG is nil publish the message one, otherwise ARG is the rate of the publishing.

\(fn ARG)" t nil)

(autoload 'ros-topic-pub "ros" "\
Draft ros message to be published on TOPIC.

\(fn TOPIC)" t nil)

(autoload 'ros-topic-pub-filtered "ros" "\
Draft ros message to be published on TOPIC which is filtered by type.

\(fn TOPIC)" t nil)

(autoload 'ros-service-call "ros" "\
Draft a service call to be called on TOPIC.

\(fn TOPIC)" t nil)

(autoload 'ros-service-call-buffer "ros" "\
Call the service specified in the buffer." t nil)

(autoload 'ros-insert-import-msg "ros" "\
Prompt for MESSAGE and include it in file.

\(fn MESSAGE)" t nil)

(autoload 'ros-insert-import-srv "ros" "\
Prompt for SERVICE and include it in file.

\(fn SERVICE)" t nil)

(autoload 'ros-insert-msg "ros" "\
Insert  definition for msg NAME in the current buffer.

\(fn NAME)" t nil)

(autoload 'ros-insert-srv "ros" "\
Insert  definition for srv NAME in the current buffer.

\(fn NAME)" t nil)

(autoload 'ros-insert-topic "ros" "\
Prompt for TOPIC and insert it at point.

\(fn TOPIC)" t nil)

(autoload 'ros-insert-topic-filtered "ros" "\
Prompt for TOPIC filtered by type and insert it at point.

\(fn TOPIC)" t nil)

(autoload 'ros-dired-package "ros" "\
Open the root of PACKAGE in dired.

\(fn PACKAGE)" t nil)

(autoload 'ros-logger-set-level "ros" "\
Prompt for NODE and LOGGER and set the logger level." t nil)

(autoload 'ros-param-set "ros" "\
Prompt for PARAMETER and set it to a new value.

\(fn PARAMETER)" t nil)

(autoload 'ros-dynamic-reconfigure-set-param "ros" "\
Dynamically reconfigure a parametern in NODE.

\(fn NODE)" t nil)

(autoload 'ros-env-set-ros-master "ros" "\
Prompt for NEW-MASTER to set the variable `ros-env-ros-master'.

\(fn NEW-MASTER)" t nil)

(autoload 'ros-env-select-network-interface "ros" "\
Prompt for INTERFACE to set the variable `ros-env-network-interface'.

\(fn INTERFACE)" t nil)

(autoload 'ros-env-select-host-directory "ros" "\
Prompt for DIRECTORY and set it to host directory.

\(fn DIRECTORY)" t nil)

(register-definition-prefixes "ros" '("hydra-ros-" "ros-"))

;;;***

;;;### (autoloads nil nil ("ros-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; ros-autoloads.el ends here
