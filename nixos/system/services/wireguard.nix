{ config, lib, pkgs, ... }:

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
				lib.attrsets.optionalAttrs (cfg.server.enable)
				(
					(
						builtins.mapAttrs (
							iface-name: data:
							{
								ips = [ "${data.self-address}/${toString data.network.mask}" ];
								listenPort = data.port;

								postSetup =    ''${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${data.network.id}/${toString data.network.mask} -o ${cfg.server.external-interface} -j MASQUERADE'';
								postShutdown = ''${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${data.network.id}/${toString data.network.mask} -o ${cfg.server.external-interface} -j MASQUERADE'';

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
				)
				//
				lib.attrsets.optionalAttrs (cfg.client.enable)
				(
					lib.attrsets.mapAttrs' (
						name: { endpoint, publicKey, self-ip, allowed-ips }:
						{
							inherit name;
							value =
							{
								ips = [ "${self-ip}" ];
								listenPort = endpoint.port;

								privateKeyFile = "${secrets.defaultPath}/wireguard/self";
								generatePrivateKeyFile = true;

								peers = [ {
									inherit publicKey;
									endpoint = "${endpoint.url}:${toString endpoint.port}";
									allowedIPs = allowed-ips;
									persistentKeepalive = 30;
									dynamicEndpointRefreshSeconds = 60;
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
	let
		mkStrOption = (
			description:
			lib.mkOption {
				inherit description;
				type = lib.types.str;
			}
		);
	in
	{
		client =
		{
			enable = lib.mkEnableOption "Enable wireguard vpn as client";
			servers = lib.mkOption {
				description = "All servers";
				default = { };
				type = lib.types.attrsOf (
					lib.types.submodule (
						{ ... }:
						{
							options =
							{
								publicKey = mkStrOption "The public key of the server";
								endpoint = {
									url = mkStrOption "The hostname or ip of the server (wireguard.example.com:51820)";
									port = lib.mkOption {
										type = lib.types.port;
										description = "port of the interface";
										default = wg-default-port;
									};
								};

								self-ip = mkStrOption "The ip address of the peer's end of the tunnel interface";
								allowed-ips = lib.mkOption {
									description = "All subnets allowed to be forwarded (0.0.0.0/0)";
									type = lib.types.listOf lib.types.str;
									default = [];
								};
							};
						}
					)
				);
			};
		};

		server =
		let
			mkSubmodOption = (
				description: submodule:
				lib.mkOption {
					inherit description;
					type = lib.types.attrsOf (lib.types.submodule (submodule));
					default = { };
				}
			);
		in
		{
			enable = lib.mkEnableOption "Enable wireguard vpn as server";

			openFirewall = lib.mkEnableOption "Open the firewall port for wireguard";
			external-interface = lib.mkOption {
				description = "The external interface the server routes to";
				type = lib.types.str;
			};

			interfaces = mkSubmodOption "The interfaces of the wireguard server" (
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

						# TODO: Add checks
						network = {
							id = lib.mkOption {
								description = "The IP address of the network tunnel";
								type = lib.types.str;
							};

							mask = lib.mkOption {
								description = "The netmask of the network tunnel";
								type = lib.types.int;
							};
						};

						self-address = lib.mkOption {
							description = "The IP address of the server's end of the tunnel interface";
							type = lib.types.str;
						};
						peers = mkSubmodOption "All allowed peers" (
							{ name, ... }:
							{
								options =
								{
									address = lib.mkOption {
										description = "The ip address of the peer (127.0.0.1)";
										type = lib.types.str;
									};

									publicKey = lib.mkOption {
										description = "The public key of the peer";
										type = lib.types.str;
									};
								};
							}
						);
					};
				}
			);
		};
	};
}
