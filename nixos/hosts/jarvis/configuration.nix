{ lib, config, pkgs, ... }:

let
	secrets = config.common.core.secrets;
	usb-pkgs-data =
	let
		write-usb-app = (
			name: text:
			{
				inherit name;
				pkg = pkgs.writeShellApplication {
					inherit name text;
					runtimeInputs = [ pkgs.uhubctl ];
				};
			}
		);
	in
	[
		(write-usb-app "usb-ports-off" "uhubctl -l 1-1 -p 2 -a 0")
		(write-usb-app "usb-ports-on"  "uhubctl -l 1-1 -p 2 -a 1")
	];
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
		networkmanager.enable = lib.mkForce false;

		wireless = {
			enable = lib.mkForce true;

			userControlled.enable = false;
			interfaces = [ "wlan0" ];

			networks."WindTower-LTE".pskRaw = "ext:windtower_lte_psk";
			secretsFile = config.common.core.secrets.wireless.path;
		};
	};

	environment.systemPackages = [] ++ (
		builtins.map (pkg-data: pkg-data.pkg) usb-pkgs-data
	);
	security.sudo = {
		enable = true;
		extraRules = [{
			groups = [ "wheel" "hass" ];
			commands = builtins.map (
				pkg-data: { command = "${pkg-data.pkg}/bin/${pkg-data.name}"; options = [ "NOPASSWD" ]; }
			) usb-pkgs-data;
		}];
	};
}
