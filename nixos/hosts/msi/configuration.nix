{ config, lib, pkgs, ... }:

let
	get_conf = (hostname: mac: ip: domain: { inherit hostname mac ip domain; });
	confs = {
		switch    = get_conf "switch"    "58:97:1e:94:b7:40" "10.0.0.2" "local";

		# -------------------- #

		alpha     = get_conf "alpha"     "1c:c1:de:be:c6:c4" "10.0.0.3" "server.local";
		alpha-ilo = get_conf "alpha-ilo" "1c:c1:de:be:c6:c6" "10.0.0.4" "server.local";

		beta      = get_conf "beta"      "30:8d:99:b2:88:df" "10.0.0.5" "server.local";
		beta-ilo  = get_conf "beta-ilo"  "30:8d:99:b2:88:dd" "10.0.0.6" "server.local";

		quiss     = get_conf "quiss"     "f4:6d:04:99:cb:11" "10.0.0.7" "server.local";
		jarvis    = get_conf "jarvis"    "b8:27:eb:22:44:60" "10.0.0.8" "server.local";
	};

	get_dhcp_host = ({ hostname, mac, ip, ... }: "${mac},${hostname},${ip},infinite");
in

{
	# Mouse support
	environment.systemPackages = with pkgs; [ piper libnfc ];
	services.ratbagd.enable = true;

	# Network routing
	# src: <https://www.reddit.com/r/NixOS/comments/1i89lh2/comment/m8s1g8t/?context=3>

	# Enable kernel packet forwarding
	boot.kernel.sysctl = {
		"net.ipv4.conf.all.forwarding" = true;
		"net.ipv6.conf.all.forwarding" = true;
	};

	# Check leases here
	# /var/lib/dnsmasq/dnsmasq.leases
	services.dnsmasq = {
		enable = true;
		resolveLocalQueries = false;
		settings = {
			# dns
			server = [
				"193.110.81.0" # https://www.dns0.eu/it
				"185.253.5.0"  # https://www.dns0.eu/it
			];

			domain-needed = true;
			bogus-priv = true;
			no-resolv = true;
			cache-size = 1000;

			interface = "eno1";
			no-hosts = true;

			# dhcp
			dhcp-option = "option:router,10.0.0.1";
			dhcp-range = [ "br-lan,10.0.0.16,10.0.0.127,1h" ];
			dhcp-host = [ "msi,10.0.0.1" ]
				++ lib.attrsets.mapAttrsToList (name: value: (get_dhcp_host value)) confs;
		};
	};



	networking = {
		nftables.enable = true;
		firewall.trustedInterfaces = [ "eno1" ];
		networkmanager.unmanaged = [ "interface-name:eno1" ];

		# Add dns record
		hosts = { }
		// (
			lib.attrsets.mapAttrs' (
				name: value:
				lib.attrsets.nameValuePair (value.ip) ([ "${value.hostname}.${value.domain}" ])
			) confs
		);

		# "${quiss-ip}" = [ "quiss.host.local" ];
		# "${alpha-ip}" = [ "alpha.server.local" ];
		# "${beta-ip}"  = [ "beta.server.local" ];

		nat = {
			enable = true;
			internalIPs = [ "10.0.0.0/24" ];
			internalInterfaces = [ "eno1" ];

			forwardPorts =
			[
				# SSH
				# -------------------- #
				{
					proto = "tcp";
					sourcePort = 50222;
					destination = "${confs.switch.ip}:22";
				}
				{
					proto = "tcp";
					sourcePort = 50322;
					destination = "${confs.alpha.ip}:22";
				}
				{
					proto = "tcp";
					sourcePort = 50522;
					destination = "${confs.beta.ip}:22";
				}
				{
					proto = "tcp";
					sourcePort = 50722;
					destination = "${confs.quiss.ip}:22";
				}
				{
					proto = "tcp";
					sourcePort = 50822;
					destination = "${confs.jarvis.ip}:22";
				}

				# -------------------- #

				{
					proto = "tcp";
					sourcePort = 4080;
					destination = "${confs.quiss.ip}:80";
				}
				{
					proto = "tcp";
					sourcePort = 22445;
					destination = "${confs.quiss.ip}:445";
				}
			];

			externalInterface = "wlp3s0";
		};

		interfaces.eno1 = {
			useDHCP = false;
			ipv4.addresses = [
				{
					address = "10.0.0.1";
					prefixLength = 24;
				}
			];
		};
	};
}
