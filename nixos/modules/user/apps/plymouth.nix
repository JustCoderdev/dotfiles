{ settings, ... }:
let
	dotfiles = settings.dotfiles_path;
in {

#	programs.plymouth.enable = true;
#	home.packages = with pkgs; [ zsh ];

	# Import configuration from dotfiles
	home.file."/lib/plymouth/themes/darnix/" = {
		source = "${dotfiles}/plymouth/theme/darnix/";
		recursive = true;
	};
}
