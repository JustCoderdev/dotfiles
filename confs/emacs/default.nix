{ ... }:

{
	programs.emacs.enable = true;

	home.file = {
		".emacs".source = ./.emacs;
		".emacs.custom.el".source = ./.emacs.custom.el;
		".emacs.extra" = {
			source = ./.emacs.extra;
			recursive = true;
		};
	};
}
