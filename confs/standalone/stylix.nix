{ pkgs, settings, wallpapers_path, ... }:

{
	stylix = {
		enable = true;

		polarity = "dark";
		base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
		image = "${wallpapers_path}/space_engineers.png";

		iconTheme = {
			enable = true;
			package = pkgs.adwaita-icon-theme;
			dark = "Adawaita";
		};

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
	};
}
