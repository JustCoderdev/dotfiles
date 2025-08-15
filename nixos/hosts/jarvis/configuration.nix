{ lib, config, pkgs, ... }:

let
	secrets = config.common.core.secrets;
in

{
	# ------------------------------------------------------------ #

	# TUNNEL

	# Configure DNS on cloudflare interface
	# <https://blog.cloudflare.com/argo-tunnels-that-live-forever/>
	# <https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/routing-to-tunnel/dns/>
	unofficial.services.cloudflared =
	{
		enable = true;
		certificateFile = secrets.cloudflare.origin-cert.path;

		tunnels."jarvis-hass" =
		{
			credentialsFile = secrets.cloudflare.tunnel-creds."jarvis-hass".path;
			default = "http_status:404";

			originRequest.noTLSVerify = true;

			ingress =
			let
				create-rule = (
					subdomain: proto: port: path:
					{
						"${subdomain}.foxburrow.org" =
						{
							inherit path;
							service = "${proto}://127.0.0.1:${toString port}";
						};
					}
				);
			in
			{ }
			// (create-rule "hass" "http" 8123 ".*")
			// {};
		};
	};

	# ------------------------------------------------------------ #

	networking.hosts."192.168.1.50" = [ "display.local" ];

	networking.firewall.allowedTCPPorts = [ 80 ];
# 	services.nginx =
# 	{
# 		enable = true;
# 		virtualHosts."${proxy.host}" = let
# 			vhost-secrets = secrets.nginx.vhosts."${proxy.host}";
# 		in {
# 			locations = {
# 				"= /home".return = "301 /home/index.html";
# 				"^~ /home/" = {
# 					root = data-dir + "/homepage";
# 					index = "index.html";
# 				};
# 			};
# 
# 			# forceSSL = true;
# 			addSSL = true;
# 			sslCertificate = vhost-secrets.cert.path;
# 			sslCertificateKey = vhost-secrets.key.path;
# 		};
# 	};

	systemd.network = {
		enable = true;
		networks."enu1u1" = {
			matchConfig.Name = "enu1u1";
			address = [ "192.168.1.1/24" ];
			linkConfig.RequiredForOnline = "no";
		};
	};

	networking = {
		useDHCP = true;
		useNetworkd = true;
		networkmanager.enable = lib.mkForce false;

		wireless = {
			enable = lib.mkForce true;

			userControlled.enable = false;
			interfaces = [ "wlan0" ];

			networks."WindTower-LTE".pskRaw = "ext:windtower_lte_psk";
			secretsFile = config.common.core.secrets.wireless.path;
		};
	};


	environment.systemPackages =
	let
		usb-ports-off-pkg = pkgs.writeShellApplication {
			name = "usb-ports-off";
			runtimeInputs = [ pkgs.uhubctl ];
			text = "uhubctl -l 1-1 -p 2 -a 0";
		};
		usb-ports-on-pkg = pkgs.writeShellApplication {
			name = "usb-ports-on";
			runtimeInputs = [ pkgs.uhubctl ];
			text = "uhubctl -l 1-1 -p 2 -a 1";
		};
	in
	[
		usb-ports-off-pkg
		usb-ports-on-pkg
	];

	security.sudo = {
		enable = true;
		extraRules = [{
			groups = [ "wheel" "hass" ];
			commands =
			let
				gen-command = (name: { command = "/run/current-system/sw/bin/${name}"; options = [ "NOPASSWD" ]; });
			in
			[
				(gen-command "usb-ports-off")
				(gen-command "usb-ports-on")
			];
		}];
	};
}

