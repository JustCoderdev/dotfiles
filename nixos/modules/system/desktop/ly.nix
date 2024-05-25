{ settings, ... }:
let
	username = settings.username;
in {
	imports = [ ./x11.nix ];

	services.xserver.displayManager = {
		lightdm.enable = true;

		ly = {
			enable = false;
			defaultUser = username;
			defaultSessionIndex = 2;

			#Extra config to be added to the config.ini file
			extraConfig = "";
		};
	};
}
