; Load custom file
(setq custom-file "~/.emacs.custom.el")
(load-file "~/.emacs.custom.el")

; Disable useless UI stuff
(tool-bar-mode 0)
(menu-bar-mode 0)
(toggle-scroll-bar 0)

; Enable UI stuff
(global-display-line-numbers-mode 1)
(add-to-list 'default-frame-alist `(font . "Roboto Mono-20"))
