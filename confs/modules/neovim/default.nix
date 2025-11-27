{ config, pkgs, ... }:

let
	available-in-profile = "develop-environment";

	profile-enabled = lib.lists.any
		(profile: profile == available-in-profile)
		config.jcconfs.profiles;
in

{
	programs.neovim = lib.mkIf (profile-enabled)
	{
		enable = true;
		defaultEditor = true;

		withRuby = false;
		withPython3 = false;
	};

	home.packages = lib.mkIf (profile-enabled)
	(
		with pkgs;
		[
			xclip xsel fzf git

			# Parsers
			tree-sitter

			# LSPs
			nixd # lua-language-server
			# vscode-langservers-extracted
		]
	);

	home.file = lib.mkIf (profile-enabled)
	{
		".config/nvim/init.lua".source = ./old/init.lua;
		".config/nvim/lua" = {
			source = ./old/lua;
			recursive = true;
		};
	};
}
