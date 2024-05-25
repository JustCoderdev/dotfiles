{ ... }:

{
	imports = [ ./x11.nix ];

	services.xserver = {

		# Enable the Xfce Desktop Environment.
		desktopManager.xfce.enable = true;
		displayManager.defaultSession = "xfce";
	};
}
