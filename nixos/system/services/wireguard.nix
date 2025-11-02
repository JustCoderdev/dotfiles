{ config, lib, pkgs, jc-lib, ... }:

let
	cfg = config.system.services.wireguard;
	secrets = config.common.core.secrets;
	wg-default-port = 51820;

	enabled-interfaces = (
		lib.attrsets.filterAttrs
			(_: data: data.enable)
			cfg.server.interfaces
	);
in

{
	config = lib.mkIf (cfg.client.enable || cfg.server.enable)
	{
		networking =
		{
			firewall.allowedUDPPorts = lib.mkIf (cfg.server.enable && cfg.server.openFirewall)
			(
				lib.attrsets.mapAttrsToList
					(_: data: data.port)
					enabled-interfaces
			);

			nat = lib.mkIf (cfg.server.enable)
			{
				enable = true;
				externalInterface = cfg.server.external-interface;
				internalInterfaces = (
					lib.attrsets.mapAttrsToList
						(iface: _: iface)
						enabled-interfaces
				);
			};

			wireguard = 
			{
				enable = true;
				interfaces = { }
				//
				(
					builtins.mapAttrs (
						iface-name: data:
						{
							ips = [ "${data.self-address}/${data.network.mask}" ];
							listenPort = data.port;

							postSetup =    ''${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${data.network.id}/${data.network.mask} -o ${cfg.server.external-interface} -j MASQUERADE'';
							postShutdown = ''${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${data.network.id}/${data.network.mask} -o ${cfg.server.external-interface} -j MASQUERADE'';

							privateKeyFile = "${secrets.defaultPath}/wireguard/self";
							generatePrivateKeyFile = true;

							peers = []
							++ lib.attrsets.mapAttrsToList (
								name: { publicKey, address }:
								{
									inherit name publicKey;
									allowedIPs = [ "${address}/32" ];
								}
							) data.peers;
						}
					) enabled-interfaces
				)
				//
				lib.attrsets.optionalAttrs (cfg.client.enable) (
					lib.attrsets.mapAttrs' (
						name: { endpoint, port, publicKey, self-ip, allowed-ips }:
						{
							inherit name;
							value =
							{
								ips = [ "${self-ip}" ];
								listenPort = port;

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
								publicKey = jc-lib.mkStrOption "The public key of the server";
								port = lib.mkOption {
									type = lib.types.port;
									description = "port of the interface";
									default = wg-default-port;
								};
						
								self-ip = jc-lib.mkStrOption "The ip address of the peer's end of the tunnel interface";
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

			openFirewall = lib.mkEnableOption "Open the firewall port for wireguard";
			external-interface = jc-lib.mkStrOption "The external interface the server routes to";

			interfaces = jc-lib.mkSubmodOption "The interfaces of the wireguard server" (
				{ name, ... }:
				{
					options =
					{
						enable = lib.mkEnableOption "this wireguard server interface";
						port = lib.mkOption {
							type = lib.types.port;
							description = "port of the interface";
							default = wg-default-port;
						};

						network = {
							id = jc-lib.mkStrOption "The IP address of the network tunnel";
							mask = jc-lib.mkIntOption "The netmask of the network tunnel";
						};

						self-address = jc-lib.mkStrOption "The IP address of the server's end of the tunnel interface";
						peers = jc-lib.mkSubmodOption "All allowed peers" (
							{ name, ... }:
							{
								options = {
									address = jc-lib.mkStrOption "The ip address of the peer (127.0.0.1)";
									publicKey = jc-lib.mkStrOption "The public key of the peer";
								};
							}
						);
					};
				}
			);
		};
	};
}
