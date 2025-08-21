{ ... }:

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
}
