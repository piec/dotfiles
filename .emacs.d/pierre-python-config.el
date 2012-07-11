(require 'org)

(defun prefix-list-elements (list prefix)
  (let (value)
    (nreverse
     (dolist (element list value)
	   (setq value (cons (format "%s%s" prefix element) value))))))

(defvar ac-source-rope
  '((candidates
	 . (lambda ()
         (prefix-list-elements (rope-completions) ac-target)))))

(defun rope-eldoc-function ()
  (interactive)
  (let* ((win-conf (current-window-configuration))
         (resize-mini-windows nil)
         (disable-python-trace t)
         class fun args result-type
         (flymake-message (python-flymake-show-help))
         (initial-point (point))
         (paren-range (let (tmp)
                        (ignore-errors
                          (setq tmp (vimpulse-paren-range 0 ?\( nil t))
                          (if (and tmp (>= (point) (car tmp)) (<= (point) (cadr tmp)))
                              tmp
                            nil))))
         (result (save-excursion
                   ;; check if we on the border of args list - lparen or rparen
                   (if paren-range
                       (goto-char (car paren-range)))
                   (call-interactively 'rope-show-doc)
                   (set-buffer "*rope-pydoc*")
                   (goto-char (point-min))
                   (if (or (equal (point-max) 1)
                           (not (re-search-forward "\\([a-zA-Z_]+[a-zA-Z0-9_]*\\)(.*):" (point-at-eol) t))
                           (and (current-message) (string-match-p "BadIdentifierError" (current-message))))
                       nil
                     (let (result)
                       ;; check if this is class definition
                       (if (looking-at "class \\([a-zA-Z_]+[a-zA-Z0-9_]*\\)(.*):")
                           (progn
                             (goto-char (point-at-eol))
                             (re-search-forward (buffer-substring (match-beginning 1) (match-end 1)))))
                       (goto-char (point-at-bol))
                       (setq result (buffer-substring (point) (point-at-eol)))

                       ;; check if exist better description of function
                       (goto-char (point-at-eol))
                       (string-match "\\([a-zA-Z_]+[a-zA-Z0-9_]*\\)(.*)" result) ;get function name
                       (if (re-search-forward (concat (match-string 1 result) "(.*)") nil t)
                           (progn
                             (goto-char (point-at-bol))
                             (setq result (buffer-substring (point) (point-at-eol)))))

                       ;; return result
                       result
                       ))))
         (arg-position (save-excursion
                         (if paren-range
                             (count-matches "," (car paren-range) (point))))))
    ;; save window configuration
    (set-window-configuration win-conf)
    ;; process main result
    (if result
        (progn
          (setq result-type (nth 1 (split-string result "->")))
          (setq result (nth 0 (split-string result "->")))
          (setq result (split-string result "("))
          (setq fun (nth 1 (split-string (nth 0 result) "\\.")))
          (setq class (nth 0 (split-string (nth 0 result) "\\.")))
          ;; process args - highlight current function argument
          (setq args (nth 0 (split-string (nth 1 result) ")")))

          ;; highlight current argument
          (if args
              (progn
                (setq args (split-string args ","))
                (setq args (let ((num -1))
                             (mapconcat
                              (lambda(x)(progn
                                          (setq num (+ 1 num))
                                          (if (equal num arg-position) (propertize x 'face 'eldoc-highlight-function-argument) x)))
                              args
                              ",")))))

          ;; create string for type signature
          (setq result
                (concat
                 (propertize "Signature: " 'face 'flymake-message-face)

                 (if fun
                     (concat (propertize (org-trim class) 'face 'font-lock-type-face)
                             "."
                             (propertize (org-trim fun) 'face 'font-lock-function-name-face))
                   (propertize (org-trim class) 'face 'font-lock-function-name-face))

                 " (" args ")"

                 (if result-type
                     (concat " -> " (org-trim result-type)))
                 ))))

    ;; create final result
    (if (and (null flymake-message) (null result))
        nil
      (concat flymake-message
              (if (and result flymake-message) "\n")
              result))))

(defvar disable-python-trace nil)

(defadvice message(around message-disable-python-trace activate)
  (if disable-python-trace
      t
    ad-do-it))

(defface flymake-message-face
  '((((class color) (background light)) (:foreground "#b2dfff"))
    (((class color) (background dark))  (:foreground "#b2dfff")))
  "Flymake message face")

(defun python-flymake-show-help ()
  (when (get-char-property (point) 'flymake-overlay)
    (let ((help (get-char-property (point) 'help-echo)))
      (if help
          (format (concat (propertize "Error: " 'face 'flymake-message-face) "%s") help)))))

(add-hook 'python-mode-hook
		  (function (lambda ()
					  (linum-mode-fn)
					  (setq indent-tabs-mode nil)
					  (setq python-indent-level 4)
					  (auto-complete-mode t)
					  (set (make-local-variable 'eldoc-documentation-function) 'rope-eldoc-function)
					  (setq ac-sources '(ac-source-rope ac-source-yasnippet))
					  )))

(provide 'pierre-python-config)
