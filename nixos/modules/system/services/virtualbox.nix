{ config, lib, settings, ... }:

with lib;
let cfg = config.system.services.virtualbox; in

{
	config = mkIf cfg.enable {
		virtualisation.virtualbox.host = {
			enable = true;
			enableExtensionPack = true;
		};

		users.users.${settings.username}.extraGroups = [ "vboxusers" ];
	};
}
