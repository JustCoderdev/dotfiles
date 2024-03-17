{ config, pkgs, ... }:

{
	home.username = "ryuji";
	home.homeDirectory = "/home/ryuji";

	home.packages = with pkgs; [
	  # git
	];

	home.file = {
	  # Building this configuration will create a copy of 'dotfiles/screenrc' in
	  # the Nix store. Activating the configuration will then make '~/.screenrc' a
	  # symlink to the Nix store copy.
	  # ".screenrc".source = dotfiles/screenrc;
	  ".zshrc".source = "/.dotfiles/zsh/.zshrc";
	};

	# Shell variables
	# home.sessionVariables = {
	  # EDITOR = "emacs";
	# };

	programs.zsh.enable = true;

	# Let Home Manager install and manage itself.
	programs.home-manager.enable = true;

	# This value determines the Home Manager release that your configuration is
	# compatible with. This helps avoid breakage when a new Home Manager release
	# introduces backwards incompatible changes.
	#
	# You should not change this value, even if you update Home Manager. If you do
	# want to update the value, then make sure to first check the Home Manager
	# release notes.
	home.stateVersion = "23.11"; # Please read the comment before changing.
}
