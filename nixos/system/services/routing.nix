# Network routing
# src <https://www.reddit.com/r/NixOS/comments/1i89lh2/comment/m8s1g8t/?context=3>

{ config, lib, jc-bin, ... }:

let
	cfg = config.system.services.routing;
in

{
	config = lib.mkIf (cfg.enable)
	{
		# Enable kernel packet forwarding
		boot.kernel.sysctl = {
			"net.ipv4.conf.all.forwarding" = true;
			"net.ipv6.conf.all.forwarding" = true;
		};

		# Check leases here
		# /var/lib/dnsmasq/dnsmasq.leases
		services.dnsmasq = lib.mkIf (cfg.dhcp.enable)
		{
			enable = true;
			resolveLocalQueries = false;
			settings =
			{
				server = config.networking.nameservers;
				inherit (cfg.subnetwork) interface;
	
				domain-needed = true;
				bogus-priv = true;
				no-resolv = true;
				cache-size = 1000;
				no-hosts = true;
	
				# dhcp
				dhcp-option = lib.mkIf (cfg.nat.enable) "option:router,${cfg.subnetwork.self-ip}";
				dhcp-range = [ "br-lan,${cfg.dhcp.range},1h" ];
				dhcp-host = [ "${config.networking.hostName},${cfg.subnetwork.self-ip}" ]
					++ builtins.map (
						{ hostname, host-mac, reserved-ip, ... }:
						"${host-mac},${hostname},${reserved-ip},infinite"
					) cfg.dhcp.reserved-leases;
			};
		};

		networking = {
			nftables.enable = true;
			firewall.trustedInterfaces = [ cfg.subnetwork.interface ];
			networkmanager.unmanaged = [ "interface-name:${cfg.subnetwork.interface}" ];
	
			# Add dns record
			hosts = { }
			// builtins.listToAttrs (
				builtins.map (
					{ hostname, domain, reserved-ip, ... }:
					{
						name = reserved-ip;
						value = [ "${hostname}.${domain}" ];
					}
				) cfg.dhcp.reserved-leases
			);
	
			nat = lib.mkIf (cfg.nat.enable) {
				enable = true;

				internalIPs = [ "${cfg.subnetwork.address}/${toString cfg.subnetwork.mask}" ];
				internalInterfaces = [ cfg.subnetwork.interface ];

				forwardPorts = cfg.nat.forwarded-ports;
				externalInterface = cfg.outnetwork.interface;
			};
	
			interfaces.${cfg.subnetwork.interface} = {
				useDHCP = false;
				ipv4.addresses = [
					{
						address = cfg.subnetwork.self-ip;
						prefixLength = cfg.subnetwork.mask;
					}
				];
			};
		};
	};

	# ------------------------------------------------------------ #

	options.system.services.routing =
	{
		enable = lib.mkEnableOption "Enable the routing service creating a subnetwork";

		outnetwork.interface = jc-bin.mkStrOption "Interface that faces the outside network";
		subnetwork =
		{
			interface = jc-bin.mkStrOption "Interface that faces the inside network"; 

			address = lib.mkOption {
				description = "The network address of the subnetwork";
				type = lib.types.str;
				example = "10.0.0.0";
			};

			mask = lib.mkOption {
				description = "The network mask of the subnetwork";
				type = lib.types.int;
				example = 24;
			};

			self-ip = lib.mkOption {
				description = "The ip of this host on the subnetwork";
				type = lib.types.str;
				example = "10.0.0.1";
			};
		};

		dhcp = {
			enable = lib.mkEnableOption "Enable a dhcp server on the subnetwork";

			range = lib.mkOption {
				description = "The range in between the dhcp server will lease ips";
				type = lib.types.str;
				example = "10.0.0.16,10.0.0.127";
			};

			reserved-leases = lib.mkOption {
				description = "The range in between the dhcp server will lease ips";
				type = lib.types.listOf (
					lib.types.submodule (
						{
							options = {
								hostname = jc-bin.mkStrOption "The hostname with the reserved lease";
								domain = jc-bin.mkStrOption "The domain of the host with the reserved lease";

								host-mac = jc-bin.mkStrOption "The mac address of the host with the reserved lease";
								reserved-ip = jc-bin.mkStrOption "The reserved ip address of the host";
							};
						}
					)
				);
				example = [
					{
						hostname = "server";
						domain = "local";
						host-mac = "aa:bb:cc:dd:ee:ff";
						reserved-ip = "10.20.30.40";
					}
				];
			};
		};

		nat = {
			enable = lib.mkEnableOption "Enable natting between subnetwork and outside network";
			forwarded-ports = lib.mkOption {
				description = "List of forwarded ports from the external interface to internal destinations by using DNAT";
				type = lib.types.listOf (
					lib.types.submodule
					(
						{
							options = {
								sourcePort = lib.mkOption {
									type = lib.types.either lib.types.int (lib.types.strMatching "[[:digit:]]+:[[:digit:]]+");
									example = 8080;
									description = "Source port of the external interface; to specify a port range, use a string with a colon (e.g. \"60000:61000\")";
								};

								destination = lib.mkOption {
									type = lib.types.str;
									example = "10.0.0.1:80";
									description = "Forward connection to destination ip:port (or [ipv6]:port); to specify a port range, use ip:start-end";
								};

								proto = lib.mkOption {
									type = lib.types.str;
									default = "tcp";
									example = "udp";
									description = "Protocol of forwarded connection";
								};

								loopbackIPs = lib.mkOption {
									type = lib.types.listOf lib.types.str;
									default = [ ];
									example = lib.literalExpression ''[ "55.1.2.3" ]'';
									description = "Public IPs for NAT reflection; for connections to `loopbackip:sourcePort` from the host itself and from other hosts behind NAT";
								};
							};
						}
					)
				);
			};
			default = [ ];
		};
	};
}
