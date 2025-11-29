{ lib, pkgs, ... }:
{
	host = {
		has-de = lib.mkEnableOption "graphical applications";
		is-laptop = lib.mkEnableOption "laptop specific modules";
	};

	# Read only
	# -------------------- #

	icon-theme =
	{
		name = lib.mkOption {
			description = "The theme name within the package";
			type = lib.types.nullOr lib.types.str;
			default = "Adwaita:dark";
			readOnly = true;
		};
		package = lib.mkOption {
			description = "Package providing the theme";
			type = lib.types.package;
			default = pkgs.adwaita-icon-theme;
			readOnly = true;
		};
	};

	wallpapers_path = lib.mkOption {
		description = "Specify the wallpapers directory";
		type = lib.types.path;
		default = ../.wallpapers;
		readOnly = true;
	};
}
