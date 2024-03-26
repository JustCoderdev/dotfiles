{ settings, ... }:

{
	virtualisation.docker = {
		enable = true;

		daemon.settings = {
			data-root = "~/Developer/.docker/";
		};
	};

	users.users.${settings.username}.extraGroups = [ "docker" ];
}

