;; TODO Make an ssh into box script

(require 'aws-ec2)

(defun aws-ssh-into-box (id)
  (interactive (list (tabulated-list-get-id)))

  (if (major-mode-p 'aws-instances-mode)
      (sps (concat "aws-ssh-into-box " id))))

(defun aws-show-user-data (id)
  (interactive (list (tabulated-list-get-id)))

  (if (major-mode-p 'aws-instances-mode)
      ;; https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html
      (with-current-buffer
                  (nbfs
                   (snc (concat
                 "aws ec2 describe-instance-attribute --instance-id "
                 id
                 " --attribute userData --output text --query \"UserData.Value\" | base64 --decode")))
        (detect-language-set-mode))
    ;; (sps (concat "aws-ssh-into-box " id))
    ))

(define-key aws-instances-mode-map (kbd ";") 'aws-ssh-into-box)
(define-key aws-instances-mode-map (kbd "D") 'aws-show-user-data)

(provide 'my-aws)