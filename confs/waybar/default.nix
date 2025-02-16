{ ... }:

{
	programs.waybar.enable = true;

	home.file = {
		".config/waybar/style.css".source = ./style.css;
		".config/waybar/colors.css".source = ./colors.css;
		".config/waybar/config.jsonc".source = ./config.jsonc;
		".config/waybar/nixos_icon.png".source = ./nixos_icon.png;
	};
}
