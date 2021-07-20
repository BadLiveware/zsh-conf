;;; init --- minimal settings for magit
;;; Commentary:
;;; Code:

(setq debug-mode nil)

;; Defer garbage collection further back in the startup process
(setq gc-cons-threshold most-positive-fixnum)

;; Remove visual clutter
(when (not (display-graphic-p))
  (add-to-list 'default-frame-alist '(fullscreen . maximized)))
(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)

;; Set emacs directory variables
(setq user-init-file (or load-file-name (buffer-file-name)))
(setq user-emacs-directory (file-name-directory user-init-file))

;; Bootstrap straight.el
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

;; theming
(use-package doom-themes
  :straight t
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;; (use-package gcmh :straight t) ;; garbage collector magic hack
(use-package magit 
  :straight t
  :config 
  (advice-add #'magit-version :override #'ignore))

(use-package evil
  :straight t
  :ensure t
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :straight t
  :after evil
  :ensure t
  :config
  (evil-collection-init))

;; (use-package doom-themes
;;   :straight t 
;;   :config 
;;     (setq doom-themes-enable-bold t
;;           doom-themes-enable-italic t)
;;     (load-theme 'doom-vibrant t)
;;     (doom-themes-visual-bell-config))
;; (use-package solaire-mode
;;   :straight t
;;   :hook
;;   ((change-major-mode after-revert ediff-prepare-buffer) . turn-on-solaire-mode)
;;   (minibuffer-setup . solaire-mode-in-minibuffer)
;;   :config 
;;   (solaire-global-mode +1)
;;   (solaire-mode-swap-bg))

(setq display-line-numbers-type 'relative)
(kill-buffer "*scratch*")
(defalias 'yes-or-no-p 'y-or-n-p)
(setq inhibit-startup-screen t)
(setq initial-scratch-message "")

;; bring up magit-status
(unless (eq debug-mode t)
  (magit-status)
  (delete-other-windows)
  (display-line-numbers-mode))


(provide 'init)