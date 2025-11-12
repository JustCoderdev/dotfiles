{ pkgs, ... }:

{
	services.mysql = {
		enable = true;
		package = pkgs.mariadb;
	};

	system.desktop = {
		hyprland.enable = true;
		i3.enable = false;
	};
}
