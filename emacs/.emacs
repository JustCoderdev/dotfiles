(setq custom-file "~/.emacs.custom.el")
(add-to-list 'load-path "~/.emacs.extra")


; Disable useless UI stuff
(tool-bar-mode 0)
(menu-bar-mode 0)
(toggle-scroll-bar 0)

; Settings
(setq ring-bell-function 'ignore)
(setq indent-tabs-mode 'only)

; Configure useful UI stuff
(global-display-line-numbers-mode 1)
(add-to-list 'default-frame-alist `(font . "Roboto Mono-20"))

; Enable simpc
(require 'simpc-mode)
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))

; Enable IDO
(ido-mode 1)
(ido-everywhere 1)



(load-file custom-file)
