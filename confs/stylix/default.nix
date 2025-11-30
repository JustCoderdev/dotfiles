{ config, lib, pkgs, ... }:

let
	cfg = config.jcconfs;
in

{
	config =
	{
		stylix = lib.mkIf (cfg.host.has-de)
		{
			enable = true;
			polarity = "dark";
			image = "${cfg.wallpapers_path}/space_engineers.png";

			cursor = {
				inherit (cfg.icon-theme) package name;
				size = 18;
			};

			fonts =
			{
				sizes = {
					applications = 12;  terminal = 12;
					popups = 8;         desktop = 10;
				};

				sansSerif = { name = "Bitstream Vera Sans";  package = pkgs.ttf_bitstream_vera;  };
				serif     = { name = "Bitstream Vera Serif"; package = pkgs.ttf_bitstream_vera;  };
				monospace = { name = "Roboto Mono";          package = pkgs.roboto-mono;         };
				emoji     = { name = "Twitter Color Emoji";  package = pkgs.twitter-color-emoji; };
			};

			# base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
			base16Scheme =
			let
				getMnemonics =
				(
					palette:
					let
						inherit (palette) base00 base01 base02 base03;
						inherit (palette) base04 base05 base06 base07;
						inherit (palette) base08 base09 base0A base0B;
						inherit (palette) base0C base0D base0E base0F;
					in
					{
						bg-pri = base00; # ----   # primary   background
						bg-sec = base01; # ---    # secondary background (status bar, line number)
						bg-sel = base02; # --     # selection background
						bg-hig = base03; # -      # highlight background (comments)

						fg-sec = base04; # +      # secondary foreground (status bar)
						fg-pri = base05; # ++     # primary foreground

						fg-bri = base06; # +++    # light fg
						bg-bri = base07; # ++++   # light bg

						   red = base08; # error    # deleted
						orange = base09; # urgent
						yellow = base0A; # warning
						 green = base0B; # good     # added
						  cyan = base0C;
						  blue = base0D; # focused
						purple = base0E;
						 brown = base0F;
					}
				);


				# Themes
				# ------------------------------------------------------------ #

				gruvbox-darker-theme = {
					base00 = "#282828"; # ----
					base01 = "#3c3836"; # ---
					base02 = "#504945"; # --
					base03 = "#665c54"; # -
					base04 = "#bdae93"; # +
					base05 = "#d5c4a1"; # ++
					base06 = "#ebdbb2"; # +++
					base07 = "#fbf1c7"; # ++++
					base08 = "#e94134"; # red
					base09 = "#fe8019"; # orange
					base0A = "#fabd2f"; # yellow
					base0B = "#dce052"; # green
					base0C = "#8ec07c"; # cyan
					base0D = "#83a598"; # blue
					base0E = "#d3869b"; # purple
					base0F = "#d65d0e"; # brown
				};

				first-i3-theme =
				let
					gbox = getMnemonics gruvbox-darker-theme;
				in
				with i3-tint;
				{
					base00 = black;       # ----
					base01 = gray-dim;    # ---
					base02 = gray;        # --
					base03 = gray-bri;    # -
					base04 = white;       # +
					base05 = white;       # ++
					base06 = white;       # +++
					base07 = white;       # ++++
					base08 = red;         # red          # error
					base09 = red-bri;     # orange       # urgent
					base0A = gbox.yellow; # yellow       # warning
					base0B = green;       # green        # good
					base0C = green-bri;   # cyan
					base0D = cyan;        # blue         # focused
					base0E = gbox.purple; # purple
					base0F = gbox.brown;  # brown
				};


				# Tints
				# ------------------------------------------------------------ #

				i3-tint = {
					black     = "#1d1d1d"; # ----    # #262626
					gray-dim  = "#373b41"; # ---
					gray      = "#929293"; # --
					white     = "#ffffff"; # [++++]

					red       = "#a46060";
					red-bri   = "#fb7979";
					green     = "#527251";
					green-bri = "#bce1af";
					cyan      = "#64708d";
					cyan-bri  = "#afbee1";
				};

				jdah-tint =
				{
					black = "#1d2021";
					red   = "#fb4934";
					green = "#b8bb26";
				};

				gbox-cols = getMnemonics gruvbox-darker-theme;
			in
			{
				base00 = jdah-tint.black;   # ----
				base01 = i3-tint.gray-dim;  # ---
				base02 = i3-tint.gray;      # --
				base03 = gbox-cols.bg-hig;  # -
				base04 = gbox-cols.fg-sec;  # +
				base05 = gbox-cols.fg-pri;  # ++
				base06 = gbox-cols.fg-bri;  # +++
				base07 = gbox-cols.bg-bri;  # ++++
				base08 = jdah-tint.red;     # red      # error
				base09 = gbox-cols.orange;  # orange   # urgent
				base0A = gbox-cols.yellow;  # yellow   # warning
				base0B = i3-tint.green;     # green    # good
				base0C = gbox-cols.blue;    # cyan
				base0D = i3-tint.cyan;      # blue # focused
				base0E = gbox-cols.purple;  # purple
				base0F = gbox-cols.brown;   # brown
			};
		};
	};
}

