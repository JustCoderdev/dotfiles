{ lib, config, ... }:

let
	cfg = config.jcconfs;
in

{
	stylix =
	{
		homeManagerIntegration =
		{
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
		theme.name = cfg.icon-theme.name;
		iconTheme = cfg.icon-theme;
		cursorTheme = cfg.icon-theme;
	};
}
