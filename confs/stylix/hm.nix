{ pkgs, settings, ... }:

{
	stylix = {
		iconTheme = {
			enable = true;
			package = pkgs.adwaita-icon-theme;
			dark = "Adawaita";
		};

		targets = {
			alacritty.enable = false;
			neovim.enable = false;
			waybar.enable = false;
			firefox.profileNames = [ "${settings.username}" ];
		};
	};
}
