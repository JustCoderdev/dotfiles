# Alacritty config from jdah, thanks man <3
# source <https://github.com/jdah/dotfiles>

{ config, lib, ... }:

let
	inherit (config.jcconfs) has-de;

	available-in-profile = "hyprland-desktop";

	profile-enabled = lib.lists.any
		(profile: profile == available-in-profile)
		config.jcconfs.profiles;
in

{
	programs.alacritty.enable = true && has-de && profile-enabled;

	home.file = lib.mkIf (profile-enabled)
	{
		".config/alacritty/alacritty.toml".source = ./alacritty.toml;
	};
}
