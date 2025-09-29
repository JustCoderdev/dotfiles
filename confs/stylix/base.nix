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
			image = "${cfg.wallpapers_path}/space_engineers.png";

			# base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
			base16Scheme =
			let
				gruvbox-darker = {
					base00 = "#282828"; # ----
					base01 = "#3c3836"; # ---
					base02 = "#504945"; # --
					base03 = "#665c54"; # -
					base04 = "#bdae93"; # +
					base05 = "#d5c4a1"; # ++
					base06 = "#ebdbb2"; # +++
					base07 = "#fbf1c7"; # ++++
					base08 = "#fb4934"; # red
					base09 = "#fe8019"; # orange
					base0A = "#fabd2f"; # yellow
					base0B = "#b8bb26"; # green
					base0C = "#8ec07c"; # aqua/cyan
					base0D = "#83a598"; # blue
					base0E = "#d3869b"; # purple
					base0F = "#d65d0e"; # brown
				};

				i3-colors = rec {
					cyan_bright  = "#afbee1";
					cyan         = "#64708d";

					green_bright = "#bce1af";
					green        = "#527251";

					red_bright   = "#fb7979";
					red          = "#a46060";

					gray         = "#989898";
					gray_bright  = "#0f0a0f";

					black = "#373b41";
					white = "#ffffff";

					foreground = white;
					background = "#262626";

					nil = "#000000";
				};
			in
			{
				base00 = i3-colors.nil;         # ----         # background
				base01 = i3-colors.background;  # ---
				base02 = i3-colors.black;       # --
				base03 = i3-colors.gray;        # -            # separator, unfocused

				base04 = i3-colors.gray_bright; # +
				base05 = i3-colors.foreground;  # ++           # text
				base06 = i3-colors.white;       # +++
				base07 = i3-colors.white;       # ++++

				base08 = i3-colors.red;         # red          # urgent
				base09 = i3-colors.red_bright;  # orange
				base0A = "#fabd2f";             # yellow
				base0B = i3-colors.cyan;        # green        # indicator
				base0C = i3-colors.cyan;        # aqua/cyan
				base0D = i3-colors.cyan;        # blue         #focused
				base0E = "#d3869b";             # purple
				base0F = "#d65d0e";             # brown
			};

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
				default = "Adwaita:dark";
			};
			package = lib.mkOption {
				type = lib.types.package;
				description = "Package providing the theme";
				default = pkgs.adwaita-icon-theme;
			};
		};
	};
}

