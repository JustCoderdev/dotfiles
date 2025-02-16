{ pkgs, settings, ... }:

{
	programs.neovim = {
		enable = true;
		defaultEditor = true;
	};

#	Requirements:
#		- Clang
#		- Lua Language Server
#		- Marksman
#		- Astrojs/language-server
#		- Node
#		- Fzf

	home.packages = with pkgs; [
		xclip
		xsel
		fzf

		# Parsers
		tree-sitter
		nodejs

		# LSPs
		lua-language-server
		marksman
		nixd

		nodePackages.bash-language-server
		vscode-langservers-extracted
	];

	home.file = {
		".config/nvim/init.lua".source = ./init.lua;
		".config/nvim/lua" = {
			source = ./lua;
			recursive = true;
		};
	};
}
