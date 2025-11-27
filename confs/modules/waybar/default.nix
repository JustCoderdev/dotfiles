{ config, ... }:

let
	inherit (config.jcconfs) has-de;

	available-in-profile = "hyprland-desktop";

	profile-enabled = lib.lists.any
		(profile: profile == available-in-profile)
		config.jcconfs.profiles;
in

{
	programs.waybar.enable = true && has-de && profile-enabled;

	home.file = lib.mkIf (profile-enabled)
	{
		".config/waybar/style.css".source = ./style.css;
		".config/waybar/colors.css".source = ./colors.css;
		".config/waybar/config.jsonc".source = ./config.jsonc;
		".config/waybar/nixos_icon.png".source = ./nixos_icon.png;
	};
}
