(add-to-list 'load-path "~/.emacs.d/")
(server-start)

;; C-x k to close emacsclient session (instead of C-x #)
(add-hook 'server-switch-hook
	  (lambda ()
	    (when (current-local-map)
	      (use-local-map (copy-keymap (current-local-map))))
	    (when server-buffer-clients
	      (local-set-key (kbd "C-x k") 'server-edit))))

 ;; Make shifted direction keys work on the Linux console or in an xterm
;;(when (member (getenv "TERM") '("linux" "xterm"))
;;  (dolist (prefix '("\eO" "\eO1;" "\e[1;"))
;;    (dolist (m '(("2" . "S-") ("3" . "M-") ("4" . "S-M-") ("5" . "C-")
;;		 ("6" . "S-C-") ("7" . "C-M-") ("8" . "S-C-M-")))
;;      (dolist (k '(("A" . "<up>") ("B" . "<down>") ("C" . "<right>")
;;		   ("D" . "<left>") ("H" . "<home>") ("F" . "<end>")))
;;	(define-key function-key-map
;;	  (concat prefix (car m) (car k))
;;	  (read-kbd-macro (concat (cdr m) (cdr k))))))))


;;(require 'color-theme)
;;(color-theme-initialize)
;;(color-theme-hober)

(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-hober)))

(xterm-mouse-mode t)
(mouse-wheel-mode t)

;(set-face-font 'default "-*-fixed-*-*-normal-*-13-*-*-*-*-*-*-*")
;(set-face-font 'default "-misc-fixed-medium-r-semicondensed--13-120-75-75-c-60-iso8859-9")
(set-face-font 'default "-misc-fixed-medium-r-normal--13-120-75-75-c-70-iso8859-9")

;;(require 'whitespace)
;;(require 'tramp)
;;(require 'smarttabs)

;; Bind newline-and-indent to RET
(define-key global-map (kbd "RET") 'newline-and-indent)
