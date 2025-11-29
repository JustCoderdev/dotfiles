{ config, lib, pkgs, ... }:

let
	cfg = config.jcconfs.module.neovim;
in

{
	config = lib.mkIf (cfg.enable)
	{
		programs.neovim =
		{
			enable = true;
			defaultEditor = true;

			withRuby = false;
			withPython3 = false;

			extraPackages = with pkgs;
			[
				xclip xsel fzf git gcc
				tree-sitter # Parser

				# LSPs
				nixd # lua-language-server
				# vscode-langservers-extracted
			];

		};


		home.file =
		{
			".config/nvim/init.lua".source = ./init.lua;
			".config/nvim/lua" = {
				source = ./lua;
				recursive = true;
			};
		};
	};

	# ------------------------------------------------------------ #

	options.jcconfs.module.neovim =
	{
		enable = lib.mkEnableOption "neovim text editor custom configuration";
	};
}
