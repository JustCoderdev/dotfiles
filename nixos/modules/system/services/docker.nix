{ config, lib, settings, ... }:

with lib;
let cfg = config.system.services.docker; in

{
	config = mkIf cfg.enable {
		virtualisation.docker = {
			enable = true;

			daemon.settings = {
				data-root = "~/Developer/.docker/";
			};
		};

		users.users.${settings.username}.extraGroups = [ "docker" ];
	};
}

