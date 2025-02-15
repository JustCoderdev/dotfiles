{ settings, dotfiles_path, ... }:
let
	username = settings.username;
	hostname = settings.hostname;
in {
	programs.zsh = {
		enable = true;
		completionInit = "";

		# Import configuration from dotfiles
		initExtra = ''
			export DOT_NIXOS=1;
			export DOT_FILES="/.dotfiles"
			export HOST=${hostname};
			# export LD_LIBRARY_PATH=/lib64:$LD_LIBRARY_PATH;
			source "''${DOT_FILES}/zsh/.zshrc";
		'';
	};

#	home.file."/home/${username}/.zsh" = {
#		source = "${dotfiles}/zsh";
#		recursive = true;
#	};
}
