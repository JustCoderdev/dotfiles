{ inputs, config, lib, pkgs, settings, ... }:

let
	cfg = config.stylix.module;
in

{
	options.stylix.module.wallpapers_path = lib.mkOption {
		type = lib.types.path;
		description = "Specify the wallpapers directory";
	};

	config.stylix  = {
		enable = true;

		polarity = "dark";
		base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
		image = "${cfg.wallpapers_path}/space_engineers.png";

		cursor = {
			name = "Adwaita"; # breeze_cursors
			package = pkgs.adwaita-icon-theme;
			size = 18;
		};

		fonts = {
			sizes = {
				applications = 12;  terminal = 12;
				popups = 8;         desktop = 10;
			};

			monospace = { name = "Roboto Mono Medium"; package = pkgs.roboto-mono;  };
			sansSerif = { name = "DejaVu Sans";        package = pkgs.dejavu_fonts; };
			serif     = { name = "DejaVu Serif";       package = pkgs.dejavu_fonts; };
			emoji     = { name = "IPAGothic";          package = pkgs.ipaexfont;    };
		};
	};
}

