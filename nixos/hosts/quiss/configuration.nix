{ settings, ... }:

{
	imports = [
		../../modules/unofficial/duckdns.nix
	];

	services.duckdns = {
		enable = true;
		domains = [ "thefoxburrow" ];
		tokenFile = settings.dotfiles_abspath + "/nixos/secrets/duckdns.token";
	};

	networking.firewall.allowedTCPPorts = [ 8080 ];
}
