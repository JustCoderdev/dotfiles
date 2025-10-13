{ config, lib, pkgs, jc-lib, ... }:

let
	cfg = config.system.services.wireguard;
	secrets = config.common.core.secrets;
	wg-port = 51820;
in

{
	config = lib.mkIf (cfg.client.enable || cfg.server.enable)
	{
		networking = 
		{
			firewall.allowedUDPPorts = lib.mkIf (cfg.openFirewall) [ wg-port ];

			nat = lib.mkIf (cfg.server.enable)
			{
				enable = true;
				externalInterface = cfg.server.external-interface;
				internalInterfaces = [ cfg.server.internal-interface ];
			};

			wireguard = 
			{
				enable = true;
				interfaces = { }
				// lib.attrsets.optionalAttrs (cfg.server.enable) (
					{
						"${cfg.server.internal-interface}" = {
							ips = [ cfg.server.self-ip ];
							listenPort = wg-port;

							postSetup =    ''${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${cfg.server.tunnel-network} -o ${cfg.server.external-interface} -j MASQUERADE'';
							postShutdown = ''${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${cfg.server.tunnel-network} -o ${cfg.server.external-interface} -j MASQUERADE'';

							privateKeyFile = "${secrets.defaultPath}/wireguard/self";
							generatePrivateKeyFile = true;

							peers = []
							++ lib.attrsets.mapAttrsToList (
								name: { publicKey, ip }:
								{
									inherit name publicKey;
									allowedIPs = [ "${ip}/32" ];
								}
							) cfg.server.peers;
						};
					}
				)
				// lib.attrsets.optionalAttrs (cfg.client.enable) (
					lib.attrsets.mapAttrs' (
						name: { endpoint, publicKey, self-ip, allowed-ips }:
						{
							inherit name;
							value =
							{
								ips = [ "${self-ip}" ];
								listenPort = wg-port;

								privateKeyFile = "${secrets.defaultPath}/wireguard/self";
								generatePrivateKeyFile = true;

								peers = [ {
									inherit publicKey endpoint;
									allowedIPs = allowed-ips;
									persistentKeepalive = 25;
								} ];
							};
						}
					) cfg.client.servers
				);
			};
		};
	};

	# ------------------------------------------------------------ #

	options.system.services.wireguard =
	{
		openFirewall = lib.mkEnableOption "Open the firewall port for wireguard";

		client =
		{
			enable = lib.mkEnableOption "Enable wireguard vpn as client";
			servers = lib.mkOption {
				description = "All servers";
				default = { };
				type = lib.types.attrsOf (
					lib.types.submodule (
						{ name, ... }:
						{
							options =
							{
								endpoint = jc-lib.mkStrOption "The hostname or ip of the server (wireguard.example.com:51820)";
								publicKey = jc-lib.mkStrOption "The public key of the peer";

								self-ip = jc-lib.mkStrOption "The IP address and subnet of the client's end of the tunnel interface";
								allowed-ips = jc-lib.mkListOption "All subnets allowed to be forwarded (0.0.0.0/0)" lib.types.str;
							};
						}
					)
				);
			};
		};

		server =
		{
			enable = lib.mkEnableOption "Enable wireguard vpn as server";

			tunnel-network = jc-lib.mkStrOption "The IP address and subnet of the network tunnel";
			self-ip = jc-lib.mkStrOption "The IP address and subnet of the server's end of the tunnel interface";

			external-interface = jc-lib.mkStrOption "The external interface the server routes to";
			internal-interface = jc-lib.mkStrOption "The name of the wireguard interface of the server";

			peers = jc-lib.mkSubmodOption "All allowed peers" (
				{ name, ... }:
				{
					options = {
						publicKey = jc-lib.mkStrOption "The public key of the peer";
						ip = jc-lib.mkStrOption "The ip of the peer (127.0.0.1)";
					};
				}
			);
		};
	};
}
