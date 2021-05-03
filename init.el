;; NOTE: init.el is now generated from Emacs.org.  Please edit that file
;;       in Emacs and init.el will be generated automatically!

;; You will most likely need to adjust this font size for your system!
(defvar efs/default-font-size 100)
(defvar efs/default-variable-font-size 100)

;; Make frame transparency overridable
(defvar efs/frame-transparency '(90 . 90))

;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

(defun efs/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                     (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'efs/display-startup-time)

(add-to-list 'load-path "~/projects/emacs/packages")

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

  ;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package auto-package-update
  :custom
  (auto-package-update-interval 7)
  (auto-package-update-prompt-before-update t)
  (auto-package-update-hide-results t)
  :config
  (auto-package-update-maybe)
  (auto-package-update-at-time "09:00"))

;; NOTE: If you want to move everything out of the ~/.emacs.d folder
;; reliably, set `user-emacs-directory` before loading no-littering!
;(setq user-emacs-directory "~/.cache/emacs")

(use-package no-littering)

;; no-littering doesn't set this by default so we must place
;; auto save files in the same path as it uses for sessions
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)

(column-number-mode)
(global-display-line-numbers-mode t)

;; Set frame transparency
(set-frame-parameter (selected-frame) 'alpha efs/frame-transparency)
(add-to-list 'default-frame-alist `(alpha . ,efs/frame-transparency))
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(set-face-attribute 'default nil :font "Arial" :height efs/default-font-size)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Arial" :height efs/default-font-size)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Arial" :height efs/default-variable-font-size :weight 'regular)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(use-package general
  :after evil
  :config
  (general-create-definer efs/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")
  (efs/leader-keys
    "SPC" '(completion-at-point :which-key "auto complete code")
    "n" '(:ignore t :which-key "navigation")
    "nr" '(lsp-treemacs-references :which-key "find references of symbol")
    "nd" '(lsp-find-definition :which-key "find definition of symbol")
    "nt" '(lsp-type-definition :which-key "find definition of symbol")
    "r" '(:ignore t :which-key "refactor")
    "ro" '(srefactor-refactor-at-point :which-key "symantic local symbol refactor")
    "rr" '(lsp-rename :which-key "clang global symbol refactor")
    "m" '(magit-status :which-key "magit status")
    "p" '(:ignore t :which-key "project")
    "pC" '(projectile-configure-project :which-key "configure the project")
    "pc" '(projectile-compile-project :which-key "compile the project")
    "pr" '(projectile-run-project :which-key "run the project")
    "pt" '(projectile-test-project :which-key "test the project")
    "pv" '(treemacs :which-key "show the project view")
    "pa" '(treemacs-projectile :which-key "add project to treemacs workspace")
    "pd" '(treemacs-remove-project-from-workspace :which-key "remove project from treemacs workspace")
    "f"  '(:ignore t :which-key "source file")
    "fs" '(lsp-treemacs-symbols :which-key "show symbols in the file")
    "fr" '(lsp-treemacs-references :which-key "show reference in the file")
    "ff" '(clang-format-buffer :which-key "reformats the file using clang-format")
    "fd" '(lsp-treemacs-errors-list :which-key "show diagnostic information in file")
    "d" '(gdb :which-key "start gdb")
    "b" '(gdb-toggle-breakpoint-all :which-key "insert breakpoint on all sessions")
    "8" '(gdb-next :which-key "move to next line")
    "7" '(gdb-step :which-key "step into line")
    "9" '(gdb-continue-all :which-key "continue execution in all sessions")
    "5" '(gdb-continue :which-key "continue execution in current sessions")
    "0" '(gdb-kill-all-sessions :which-key "stop debugging")
    "k" '(kill-matching-buffers :which-key "kill matching buffers")
    "w" '(gud-watch :which-key "add watch to variable")
    "t"  '(:ignore t :which-key "toggles")
    "tf" '(other-frame :which-key "toggle frame")
    "ti" '(ivy-rich-mode :which-key "toggle ivy-rich-mode")))


(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (setq evil-want-keybinding t)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package command-log-mode
  :commands command-log-mode)

(use-package doom-themes
  :init (load-theme 'doom-palenight t))

(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :after ivy
  :init
  (ivy-rich-mode t))

(use-package counsel
  :bind (("C-M-j" . 'counsel-switch-buffer)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config
  (counsel-mode 1))

(use-package ivy-prescient
  :after counsel
  :custom
  (ivy-prescient-enable-filtering nil)
  :config
  ;; Uncomment the following line to have sorting remembered across sessions!
  ;(prescient-persist-mode 1)
  (ivy-prescient-mode 1))

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package hydra
  :defer t)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(efs/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil    :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil    :inherit 'fixed-pitch)
  (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil     :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil    :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil  :inherit 'fixed-pitch)
  (set-face-attribute 'line-number nil :inherit 'fixed-pitch)
  (set-face-attribute 'line-number-current-line nil :inherit 'fixed-pitch))

(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(use-package org
  :pin org
  :commands (org-capture org-agenda)
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")

  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  (setq org-agenda-files
        '("~/projects/emacs/OrgFiles/Tasks.org"
          "~/projects/emacs/OrgFiles/Habits.org"
          "~/projects/emacs/OrgFiles/Birthdays.org"))

  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)

  (setq org-todo-keywords
    '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
      (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

  (setq org-refile-targets
    '(("Archive.org" :maxlevel . 1)
      ("Tasks.org" :maxlevel . 1)))

  ;; Save Org buffers after refiling!
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  (setq org-tag-alist
    '((:startgroup)
       ; Put mutually exclusive tags here
       (:endgroup)
       ("@errand" . ?E)
       ("@home" . ?H)
       ("@work" . ?W)
       ("agenda" . ?a)
       ("planning" . ?p)
       ("publish" . ?P)
       ("batch" . ?b)
       ("note" . ?n)
       ("idea" . ?i)))

  ;; Configure custom agenda views
  (setq org-agenda-custom-commands
   '(("d" "Dashboard"
     ((agenda "" ((org-deadline-warning-days 7)))
      (todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))
      (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

    ("n" "Next Tasks"
     ((todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))))

    ("W" "Work Tasks" tags-todo "+work-email")

    ;; Low-effort next actions
    ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
     ((org-agenda-overriding-header "Low Effort Tasks")
      (org-agenda-max-todos 20)
      (org-agenda-files org-agenda-files)))

    ("w" "Workflow Status"
     ((todo "WAIT"
            ((org-agenda-overriding-header "Waiting on External")
             (org-agenda-files org-agenda-files)))
      (todo "REVIEW"
            ((org-agenda-overriding-header "In Review")
             (org-agenda-files org-agenda-files)))
      (todo "PLAN"
            ((org-agenda-overriding-header "In Planning")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "BACKLOG"
            ((org-agenda-overriding-header "Project Backlog")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "READY"
            ((org-agenda-overriding-header "Ready for Work")
             (org-agenda-files org-agenda-files)))
      (todo "ACTIVE"
            ((org-agenda-overriding-header "Active Projects")
             (org-agenda-files org-agenda-files)))
      (todo "COMPLETED"
            ((org-agenda-overriding-header "Completed Projects")
             (org-agenda-files org-agenda-files)))
      (todo "CANC"
            ((org-agenda-overriding-header "Cancelled Projects")
             (org-agenda-files org-agenda-files)))))))

  (setq org-capture-templates
    `(("t" "Tasks / Projects")
      ("tt" "Task" entry (file+olp "~/projects/emacs/OrgFiles/Tasks.org" "Inbox")
           "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)

      ("j" "Journal Entries")
      ("jj" "Journal" entry
           (file+olp+datetree "~/projects/emacs/OrgFiles/Journal.org")
           "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
           ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
           :clock-in :clock-resume
           :empty-lines 1)
      ("jm" "Meeting" entry
           (file+olp+datetree "~/projects/emacs/OrgFiles/Journal.org")
           "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)

      ("w" "Workflows")
      ("we" "Checking Email" entry (file+olp+datetree "~/projects/emacs/OrgFiles/Journal.org")
           "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)

      ("m" "Metrics Capture")
      ("mw" "Weight" table-line (file+headline "~/projects/emacs/OrgFiles/Metrics.org" "Weight")
       "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)))

  (define-key global-map (kbd "C-c j")
    (lambda () (interactive) (org-capture nil "jj")))

  (efs/org-font-setup))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

(with-eval-after-load 'org
  (org-babel-do-load-languages
      'org-babel-load-languages
      '((emacs-lisp . t)
      (python . t)))

  (push '("conf-unix" . conf-unix) org-src-lang-modes))

(with-eval-after-load 'org
  ;; This is needed as of Org 9.2
  (require 'org-tempo)

  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python")))

;; Automatically tangle our Emacs.org config file when we save it
(defun efs/org-babel-tangle-config ()
  (when (string-equal (file-name-directory (buffer-file-name))
                      (expand-file-name user-emacs-directory))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

(defun efs/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode)
  (setq lsp-headerline-breadcrumb-enable t)
  (setq lsp-headerline-breadcrumb-icons-enable t))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . efs/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (progn
  (add-hook 'prog-mode-hook #'lsp)
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-tramp-connection
				     "/mnt/common/hdevarajan/stage/spack/var/spack/environments/emacs/.spack-env/view/bin/clang")
                    :major-modes '(c-mode c++-mode)
                    :remote? t
                    :server-id 'clangd-remote)))
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy
  :after lsp)

(use-package aggressive-indent
  :config
  (global-aggressive-indent-mode 1)
  (add-to-list 'aggressive-indent-excluded-modes 'html-mode)
  (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode))

(use-package dap-mode
  ;; Uncomment the config below if you want all UI panes to be hidden by default!
  ;; :custom
  ;; (lsp-enable-dap-auto-configure nil)
  ;; :config
  ;; (dap-ui-mode 1)
  :commands dap-debug
  :config
  ;; Set up Node debugging
  (require 'dap-node)
  (dap-node-setup) ;; Automatically installs Node debug adapter if needed

  ;; Bind `C-c l d` to `dap-hydra` for easy access
  (general-define-key
    :keymaps 'lsp-mode-map
    :prefix lsp-keymap-prefix
    "d" '(dap-hydra t :wk "debugger")))

;; GDB base package 
      (use-package quelpa)
      (require 'quelpa)
      (use-package quelpa-use-package)
      (require 'quelpa-use-package)
      (use-package gdb-mi
        :quelpa (gdb-mi :fetcher git
                        :url "https://github.com/hariharan-devarajan/emacs-gdb.git"
                        :files ("*.el" "*.c" "*.h" "Makefile"))
        :init
        (fmakunbound 'gdb)
        (fmakunbound 'gdb-enable-debug))
      ;; GDB functions to enhance functionality 
      (defun gdb-pid-internal (debuggee-pid)
        "Start debugging an executable with DEBUGGEE-PID in a new current session."
        (let ((session (gdb-create-session)))
          (setf (gdb--session-debuggee-path session) debuggee-pid)

          (with-selected-frame (gdb--session-frame session)
            (gdb--command (concat "attach " debuggee-pid))
            (gdb--command "-file-list-exec-source-file" 'gdb--context-initial-file)
            (gdb--rename-buffers-with-debuggee debuggee-pid))

          (cl-loop for frame in (frame-list)
                   when (eq (frame-parameter frame 'gdb--session) session)
                   do (gdb--rename-frame frame))))

      (defun gdb-toggle-breakpoint-all (&optional arg)
        "Toggle breakpoint in all active gdb sessions location.
                When ARG is non-nil, prompt for additional breakpoint settings.
                If ARG is `dprintf' create a dprintf breakpoint instead."
        (interactive "P")
        (setq gdb--session-temp gdb--session)
        (cl-loop for session in gdb--sessions do
                 (setq gdb--session session) 
                 (let ((breakpoint-on-point (gdb--infer-breakpoint session))
                       (location (gdb--point-location))
                       (dprintf (eq arg 'dprintf))
                       type thread ignore-count condition format-args)
                   (when (and (not location) breakpoint-on-point)
                     (setq location (gdb--infer-breakpoint-location breakpoint-on-point)))

                   (when (or arg (not location))
                     (unless (string= (or location "")
                                      (setq location (read-string (concat "Location: ") location)))
                       (setq breakpoint-on-point nil))

                     (when breakpoint-on-point
                       (setq thread       (gdb--breakpoint-thread       breakpoint-on-point)
                             ignore-count (gdb--breakpoint-ignore-count breakpoint-on-point)
                             condition    (gdb--breakpoint-condition    breakpoint-on-point)))

                     (setq
                      type (cdr (assoc-string (completing-read (concat "Type of " (if dprintf "dprintf" "breakpoint") ":")
                                                               gdb--available-breakpoint-types nil t nil nil
                                                               (caar gdb--available-breakpoint-types))
                                              gdb--available-breakpoint-types))
                      thread (gdb--ask-for-thread thread)
                      ignore-count (read-number "Ignore count: " (or ignore-count 0))
                      condition (gdb--read-line "Condition: " condition))

                     (when dprintf (setq format-args (gdb--read-line "Format and args: "))))

                   (when breakpoint-on-point
                     (gdb--command (format "-break-delete %d" (gdb--breakpoint-number breakpoint-on-point))
                                   (cons 'gdb--context-breakpoint-delete breakpoint-on-point)))

                   (when (and location (or arg (not breakpoint-on-point)))
                     (gdb--command (concat "-" (if dprintf "dprintf" "break") "-insert "
                                           (and (> (length condition) 0) (concat "-c " (gdb--escape-argument condition) " "))
                                           (and thread (format "-p %d " (gdb--thread-id thread)))
                                           (and ignore-count (> ignore-count 0) (format "-i %d " ignore-count))
                                           type "-f " (gdb--escape-argument location)
                                           (when dprintf (concat " " format-args)))
                                   'gdb--context-breakpoint-insert nil t))))
        (setq gdb--session gdb--session-temp))

    (defun gdb-pid (debuggee-pid)
        "Start debugging an executable with DEBUGGEE-PID in the current session."
        (interactive "spid: ")
        (gdb-pid-internal debuggee-pid))

    (defun gdb-continue-all (&optional arg)
      "Continues all GDB Sessions. If ARG is nil, try to resume threads in this order:
                - Inferred thread if it is stopped
                - Selected thread if it is stopped
                - All threads
              If ARG is non-nil, resume all threads unconditionally."
      (interactive "P")
      (setq gdb--session-temp gdb--session)
      (cl-loop for session in gdb--sessions do
               (setq gdb--session session)
               (gdb--with-valid-session
                  (let* ((inferred-thread (gdb--infer-thread 'not-selected))
                         (selected-thread (gdb--session-selected-thread session))
                         (thread-to-resume
                          (unless arg
                            (cond
                             ((and inferred-thread (string= (gdb--thread-state inferred-thread) "stopped")) inferred-thread)
                             ((and selected-thread (string= (gdb--thread-state selected-thread) "stopped")) selected-thread)))))

                    (if (or arg (not thread-to-resume))
                        (gdb--command "-exec-continue --all")
                      (gdb--command "-exec-continue" nil thread-to-resume)))))
      (setq gdb--session gdb--session-temp))

    (defun gdb-kill-all-session ()
      "Kill all active GDB session."
        (interactive)
        (setq gdb--session-temp gdb--session)
        (cl-loop for session in gdb--sessions do
                 (setq gdb--session session)
                 (gdb--kill-session (gdb--infer-session)))
        (setq gdb--session gdb--session-temp))

    (defun executable-find (command)
        "Search for COMMAND in `exec-path' and return the absolute file name.
               Return nil if COMMAND is not found anywhere in `exec-path'."
        ;; Use 1 rather than file-executable-p to better match the behavior of
        ;; call-process.
        (locate-file command exec-path exec-suffixes 1))

    (setq mpi-executable (executable-find "mpirun"))

    (defun string-trim-final-newline (string)
      ;; trim the final \n if exists in a string.
        (let ((len (length string)))
          (cond
           ((and (> len 0) (eql (aref string (- len 1)) ?\n))
            (substring string 0 (- len 1)))
           (t string))))

    (defun mpi-debug (path procs)
        "Executes an mpi process with executable and number of procs. 
               mpirun -n $procs $path.
           Addionally, it spawn a debugger with each process pre-attached to the gdb on separate sessions."
        (interactive
         (list
          (read-file-name "Enter Executable: ")
          (read-string "Num of procs: ")
          ))
        (setq mpi-command (format "%s -n %s %s" mpi-executable procs path))
        (with-output-to-temp-buffer mpi-command
          (async-shell-command mpi-command mpi-command "*Messages*")
          (pop-to-buffer mpi-command)
          (setq proc_ids (shell-command-to-string (format "ps -aef | grep %s | grep -v grep | grep -v mpirun | awk '{print $2}'" path)))
          (setq proc_ids (string-trim-final-newline proc_ids))
          (setq proc_id_lists (split-string proc_ids "\n"))
          (cl-loop for proc_id in proc_id_lists do
                   (gdb-pid-internal proc_id))
          ))
  (defun mpi-attach-debug (path)
        "Executes an mpi process with executable and number of procs. 
               mpirun -n $procs $path.
           Addionally, it spawn a debugger with each process pre-attached to the gdb on separate sessions."
        (interactive
         (list
          (read-file-name "Enter Executable: ")
          ))
        (setq path (file-remote-p (file-truename path) 'localname))
        (setq path (file-name-nondirectory path))
        (setq mpi-command (format "%s %s" mpi-executable path))
(setq pipe (format "ps -aef | grep '%s' | grep -v grep | grep -v mpirun | awk '{print $2}'" path))	
          (message (format "Command %s" pipe))
          (setq proc_ids (shell-command-to-string pipe))
          (message (format "Process Ids to attach %s..." proc_ids))
          (setq proc_ids (string-trim-final-newline proc_ids))
          (setq proc_id_lists (split-string proc_ids "\n"))
          (cl-loop for proc_id in proc_id_lists do
                   (gdb-pid-internal proc_id))
          )
(setq comint-prompt-read-only t)

(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

(use-package python-mode
  :ensure t
  :hook (python-mode . lsp-deferred)
  :custom
  ;; NOTE: Set these if Python 3 is called "python3" on your system!
  ;; (python-shell-interpreter "python3")
  ;; (dap-python-executable "python3")
  (dap-python-debugger 'debugpy)
  :config
  (require 'dap-python))

(use-package pyvenv
  :after python-mode
  :config
  (pyvenv-mode 1))

(setq package-selected-packages '(lsp-mode yasnippet lsp-treemacs helm-lsp
      projectile hydra clang-format+ flycheck company avy helm-xref dap-mode))

  (when (cl-find-if-not #'package-installed-p package-selected-packages)
    (package-refresh-contents)
    (mapc #'package-install package-selected-packages))

  ;; sample `helm' configuration use https://github.com/emacs-helm/helm/ for details
  (helm-mode)
  (require 'helm-xref)
  (require 'clang-format+)
  (add-hook 'c-mode-common-hook #'clang-format+-mode)
  (setq clang-format+-always-enable t)
  (which-key-mode)
  (dolist (mode '(c-mode-hook
                  c++-mode-hook))
   (add-hook mode 'lsp)
   (require 'projectile)
   (semantic-mode 1)
   (require 'dap-cpptools)
   (add-hook mode (lambda () (lsp-mode t)))
   (add-hook mode (lambda () (lsp-ui-mode t)))
   (add-hook mode (lambda () (setq emacs-clang-rename-compile-commands-file (concat (projectile-project-root) "build/compile_commands.json"))))
   (add-hook mode (lambda () (setq projectile-project-compile-cmd "cmake --build . -j")))
   (add-hook mode (lambda () (setq projectile-project-test-cmd "ctest -vv")))
   (add-hook mode (lambda () (setq projectile-project-configure-cmd (concat "rm -rf " (projectile-project-root) "build/* && cmake ../ -B ./ -DCMAKE_PREFIX_PATH=$HOME/install -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_BUILD_TYPE=Debug")))))

  (setq gc-cons-threshold (* 100 1024 1024)
        read-process-output-max (* 1024 1024)
        treemacs-space-between-root-nodes nil
        company-idle-delay 0.0
        company-minimum-prefix-length 1
        lsp-idle-delay 0.1)  ;; clangd is fast

  (with-eval-after-load 'lsp-mode
    (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
    (require 'dap-cpptools)
    (yas-global-mode))

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
     (when (file-directory-p "~/projects")
       (setq projectile-project-search-path '("~/projects")))
     (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :after projectile
  :config (counsel-projectile-mode))

(use-package tramp
  :config
  (eval-after-load 'tramp '(setenv "SHELL" "/bin/bash")))
(setq tramp-chunksize 500)
(setq tramp-default-method "sshx")
(add-to-list 'tramp-remote-path "/mnt/common/hdevarajan/stage/spack/var/spack/environments/emacs/.spack-env/view/bin")

(use-package magit
  :commands magit-status
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; NOTE: Make sure to configure a GitHub token before using this package!
;; - https://magit.vc/manual/forge/Token-Creation.html#Token-Creation
;; - https://magit.vc/manual/ghub/Getting-Started.html#Getting-Started
(use-package forge
  :after magit)

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package term
  :commands term
  :config
  (setq explicit-shell-file-name "bash") ;; Change this to zsh, etc
  ;;(setq explicit-zsh-args '())         ;; Use 'explicit-<shell>-args for shell-specific args

  ;; Match the default Bash shell prompt.  Update this if you have a custom prompt
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *"))

(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))

(use-package vterm
  :commands vterm
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")  ;; Set this to match your custom shell prompt
  ;;(setq vterm-shell "zsh")                       ;; Set this to customize the shell to launch
  (setq vterm-max-scrollback 10000))

(when (eq system-type 'windows-nt)
  (setq explicit-shell-file-name "powershell.exe")
  (setq explicit-powershell.exe-args '()))

(defun efs/configure-eshell ()
  ;; Save command history when commands are entered
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

  ;; Truncate buffer for performance
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  ;; Bind some useful keys for evil-mode
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "C-r") 'counsel-esh-history)
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "<home>") 'eshell-bol)
  (evil-normalize-keymaps)

  (setq eshell-history-size         10000
        eshell-buffer-maximum-lines 10000
        eshell-hist-ignoredups t
        eshell-scroll-to-bottom-on-input t))

(use-package eshell-git-prompt
  :after eshell)

(use-package eshell
  :hook (eshell-first-time-mode . efs/configure-eshell)
  :config

  (with-eval-after-load 'esh-opt
    (setq eshell-destroy-buffer-when-process-dies t)
    (setq eshell-visual-commands '("htop" "zsh" "vim" "ps")))

  (eshell-git-prompt-use-theme 'powerline))

(use-package dired-sidebar
  :ensure t
  :commands (dired-sidebar-toggle-sidebar)
  :bind (("C-x C-n" . dired-sidebar-toggle-sidebar)))

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer))

(use-package dired-single
  :commands (dired dired-jump))

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired-open
  :commands (dired dired-jump)
  :config
  ;; Doesn't work as expected!
  ;;(add-to-list 'dired-open-functions #'dired-open-xdg t)
  (setq dired-open-extensions '(("png" . "feh")
                                ("mkv" . "mpv"))))

(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "H" 'dired-hide-dotfiles-mode))

;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold (* 2 1000 1000))
