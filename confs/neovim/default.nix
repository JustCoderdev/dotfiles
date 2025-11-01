{ pkgs, settings, ... }:

{
	programs.neovim = {
		enable = true;
		defaultEditor = true;

		withRuby = false;
		withPython3 = false;
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
		# lua-language-server
		# marksman
		# nodePackages.bash-language-server
		# vscode-langservers-extracted
		nixd
	];

	home.file = {
		".config/nvim/init.lua".source = ./old/init.lua;
		".config/nvim/lua" = {
			source = ./old/lua;
			recursive = true;
		};
	};
}
