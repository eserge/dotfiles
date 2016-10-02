(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
; (add-to-list 'package-archives
;              '("marmalade" . "http://marmalade-repo.org/packages/") t)
; (add-to-list 'package-archives
;              '("tromey" . "http://tromey.com/elpa/") t)
; (add-to-list 'package-archives
;              '("melpa" . "http://melpa.milkbox.net/packages/") t)
;
(setq package-enable-at-startup nil)
;; Load and activate emacs packages. Do this first so that the
;; packages are loaded before you start trying to modify them.
;; This also sets the load path.
(package-initialize)

;; Download the ELPA archive description if needed.
;; This informs Emacs about the latest versions of all packages, and
;; makes them available for download.
(when (not package-archive-contents)
  (package-refresh-contents))

; (defun ensure-package-installed (&rest packages)
;   "Assure every package is installed, ask for installation if it’s not.
; 
; Return a list of installed packages or nil for every skipped package."
;   (mapcar
;    (lambda (package)
;      (if (package-installed-p package)
;         nil
;         (if (y-or-n-p (format "Package %s is missing. Install it? " package))
;             (package-install package)
;             package)))
;    packages))

;; Make sure to have downloaded archive description.
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

;; The packages you want installed. You can also install these
;; manually with M-x package-install
;; Add in your own as you wish:
(defvar my-packages
  '(;; makes handling lisp expressions much, much easier
    ;; Cheatsheet: http://www.emacswiki.org/emacs/PareditCheatsheet
    paredit

    ;; key bindings and code colorization for Clojure
    ;; https://github.com/clojure-emacs/clojure-mode
    clojure-mode

    ;; extra syntax highlighting for clojure
    clojure-mode-extra-font-locking

    ;; integration with a Clojure REPL
    ;; https://github.com/clojure-emacs/cider
    cider

    ;; allow ido usage in as many contexts as possible. see
    ;; customizations/navigation.el line 23 for a description
    ;; of ido
    ido-ubiquitous

    ;; Enhances M-x to allow easier execution of commands. Provides
    ;; a filterable list of possible commands in the minibuffer
    ;; http://www.emacswiki.org/emacs/Smex
    smex

    ;; project navigation
    projectile

    ;; colorful parenthesis matching
    rainbow-delimiters

    ;; edit html tags like sexps
    tagedit

    ;; git integration
    magit))

;; On OS X, an Emacs instance started from the graphical user
;; interface will have a different environment than a shell in a
;; terminal window, because OS X does not run a shell during the
;; login. Obviously this will lead to unexpected results when
;; calling external utilities like make from Emacs.
;; This library works around this problem by copying important
;; environment variables from the user's shell.
;; https://github.com/purcell/exec-path-from-shell
(if (eq system-type 'darwin)
    (add-to-list 'my-packages 'exec-path-from-shell))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; Place downloaded elisp files in ~/.emacs.d/vendor. You'll then be able
;; to load them.
;;
;; For example, if you download yaml-mode.el to ~/.emacs.d/vendor,
;; then you can add the following code to this file:
;;
;; (require 'yaml-mode)
;; (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
;; 
;; Adding this code will make Emacs enter yaml mode whenever you open
;; a .yml file
(add-to-list 'load-path "~/.emacs.d/vendor")


;;;;
;; Customization
;;;;

;; Add a directory to our load path so that when you `load` things
;; below, Emacs knows where to look for the corresponding file.
(add-to-list 'load-path "~/.emacs.d/customizations")

;; Sets up exec-path-from-shell so that Emacs will use the correct
;; environment variables
(load "shell-integration.el")

;; These customizations make it easier for you to navigate files,
;; switch buffers, and choose options from the minibuffer.
(load "navigation.el")

;; These customizations change the way emacs looks and disable/enable
;; some user interface elements
; (load "ui.el")

;; These customizations make editing a bit nicer.
(load "editing.el")

;; Hard-to-categorize customizations
(load "misc.el")

;; For editing lisps
(load "elisp-editing.el")

;; Langauage-specific
(load "setup-clojure.el")
(load "setup-js.el")

;; grabbed almost everything above from braveclojure book



(custom-set-variables
 '(initial-frame-alist (quote ((fullscreen . maximized))))) ;; start maximized


;; Activate installed packages
; (package-initialize)

;; Assuming you wish to install "iedit" and "magit"
; (ensure-package-installed 'iedit 'magit)

;; (defun my-bell-function ()
;;   (unless (memq this-command
;;                 '(
;;                   isearch-abort abort-recursive-edit exit-minibuffer
;;                   keyboard-quit mwheel-scroll down up next-line previous-line
;;                   wheel-left wheel-right
;;                   triple-wheel-left triple-wheel-right
;;                   double-wheel-left double-wheel-right
;;                   backward-char forward-char
;;                   )
;;                 )
;;     (ding)))
;; (setq ring-bell-function 'my-bell-function)
(setq visible-bell nil) ;; The default
(setq ring-bell-function 'ignore)

(add-to-list 'custom-theme-load-path (expand-file-name "moe-theme.el" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "moe-theme.el" user-emacs-directory))

; (ensure-package-installed 'iedit
;                           'evil
;                           'projectile
;                           'magit
;                           'neotree
;                           'sublimity
;                           'evil-leader
;                           'helm
;                           'moe-theme)


(require 'evil)
(require 'evil-leader)
(evil-mode t)
(global-evil-leader-mode)
(evil-leader/set-leader ",")
(evil-leader/set-key
  "b" 'switch-to-buffer)

(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

(setq inhibit-startup-message t)

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)

;; sublimity scroll
(setq sublimity-scroll-weight 10
      sublimity-scroll-drift-length 5)

(require 'sublimity)
(require 'sublimity-scroll)
;; (require 'sublimity-map)

(sublimity-mode t)

(require 'moe-theme)
(moe-dark)

(setq-default indent-tabs-mode nil)

(ac-config-default)

(helm-mode 1)

;; helm settings (TAB in helm window for actions over selected items,
;; C-SPC to select items)
(require 'helm-config)
(require 'helm-misc)
; (require 'helm-projectile)
(require 'helm-locate)
(setq helm-quick-update t)
(setq helm-bookmark-show-location t)
(setq helm-buffers-fuzzy-matching t)

; (after 'projectile
;   (package 'helm-projectile))
(global-set-key (kbd "M-x") 'helm-M-x)

(defun helm-my-buffers ()
  (interactive)
  (let ((helm-ff-transformer-show-only-basename nil))
  (helm-other-buffer '(helm-c-source-buffers-list
                       helm-c-source-elscreen
                       helm-c-source-projectile-files-list
                       helm-c-source-ctags
                       helm-c-source-recentf
                       helm-c-source-locate)
                     "*helm-my-buffers*")))


(scroll-bar-mode -1)
; (menu-bar-mode nil)
(tool-bar-mode -1)
