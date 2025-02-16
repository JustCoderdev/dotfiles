{ ... }:

{
	programs.zsh = {
		enable = true;
		completionInit = "";

		# Import configuration from dotfiles
		initExtra = ''
			export DOT_NIXOS=1;
			export DOT_FILES="/.dotfiles"
			# export LD_LIBRARY_PATH=/lib64:$LD_LIBRARY_PATH;
			source "''${DOT_FILES}/zsh/.zshrc";
		'';
	};

	# home.file.".zshrc".source = ./.zshrc;
}
