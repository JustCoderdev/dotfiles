{ config, lib, settings, ... }:

let cfg = config.system.services.virtualbox; in

{
	config = lib.mkIf cfg.enable {
		virtualisation.virtualbox.host = {
			enable = true;
			enableExtensionPack = true;
		};

		users.users.${settings.username}.extraGroups = [ "vboxusers" ];
	};
}
