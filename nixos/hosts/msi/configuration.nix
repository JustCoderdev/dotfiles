{ config, pkgs, ... }:

let
	secrets = config.common.core.secrets;
in

{
	services.mysql = {
		enable = true;
		package = pkgs.mariadb;
	};

	# Mouse support
	services.ratbagd.enable = true;
	environment.systemPackages = with pkgs; [ piper ]
	++ [ dbeaver-bin ]; # more packages support

	# TUNNEL
	
	unofficial.services.cloudflared =
	{
		enable = true;
		certificateFile = secrets.cloudflare.origin-cert.path;

		tunnels."msi-cf" =
		{
			credentialsFile = secrets.cloudflare.tunnel-creds."msi-cf".path;
			# default = "http_status:404";
			originRequest.noTLSVerify = true;
			ingress."msi-cf.foxburrow.org".service = "ssh://127.0.0.1:22";
		};
	};
}
