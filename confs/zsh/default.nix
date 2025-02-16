{ ... }:

{
	programs.zsh = {
		enable = true;
		completionInit = "";

		initExtra = ''
			export DOT_NIXOS=1;
			export DOT_FILES="/.dotfiles"
			source "''${DOT_FILES}/confs/zsh/.zshrc"
		'';
	};

	home.file = {
		# ".zshrc".source = ./.zshrc;
		# ".config/zsh/ccomp".source = ./.zshrc;
	};
}
