{ config, lib, pkgs, settings, ... }:

with lib;
let
	username = settings.username;
	cfg = config.system.services.docker;
in

{
	config = mkIf cfg.enable {

		environment.systemPackages = [ pkgs.docker-compose ];
		virtualisation.docker = {
			enable = true;

			daemon.settings = {
				data-root = "/home/${username}/Developer/.docker/";
			};
		};

		users.users.${username}.extraGroups = [ "docker" ];
	};
}

