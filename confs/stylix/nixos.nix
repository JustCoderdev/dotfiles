{ ... }:

{
	stylix =
	{
		homeManagerIntegration = {
			autoImport = false;
			followSystem = false;
		};

		autoEnable = true;
		targets.plymouth.enable = false;
		targets.lightdm.enable = true;
	};
}
