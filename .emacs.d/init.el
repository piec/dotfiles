(setq message-log-max t)
(require 'cl)
(message "init.el start")
(defvar *emacs-load-start* (current-time))

(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/apel-10.8")
(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0")
(add-to-list 'load-path "~/.emacs.d/cscope")
;;(server-start)

(savehist-mode t)
(require 'xcscope)

(setq eval-expression-print-length 50)
(setq mouse-autoselect-window t)

;; C-j
(global-set-key "\C-j" 'eval-print-last-sexp)
(global-set-key [f6] 'whitespace-mode)

;; pour que S-up marche dans putty/screen/emacs avec TERM=xterm-256color
(define-key input-decode-map "\e[1;2A" [S-up])
(define-key input-decode-map "\e[1~" [home])
(define-key input-decode-map "\e[4~" [end])

(define-key input-decode-map "\eO3A" [M-up])
(define-key input-decode-map "\eO3B" [M-down])
(define-key input-decode-map "\eO3C" [M-right])
(define-key input-decode-map "\eO3D" [M-left])
;; putty
(define-key input-decode-map "\e\eOA" [M-up])
(define-key input-decode-map "\e\eOB" [M-down])
(define-key input-decode-map "\e\eOC" [M-right])
(define-key input-decode-map "\e\eOD" [M-left])

;;(define-key input-decode-map "[3;2~" [deletechar])
;;(global-set-key [S-delete] 'delete-char)

;; Bind newline-and-indent to RET
(define-key global-map (kbd "RET") 'newline-and-indent)
(setq-default tab-width 4)

;;(global-set-key "\C-a" 'mark-whole-buffer)
(global-set-key "\C-w" 'delete-window)
(global-set-key "\C-k"
                '(lambda ()
                   (interactive)
                   (kill-buffer nil)
                   )
                )

(xterm-mouse-mode t)
(mouse-wheel-mode t)

(show-paren-mode t)

(global-set-key "%" 'match-paren)

(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))

;;(setq scroll-preserve-screen-position nil)
(setq mouse-wheel-scroll-amount '(3 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse t) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

;; visual bookmarks
(require 'bm)
(global-set-key [f1] 'bm-toggle)
(global-set-key [f2] 'bm-next)

;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))


(require 'pierre-cursor-shape)

;(defconst my-font "-misc-fixed-medium-r-semicondensed-*-13-*-*-*-*-60-iso8859-9")
(defconst my-font "-misc-fixed-medium-r-semicondensed--13-120-75-75-c-60-*")

(if (eq window-system 'x)
    (progn
      (set-face-font 'default my-font)
      (set-scroll-bar-mode `right)
      )
  )


(require 'highlight-symbol)
(setq highlight-symbol-idle-delay 0)
(highlight-symbol-mode nil)
(global-set-key [(control f3)] 'highlight-symbol-at-point)
;;(global-set-key [f3] 'highlight-symbol-next)
(defun hl-symbol-and-jump ()
  (interactive)
  (let ((symbol (highlight-symbol-get-symbol)))
    (unless symbol (error "No symbol at point"))
    (unless hi-lock-mode (hi-lock-mode 1))
    (if (member symbol highlight-symbol-list)
        (highlight-symbol-next)
      (progn (hl-symbol-cleanup) (highlight-symbol-at-point))
      (highlight-symbol-next))))
(defun hl-symbol-cleanup ()
  (interactive)
  (mapc 'hi-lock-unface-buffer highlight-symbol-list)
  (setq highlight-symbol-list ()))
(global-set-key [f3] 'hl-symbol-and-jump)
(global-set-key [C-f3] 'hl-symbol-cleanup)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
;;(global-set-key [(meta f3)] 'highlight-symbol-prev)))
;; (global-set-key [(control meta f3)] 'highlight-symbol-query-replace)


;; C-x, C-c, C-v
(cua-mode)
;; InteractivelyDoThings
(ido-mode)

;;
;;(require 'line-num)
;;(linum-mode)

;; theme
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-hober)
	 )
  )

;; Bind newline-and-indent to RET
(define-key global-map (kbd "RET") 'newline-and-indent)

;;(global-set-key [f4] 'speedbar-get-focus)

(require 'smarttabs)
(require 'whitespace) ; for whitespace-mode

;; windown configuration undo: C-c <left>, C-c <right>
(when (fboundp 'winner-mode)
  (progn
    (winner-mode t)
    ;; alt-arrows for window navigation
    (windmove-default-keybindings 'meta)
    ))

(setq desktop-path '("."))
(desktop-save-mode t)

;;(require 'layout-restore)
;;(global-set-key [f11] 'layout-save-current)
;;(global-set-key [f12] 'layout-restore)

;;(global-set-key [f11] '(lambda () (interactive) (window-configuration-to-register ?w)))
;;(global-set-key [f12] '(lambda () (interactive) (jump-to-register ?w)))

;;(load-file "~/.emacs.d/cedet-1.0/common/cedet.el")
;;(add-to-list 'load-path "~/.emacs.d/ecb-2.40")
;;(require 'ecb)

;;(if (eq window-system 'x)
;;	(progn
;;	  (set-face-font 'ecb-default-general-face my-font)
;;	  (set-face-font 'ecb-bucket-node-face my-font)
;;	  )
 ;; )

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
(setq ac-auto-start nil) ; do not complete automatically
;;(ac-config-default)

;; auto-complete-clang
(require 'auto-complete-clang)
(setq ac-clang-auto-save t)
(if (eq window-system nil) ; custom key (ctrl-space)
	(progn
      ;;(define-key ac-mode-map (kbd "C-@") 'auto-complete)
      )
  (define-key ac-mode-map (kbd "C-SPC") 'auto-complete))
(defun my-ac-cc-mode-setup ()
  (setq ac-sources '(ac-source-filename))
  (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources))
  (auto-complete-mode)
  ;;chromium
  ;;(setq ac-clang-flags (split-string "-I. -I/home/pierre/chromium/src/chrome/browser/ui/views/tabs/ -I/home/pierre/chromium/src/ -I/usr/include/gtk-2.0/ -I/usr/lib/gtk-2.0/include/ -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include/ -I/usr/include/cairo/ -I/usr/include/pango-1.0/ -I/usr/include/gdk-pixbuf-2.0/ -I/usr/include/atk-1.0/ -I/home/pierre/chromium/src/third_party/skia/include/config/ -I/home/pierre/chromium/src/out/Debug/obj/gen/chrome/"))
  )
(add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)

(add-hook 'tcl-mode-hook
      (function (lambda ()
                  (setq indent-tabs-mode nil)
                  (setq tcl-indent-level 4))))

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (progn
              (setq ac-sources '(ac-source-words-in-buffer ac-source-symbols))
              (auto-complete-mode t)
              (eldoc-mode t)
              )))

;;(setq clang-completion-suppress-error 'f)
;;(setq ac-auto-start t)

;; ;; clang completion
;; (defun my-c-mode-common-hook()
;;   (setq ac-auto-start nil)
;;   (setq ac-expand-on-auto-complete nil)
;;   (setq ac-quick-help-delay 0.3)
;;   ;;(define-key c-mode-base-map (kbd "M-/") 'ac-complete-clang)
;;   ;;(define-key c-mode-base-map (kbd "C-a") 'ac-complete-clang)
;;   (if (eq window-system nil)
;; 	  (define-key c-mode-base-map (kbd "C-@") 'ac-complete-clang)
;; 	(define-key c-mode-base-map (kbd "C-SPC") 'ac-complete-clang)
;; 	)
;;   )

;; (add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;; wrap I-Search automatically
(defadvice isearch-repeat (after isearch-no-fail activate)
  (unless isearch-success
	(ad-disable-advice 'isearch-repeat 'after 'isearch-no-fail)
	(ad-activate 'isearch-repeat)
	(isearch-repeat (if isearch-forward 'forward))
	(ad-enable-advice 'isearch-repeat 'after 'isearch-no-fail)
	(ad-activate 'isearch-repeat)))

;; customize variables
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.40")
 '(indent-tabs-mode nil)
 '(tab-stop-list (quote (4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

(message "My .emacs loaded in %ds" (destructuring-bind (hi lo ms) (current-time)
                                     (- (+ hi lo) (+ (first *emacs-load-start*) (second *emacs-load-start*)))))

