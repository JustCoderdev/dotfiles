{ settings, ... }:

{
	programs.zsh = {
		enable = true;
		completionInit = "";

		initExtra = ''
export DOT_NIXOS=1;
export DOT_FILES="/home/ryuji/.config/dotfiles"
source "''${DOT_FILES}/confs/zsh/.zshrc"
'';

# if [ -z "''${DOT_FILES:-}" ]; then
# 	echo -e "\033[31mUnknown dotfiles path\033[0m"
# 	echo -e "Set DOT_FILES environmental variable in shell"
# else
# fi

	};

	home.file = {
		# ".zshrc".source = ./.zshrc;
		# ".config/zsh/ccomp".source = ./.zshrc;
	};
}
