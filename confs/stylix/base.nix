{ inputs, config, lib, pkgs, settings, ... }:

let
	cfg = config.stylix.module;
in

{
	config =
	{
		stylix =
		{
			enable = true && cfg.has_de;

			polarity = "dark";
			base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
			image = "${cfg.wallpapers_path}/space_engineers.png";

			cursor = {
				inherit (cfg.theme) package name;
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
	};

	# ------------------------------------------------------------ #

	options.stylix.module =
	{
		has_de = lib.mkEnableOption "Specify if a desktop environment is present";
		wallpapers_path = lib.mkOption {
			type = lib.types.path;
			description = "Specify the wallpapers directory";
		};
		theme = {
			name = lib.mkOption {
				type = lib.types.nullOr lib.types.str;
				description = "The theme name within the package";
				default = "Adwaita";
			};
			package = lib.mkOption {
				type = lib.types.package;
				description = "Package providing the theme";
				default = pkgs.adwaita-icon-theme;
			};
		};
	};
}

