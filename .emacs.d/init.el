(server-mode)
;;(add-to-list 'load-path "~/.emacs.d/lisp")

(setq straight-use-package-by-default t)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

(use-package better-defaults)
(use-package smex)
(use-package pdf-tools)
(use-package auctex
  :defer t
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil))
(use-package transpose-frame)
(use-package smooth-scrolling)
(use-package frames-only-mode)
(use-package nix-mode)
(use-package haskell-mode)
(use-package sudo-edit)
(use-package base16-theme)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-view-program-selection
   (quote
    (((output-dvi has-no-display-manager)
      "dvi2tty")
     ((output-dvi style-pstricks)
      "dvips and gv")
     (output-dvi "xdvi")
     (output-pdf "PDF Tools")
     (output-html "xdg-open"))))
 '(custom-safe-themes
   (quote
    ("527df6ab42b54d2e5f4eec8b091bd79b2fa9a1da38f5addd297d1c91aa19b616" default)))
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(load-theme 'base16-nord)
(global-display-line-numbers-mode 1)
(smooth-scrolling-mode t)
(auto-fill-mode t)
(setq display-line-numbers-type 'relative)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;;old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; TODO: use advice/some other method?
;; Treat [] as an indentation level in TeX mode
(defun TeX-brace-count-line ()
  "Count number of open/closed braces."
  (save-excursion
    (let ((count 0) (limit (line-end-position)) char)
      (while (progn
               (skip-chars-forward "^{}[]\\\\" limit)
               (when (and (< (point) limit) (not (TeX-in-comment)))
                 (setq char (char-after))
                 (forward-char)
                 (cond ((eq char ?\{)
                        (setq count (+ count TeX-brace-indent-level)))
                       ((eq char ?\})
                        (setq count (- count TeX-brace-indent-level)))
                       ((eq char ?\[)
                        (setq count (+ count TeX-brace-indent-level)))
                       ((eq char ?\])
                        (setq count (- count TeX-brace-indent-level)))
                       ((eq char ?\\)
                        (when (< (point) limit)
                          (forward-char)
                          t))))))
      count)))

;; TODO: maybe remove this?
(defadvice smex (around space-inserts-hyphen activate compile)
  (let ((ido-cannot-complete-command 
         `(lambda ()
            (interactive)
            (if (string= " " (this-command-keys))
                (insert ?-)
              (funcall ,ido-cannot-complete-command)))))
    ad-do-it))