{ pkgs, ... }:

{
	programs.chromium.enable = true;

	home = {
		packages = with pkgs; [ dconf ];
		sessionVariables.GTK_THEME = "orchis-theme";
	};

	dconf = {
		enable = true;
		settings = {
			"org/gnome/desktop/interface" = {
				color-scheme = "prefer-dark";
			};
		};
	};

	gtk = {
		enable = true;
		theme = {
			name = "orchis-theme";
			package = pkgs.orchis-theme;
		};
		iconTheme = {
			name = "Adwaita";
			package = pkgs.adwaita-icon-theme;
		};
		cursorTheme = {
			name = "Adwaita";
			package = pkgs.adwaita-icon-theme;
		};
	};

	qt = {
		enable = true;
		platformTheme.name = "gtk";
		style.name = "gtk2";
	};
}
