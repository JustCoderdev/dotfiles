{ pkgs, ... }:

let
	quiss-mac = "f4:6d:04:99:cb:11";
	quiss-ip  = "10.0.0.2";

	alpha-mac = "1c:c1:de:be:c6:c4";
	alpha-ip  = "10.0.0.5";

	beta-mac  = "30:8d:99:b2:88:df";
	beta-ip   = "10.0.0.65";
in

{
	# Mouse support
	environment.systemPackages = with pkgs; [ piper ];
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
			dhcp-range = [ "br-lan,10.0.0.3,10.0.0.127,1h" ];
			dhcp-host = [
				"msi,10.0.0.1"
				"${quiss-mac},quiss,infinite"  # 10.0.0.2
				"${alpha-mac},alpha,infinite"  # 10.0.0.5
				"${beta-mac},beta,infinite"  # 10.0.0.65
			];
		};
	};



	networking = {
		nftables.enable = true;
		firewall.trustedInterfaces = [ "eno1" ];
		networkmanager.unmanaged = [ "interface-name:eno1" ];

		# Add dns record
		hosts = {
			"${quiss-ip}" = [ "quiss.host.local" ];
			"${alpha-ip}" = [ "alpha.server.local" ];
			"${beta-ip}"  = [ "beta.server.local" ];
		};

		nat = {
			enable = true;
			internalIPs = [ "10.0.0.0/24" ];
			internalInterfaces = [ "eno1" ];

			forwardPorts = [
				{ # 10.0.0.2:22 >>#<< 192.168.7.142:52222
					proto = "tcp";
					sourcePort = 52222;
					destination = "${quiss-ip}:22";
				}
				{ # 10.0.0.5:22 >>#<< 192.168.7.142:50522
					proto = "tcp";
					sourcePort = 50522;
					destination = "${alpha-ip}:22";
				}
				{ # 10.0.0.65:22 >>#<< 192.168.7.142:56522
					proto = "tcp";
					sourcePort = 56522;
					destination = "${beta-ip}:22";
				}
				
				# -------------------- #

				{ # 10.0.0.11:80 >>#<< 192.168.7.142:4080
					proto = "tcp";
					sourcePort = 4080;
					destination = "${quiss-ip}:80";
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
