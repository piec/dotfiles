;; pour que S-up marche dans putty/screen/emacs avec TERM=xterm-256color
(define-key input-decode-map "\e[1;2A" [S-up])
(define-key input-decode-map "\e[4~" [end])

;; Bind newline-and-indent to RET
(define-key global-map (kbd "RET") 'newline-and-indent)
(setq-default tab-width 4)

(xterm-mouse-mode t)
(mouse-wheel-mode t)

;;(set-face-font 'default "-misc-fixed-medium-r-normal--13-120-75-75-c-70-iso8859-9")

;; C-x, C-c, C-v
(cua-mode)
;; InteractivelyDoThings
(ido-mode)

(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/apel-10.8")
;;(server-start)

;; alt-arrows for window navigation
(windmove-default-keybindings 'meta)

;;
(require 'line-num)
(linum-mode)

;; theme
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-hober)))

;; Bind newline-and-indent to RET
(define-key global-map (kbd "RET") 'newline-and-indent)

;;(global-set-key [f4] 'speedbar-get-focus)

(require 'smarttabs)
(require 'whitespace) ; for whitespace-mode

;; windown configuration undo: C-c <left>, C-c <right>
(when (fboundp 'winner-mode)
  (winner-mode 1))

(desktop-save-mode 1)

(require 'layout-restore)
(global-set-key [f11] 'layout-save-current)
(global-set-key [f12] 'layout-restore)
;;(global-set-key [f11] '(lambda () (interactive) (window-configuration-to-register ?w)))
;;(global-set-key [f12] '(lambda () (interactive) (jump-to-register ?w)))

(load-file "~/.emacs.d/cedet-1.0/common/cedet.el")
(add-to-list 'load-path "~/.emacs.d/ecb-2.40")
(require 'ecb)

;;(require 'windows)
;;(win:startup-with-window)
;;(define-key ctl-x-map "C" 'see-you-again)

;; revive
;;(require 'revive)
;;(autoload 'save-current-configuration "revive" "Save status" t)
;;(autoload 'resume "revive" "Resume Emacs" t)
;;(autoload 'wipe "revive" "Wipe Emacs" t)
;;(define-key ctl-x-map "S" 'save-current-configuration)
;;(define-key ctl-x-map "F" 'resume)
;;(define-key ctl-x-map "K" 'wipe)


;;(require 'tabbar)
;;(tabbar-mode)
;;(global-set-key  [C-tab] 'tabbar-forward)
;;(global-set-key  [C-S-tab] 'tabbar-backward)


;; C-x k to close emacsclient session (instead of C-x #)
;;(add-hook 'server-switch-hook
;;	  (lambda ()
;;	    (when (current-local-map)
;;	      (use-local-map (copy-keymap (current-local-map))))
;;	    (when server-buffer-clients
;;	      (local-set-key (kbd "C-x k") 'server-edit))))

(add-to-list 'load-path "~/.emacs.d")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "/home/pierre/.emacs.d/ac-dict")
(ac-config-default)

;; auto-complete-clang
(require 'auto-complete-clang)
(setq clang-completion-suppress-error 't)

(defun my-c-mode-common-hook()
  (setq ac-auto-start nil)
  (setq ac-expand-on-auto-complete nil)
  (setq ac-quick-help-delay 0.3)
					;(define-key c-mode-base-map (kbd "M-/") 'ac-complete-clang)
  (define-key c-mode-base-map (kbd "C-@") 'ac-complete-clang)
  )

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.40"))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
