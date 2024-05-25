{ settings, ... }:
let
	username = settings.username;
in {
	imports = [ ./x11.nix ];

	services.xserver.displayManager = {
		lightdm.enable = false;

		ly = {
			enable = true;
			defaultUser = username;
			defaultSessionIndex = 2;

			#Extra config to be added to the config.ini file
			extraConfig = "";
		};
	};
}
