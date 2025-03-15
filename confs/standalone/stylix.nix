{ config, lib, pkgs, settings, ... }:

let
	cfg = config.stylix.module;
in

{
	options.stylix.module.mode = lib.mkOption {
		type = lib.types.enum [ "nixos" "home-manager" ];
		description = "Set the stylix module mode";
		default = "nixos";
	};

	config = {
		stylix = (
			(
				lib.mkIf (cfg.mode == "home-manager")
				{
					iconTheme = {
						enable = true;
						package = pkgs.adwaita-icon-theme;
						dark = "Adawaita";
					};
				}
			)
			//
			(
				lib.mkIf (cfg.mode == "nixos")
				{
					# ...
				}
			)
			//
			{
				enable = true;

				polarity = "dark";
				base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
				image = "${settings.wallpapers_path}/space_engineers.png";

				cursor = {
					name = "Adwaita"; # breeze_cursors
					package = pkgs.adwaita-icon-theme;
					size = 24;
				};

				targets = {
					# alacritty.enable = false;
					neovim.enable = false;
					waybar.enable = false;
					firefox.profileNames = [ "${settings.username}" ];
				};

				fonts = {
					sizes = {
						applications = 14;
						terminal = 12;

						popups = 10;
						desktop = 10;
					};

					monospace = {
						name = "Roboto Mono Medium";
						package = pkgs.roboto-mono;
					};
					sansSerif = {
						name = "DejaVu Sans";
						package = pkgs.dejavu_fonts;
					};
					serif = {
						name = "DejaVu Serif";
						package = pkgs.dejavu_fonts;
					};
					
					emoji = {
						name = "IPAGothic";
						package = pkgs.ipaexfont;
					};
				};
			}
		);
	};
}
