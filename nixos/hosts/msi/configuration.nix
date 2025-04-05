{ pkgs, ... }:

let
	quiss-mac = "f4:6d:04:99:dc:9a";
	quiss-ip  = "10.0.0.14";
in

{
	boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

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
			dhcp-range = [ "br-lan,10.0.0.2,10.0.0.14,1h" ];
			dhcp-host = [
				"msi,10.0.0.1"
				"${quiss-mac},quiss,infinite"
			];
		};
	};



	networking = {
		nftables.enable = true;
		firewall.trustedInterfaces = [ "eno1" ];
		networkmanager.unmanaged = [ "interface-name:eno1" ];

		# Add dns record
		hosts."${quiss-ip}" = [ "quiss.host.local" ];

		nat = {
			enable = true;
			internalIPs = [ "10.0.0.0/24" ];
			internalInterfaces = [ "eno1" ];

			forwardPorts = [
				{ # 10.0.0.11:22 >>#<< 192.168.7.142:4022
					proto = "tcp";
					sourcePort = 4022;
					destination = "${quiss-ip}:22";
				}

				{ # 10.0.0.11:80 >>#<< 192.168.7.142:4080
					proto = "tcp";
					sourcePort = 4080;
					destination = "${quiss-ip}:80";
				}

				{ # 10.0.0.11:443 >>#<< 192.168.7.142:4443
					proto = "tcp";
					sourcePort = 4443;
					destination = "${quiss-ip}:443";
				}


				{ # 10.0.0.12:8123 >>#<< 192.168.7.142:8123
					proto = "tcp";
					sourcePort = 8123;
					destination = "10.0.0.12:8123";
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
