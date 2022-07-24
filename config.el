;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Lars Magelssen"
      user-mail-address "lars.magelssen@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face

;(setq fancy-splash-image "~/Images/Emacs-logo.svg")
(setq fancy-splash-image "~/Downloads/pngwing.com.png")

(setq doom-font (font-spec :family "JetBrains Mono" :size 16 :weight 'semi-light)
     ;;doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
     doom-variable-pitch-font (font-spec :family "Alegreya" :size 16 :weight 'normal))

;; Set theme
(setq doom-theme 'doom-gruvbox)

;; Set line numbers with relative numbers
(setq display-line-numbers-type 'relative)



;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory vari     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keyr
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
             term-mode-hook
             shell-mode-hook
             eshell-mode-hook))

(add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Org mode
(defun lm/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(defun lm/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
        '(("^ *\\([-]\\) "
        (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  ;; TODO fix colors
  (dolist
      (face
       '((org-document-title 1.7 "#cc241d" bold)
         (org-level-1 1.75 "#d79921" bold)
         (org-level-2 1.40 "#d65d0e" bold)
         (org-level-3 1.30 "#cc241d" bold)
         (org-level-4 1.20 "#458588" normal)
         (org-level-5 1.10 "#b16286" normal)
         (org-level-6 1.05 "#689d6a" normal)
         (org-level-7 1.00 "#d79921" normal)
         (org-level-8 1.00 "#8ec07c" normal)))
    (set-face-attribute (nth 0 face) nil :font "Alegreya" :weight (nth 3 face) :height (nth 1 face) )) ; :foreground (nth 2 face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :foreground "#98971a" :inherit 'fixed-pitch))

(use-package! org
  :hook (org-mode . lm/org-mode-setup)
  :config
  (lm/org-font-setup))

(use-package! org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("⋄" "∘")))

(defun lm/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package! visual-fill-column
  :hook (org-mode . lm/org-mode-visual-fill))

(after! org
  (setq org-directory "~/Documents/org/"
        org-agenda-files (list "~/Documents/org/agenda.org"
                             "~/Documents/org/work.org"
                             "~/Documents/org/gtd.org"
                             "~/Documents/org/home.org")
        org-hide-emphasis-markers t
        org-log-done 'time
        org-log-done t
        org-ellipsis " ▾"
        org-todo-keywords        ; This overwrites the default Doom org-todo-keywords
          '((sequence
             "TODO(t)"
             "IN-PROGRESS(p)"
             "WAITING(w)"
             "|"                 ; The pipe necessary to separate "active" states and "inactive" states
             "DONE(d)"           ; Task has been completed
             "CANCELLED(c)" )))) ; Task has been cancelled))

;; Org Capture Templates
(after! org
  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline "~/Documents/org/gtd.org" "Tasks")
           "* TODO %?\n  %i\n  %a")
          ("e" "Emacs" entry (file+headline "~/Documents/org/doom-emacs-tips.org" "Tips og Triks")
           "* %?\n %t\n %i\n  %a")
          ("j" "Journal" entry (file+datetree "~/Documents/org/journal.org")
           "* %?\nEntered on %U\n  %i\n  %a"))))

;; Keybindings
(map! (:leader :desc "Search with Swiper" "s s" #'swiper)
      (:leader :desc "Comment selected lines" "e" #'comment-or-uncomment-region)
      (:desc "Move cursor down a window" "C-j" #'evil-window-down)
      (:desc "Move cursor up a window" "C-k" #'evil-window-next)
      (:desc "Move cursor left a window" "C-h" #'evil-window-left)
      (:desc "Move cursor right a window" "C-l" #'evil-window-right)
      (:desc "Toggle vterm" "C-x C-t" #'+vterm/toggle)
      (:leader :desc "Split window vertically" "w v" #'+evil/window-vsplit-and-follow)
      (:leader :desc "Split window horizontaly" "w s" #'+evil/window-split-and-follow)
      ("C-c c" (lambda () (interactive) (org-capture nil "t"))))
(display-time)
(toggle-frame-fullscreen)

;; Set cursor as box in insert mode with the color of the lightes gruvbox white
;; (which is darker than the default cursor)
(setq evil-insert-state-cursor '(box "#fbf1c7")
      evil-normal-state-cursor '(box "#fbf1c7"))
