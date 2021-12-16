(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3") ;; Fixes https://emacs.stackexchange.com/questions/51721/failed-to-download-gnu-archive


;; Disable startup screen.
(setq inhibit-startup-screen t)

;; Reducing garbage collection makes startup faster.
(setq gc-cons-threshold 50000000)

;; Make the recentf bigger:
(setq recentf-max-saved-items nil) ;; nil = unlimited   ;;(setq recentf-max-saved-items 1000000) ;;(setq recentf-max-saved-items 200)
(setq recentf-keep nil) ;; ACTUALLY keeps stuff!... since if it is not accessible, like on an external drive that was removed, recentf.el will *remove* it from the list unless this is nil!!


;; https://github.com/siraben/dotfiles/blob/295a170231b08f2ea3e69c13eb035251bf60d564/emacs/.emacs.d/modules/siraben-packages.el ;;

;; Initialize package.el
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; For when the below `Ensure `use-package' is installed.` part fails, run M-x my-package-fix
(defun my-package-fix ()
  (interactive)
  ;; https://emacs.stackexchange.com/questions/233/how-to-proceed-on-package-el-signature-check-failure/53142#53142 , https://www.reddit.com/r/emacs/comments/elghvv/toubleshooting_gpg_cant_check_signature_no_public/
  (setq package-check-signature nil)
  (package-refresh-contents)
  (package-install 'gnu-elpa-keyring-update)
  (setq package-check-signature "allow-unsigned")
  )

;; Ensure `use-package' is installed.
(unless (package-installed-p 'use-package)
  (progn (package-refresh-contents)
	 (package-install 'use-package)))

(require 'use-package)

(setq use-package-always-ensure t)
(setq use-package-always-defer t)
(setq use-package-verbose t)
;; ;;



;; https://emacsredux.com/blog/2013/05/09/keep-backup-and-auto-save-files-out-of-the-way/ :
;; store all backup and autosave files in [a custom] dir
(setq backup-directory-alist
      `((".*" . ,"~/.emacs.d-backups")))
(setq auto-save-file-name-transforms
      `((".*" ,"~/.emacs.d-auto-saves/" t)))

;; Inserting with a mark selected will replace the text with this:
(delete-selection-mode 1) ;; https://www.emacswiki.org/emacs/DeleteSelectionMode

;; Load theme:
(use-package mood-one-theme
  :demand
  :config (load-theme 'mood-one t))
;;(add-to-list 'custom-theme-load-path "~/.emacs.d/firebelly")
;;(load-theme 'firebelly)
;;(load-theme 'wombat t)
;;(load-theme 'manoj-dark t)
;;(load-theme 'misterioso t)

;; (set-face-attribute 'mode-line nil
;;                     :box '(:width 0))
(set-background-color "gray12") ;;(set-background-color "black")
;; (set-face-attribute 'mode-line-buffer-id nil :foreground "light-gray")
(set-face-attribute 'default nil :height 130)

(tool-bar-mode -1)
(show-paren-mode 1)
(scroll-bar-mode -1)
(modify-syntax-entry ?_ "w") ;; https://emacs.stackexchange.com/questions/9583/how-to-treat-underscore-as-part-of-the-word  ;; (superword-mode 1) ;; (modify-syntax-entry ?_ "w")
(add-hook 'prog-mode-hook 'flyspell-prog-mode) ;; https://emacsredux.com/blog/2013/04/05/prog-mode-the-parent-of-all-programming-modes/

(setq-default cursor-type 'bar)

(server-start)

(use-package undo-tree
  :config
  (global-undo-tree-mode 1)
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d-undo-history")))
  )
  (add-hook 'after-init-hook '(lambda () (global-undo-tree-mode +1)))

;; https://superuser.com/questions/521223/shift-click-to-extend-marked-region
(define-key global-map (kbd "<S-down-mouse-1>") 'mouse-save-then-kill)




;; ivy ;;

;; https://github.com/abo-abo/swiper , https://sam217pa.github.io/2016/09/13/from-helm-to-ivy/
(use-package ivy
  :demand
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  ;; enable this if you want `swiper' to use it
  ;; (setq search-default-mode #'char-fold-to-regexp)
  (global-set-key "\C-s" 'swiper)
  (global-set-key (kbd "C-c C-r") 'ivy-resume)
  (global-set-key (kbd "<f6>") 'ivy-resume)

  (setq ivy-use-selectable-prompt t) ;; "Then you can select the text you have entered with C-p/C-n." ( https://www.reddit.com/r/emacs/comments/e02lup/ivy_swiper_doesnt_let_me_rename_or_save_a_file/ )
  ;; Another tip: C-M-j to choose what is currently in your text as you type.

  (setq ivy-magic-slash-non-match-action nil) ;; ? What does this do?

  ;; UPDATE: NVM the above two items, I solved my problem: just do M-i to insert what's under the current selection!! ( https://github.com/abo-abo/swiper/issues/1424 ). Also C-DEL (backspace that is) "will go up a level and pre-select the last directory"
  )
(use-package counsel
  :demand
  :config
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "<f1> f") 'counsel-describe-function)
  (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
  (global-set-key (kbd "<f1> o") 'counsel-describe-symbol)
  (global-set-key (kbd "<f1> l") 'counsel-find-library)
  (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
  (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
  (global-set-key (kbd "C-c g") 'counsel-git)
  (global-set-key (kbd "C-c j") 'counsel-git-grep)
  (global-set-key (kbd "C-c k") 'counsel-ag)
  (global-set-key (kbd "C-x l") 'counsel-locate)
  (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
  (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
  )
;; Better i-search (C-s):
(use-package swiper
  :demand
  :config
  ;; So we can actually close the swiper and ivy search: https://github.com/abo-abo/swiper/issues/991
  (define-key ivy-minibuffer-map (kbd "C-g") 'minibuffer-keyboard-quit)
  (define-key swiper-map (kbd "C-g") 'minibuffer-keyboard-quit)
  )






(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("12dd37432bb454355047c967db886769a6c60e638839405dad603176e2da366b" default)))
 '(global-linum-mode t)
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (swiper counsel ivy use-package undo-tree mood-one-theme))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
