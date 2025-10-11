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
					base08 = "#e94134"; # red     #fb4934
					base09 = "#fe8019"; # orange
					base0A = "#fabd2f"; # yellow
					base0B = "#dce052"; # green   #b8bb26
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

					gray_dark    = "#373b41";
					gray         = "#929293";
					gray_bright  = "#989898";

					black = "#000000";
					white = "#ffffff";

					foreground = white;
					# background = "#262626";
					background = "#1d1d1d";
				};
			in
			{
				base00 = i3-colors.background;   # ----   # default background
				base01 = i3-colors.gray_dark;    # ---    # alternative background
				base02 = i3-colors.gray;         # --     # selection background
				base03 = i3-colors.gray_bright;  # -

				base04 = i3-colors.foreground;   # +      # alternate text
				base05 = i3-colors.foreground;   # ++     # default text
				base06 = i3-colors.foreground;   # +++
				base07 = i3-colors.foreground;   # ++++

				base08 = i3-colors.red;          # red          # error
				base09 = i3-colors.red_bright;   # orange       # urgent
				base0A = "#fabd2f";              # yellow       # warning
				base0B = i3-colors.green;        # green
				base0C = i3-colors.green_bright; # cyan
				base0D = i3-colors.cyan;         # blue         # focused
				base0E = "#d3869b";              # purple
				base0F = "#d65d0e";              # brown
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

