{ config, ... }:

let
	cfg-sty = config.stylix;
	cfg = config.stylix.module;
in

{
	stylix =
	{
		homeManagerIntegration = {
			autoImport = false;
			followSystem = false;
		};

		autoEnable = true;

		targets =
		{
			plymouth.enable = false;

			lightdm = {
				enable = true;
				useWallpaper = true;
			};
			grub = {
				enable = true;
				useWallpaper = true;
			};
		};
	};

	services.xserver.displayManager.lightdm.greeters.gtk =
	{
		inherit (cfg) theme;
		cursorTheme = cfg-sty.cursor;
		iconTheme = { inherit (cfg.theme) package name; };
	};
}
