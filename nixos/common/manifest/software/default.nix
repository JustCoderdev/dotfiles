{ config, lib, ... }:

let
	manifest-cfg = config.common.manifest;
	self-sw = manifest-cfg.self.software;
in

{
	config =
	{
		common.manifest.services = import ./services-list.nix;

		modules.services =
		{
			wireguard =
			let
				get-hosts-with-iface = (
					iface-name:
					lib.attrsets.filterAttrs (
						_: host-manifest:
						(lib.attrsets.hasAttrByPath [ iface-name ] (host-manifest.software.wireguard))
						&& host-manifest.software.wireguard.${iface-name}.enable
					) manifest-cfg.hosts
				);

				self-client-interfaces = (
					lib.attrsets.filterAttrs (
						iface-name: iface:
						iface.enable &&
						manifest-cfg.self.hostname != manifest-cfg.services.wireguard.${iface-name}.server-hostname
					) self-sw.wireguard
				);
			in
			{
				server.interfaces =
				(
					builtins.mapAttrs
					(
						iface-name: iface:
						let
							iface-data = manifest-cfg.services.wireguard.${iface-name};
						in
						{
							inherit (iface) enable self-address;
							inherit (iface-data) network;
							inherit (iface-data.endpoint) port;

							peers = iface-data.extraPeers //
							(
								lib.attrsets.mapAttrs
								(
									_: manifest:
									let
										iface = manifest.software.wireguard.${iface-name};
									in
									{
										inherit (iface) publicKey;
										address = iface.self-address;
									}
								) (get-hosts-with-iface iface-name)
							);
						}
					) (lib.attrsets.filterAttrs (_: iface: iface.enable) self-sw.wireguard)
				);

				client =
				{
					enable = (builtins.length (builtins.attrValues self-client-interfaces)) > 0;
					servers =
					(
						builtins.mapAttrs
						(
							iface-name: iface:
							let
								iface-data = manifest-cfg.services.wireguard.${iface-name};
								server-iface = manifest-cfg.hosts.${iface-data.server-hostname}.software.wireguard.${iface-name};
							in
							{
								inherit (server-iface) publicKey;
								inherit (iface-data) endpoint;

								self-ip = "${iface.self-address}/${toString iface-data.network.mask}";
								allowed-ips =
								(
									lib.attrsets.mapAttrsToList
										(_: manifest: "${manifest.address}/32")
										(iface-data.extraPeers)
								)
								++
								(
									lib.attrsets.mapAttrsToList
										(_: manifest: "${manifest.software.wireguard.${iface-name}.self-address}/32")
										(get-hosts-with-iface iface-name)
								);
							}
						) (self-client-interfaces)
					);
				};
			};
		};
	};
}

# pubkeys
#	ryuji
#		ssh
#		wireguard
#		nixcache

# running services
#	nix builder
#	nix cache



# {
# 	software =
# 	{
# 		keys = {
# 			"buildclient" = {
# 				nixbuilder = "";
# 				nixcache = "";
# 			};
# 			"ryuji" = {
# 				wireguard.server."wg-server" = "";
# 				ssh = "";
# 			};
# 		};
# 	};
# }
