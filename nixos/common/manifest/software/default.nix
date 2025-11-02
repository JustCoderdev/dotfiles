{ config, lib, ... }:

let
	manifest-cfg = config.common.manifest;
	self-manifest = manifest-cfg.self;

	self-sw = self-manifest.software;
in

{
	config =
	{
		common.manifest.services = import ./services-list.nix;
		system.services =
		{
			wireguard =
			let
				get-hosts-with-iface = (
					iface-name:
					lib.attrsets.filterAttrs
					(
						_: manifest:
						(lib.attrsets.hasAttrByPath [ iface-name ] (manifest.software.wireguard))
						&& manifest.software.wireguard.${iface-name}.enable
					)
					(manifest-cfg.hosts)
				);

				get-server-for-iface = (
					iface-name:
					builtins.elemAt
					(
						lib.attrsets.mapAttrsToList
						(
							hostname: manifest:
							manifest.software.wireguard.${iface-name}
						) (
							lib.attrsets.filterAttrs
								(_: manifest: manifest.software.wireguard.${iface-name}.is-server)
								(get-hosts-with-iface iface-name)
						)
					) 0
				);
				self-interfaces = (lib.attrsets.filterAttrs (_: value: value.enable && !value.is-server) self-sw.wireguard);
			in
			{
				server.interfaces =
				(
					builtins.mapAttrs
					(
						iface-name: manifest:
						lib.attrsets.optionalAttrs (manifest.enable)
						{
							inherit (manifest) enable network port;
							inherit (get-server-for-iface iface-name) self-address;

							peers = manifest.extraPeers //
							(
								lib.attrsets.mapAttrs
								(
									_: manifest:
									{
										inherit (manifest.software.wireguard.${iface-name}) publicKey;
										address = manifest.software.wireguard.${iface-name}.self-address;
									}
								) (get-hosts-with-iface iface-name)
							);
						}
					) (lib.attrsets.filterAttrs (_: manifest: manifest.enable) manifest-cfg.services.wireguard)
				);

				client =
				{
					enable = (lib.lists.length (lib.attrsets.mapAttrsToList (name: _: name) self-interfaces)) > 0;
					servers =
					(
						builtins.mapAttrs
						(
							iface-name: manifest:
							let
								wg-server-data =
								(
									manifest-cfg.services.wireguard.${iface-name}
									//
									config.system.services.wireguard.server.interfaces.${iface-name}
								);
							in
							{
								inherit (get-server-for-iface iface-name) publicKey;
								inherit (wg-server-data) endpoint;

								self-ip = "${manifest.self-address}/${toString wg-server-data.network.mask}";
								allowed-ips = 
								(
									lib.attrsets.mapAttrsToList
										(_: manifest: "${manifest.address}/32")
										(wg-server-data.extraPeers)
								)
								++
								(
									lib.attrsets.mapAttrsToList
										(_: manifest: "${manifest.software.wireguard.${iface-name}.self-address}/32")
										(get-hosts-with-iface iface-name)
								);
							}
						) (self-interfaces)
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
