{ pkgs-unstable, pkgs, settings, ... }:
let
	username = settings.username;
	dotfiles = settings.dotfiles_path;

	cachepath = settings.cache_path;
	configpath = settings.config_path;
in {
	programs.emacs.enable = true;


}
