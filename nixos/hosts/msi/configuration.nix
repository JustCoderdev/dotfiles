{ ... }:

{
	common = {
		core = {
			bluetooth.enable = true;
			nvidia.enable = true;

			audio = {
				pipewire.enable = false;
				pulseaudio.enable = true;
			};

			nix = {
				serve-store.enable = true;
			};
		};

		users = {
			ryuji = {
				enable = true;

				image-editing = true;
				video-editing = false;
				game-developing = false;
			};

			school.enable = true;
		};
	};

	system = {
		bin = {
			backlight.enable = false;
			rebuild-system.enable = true;
		};

		desktop = {
			xfce.enable = true;
			hyprland.enable = false;
		};

		dev = {
			enable = true;
			c.enable = true;
			arduino.enable = true;
			net.enable = false;
		};

		gaming.enable = true;
		services = {
			docker.enable = true;
			samba.enable = true;
			virtualbox.enable = false;
		};
	};

	# Network bridging
	# src: <https://www.reddit.com/r/NixOS/comments/1i89lh2/comment/m8s1g8t/?context=3>
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

			# dhcp
			dhcp-range = [ "br-lan,10.10.30.50,10.10.30.60,24h" ];
			interface = "eno1";
			dhcp-host = "10.10.30.1";

			no-hosts = true;
		};
	};

	networking = {
		nftables.enable = true;
		firewall.trustedInterfaces = [ "eno1" ];
		networkmanager.unmanaged = [ "interface-name:eno1" ];

		nat.internalIPs = [ "10.10.30.0/24" ];
		nat.externalInterface = "wlp3s0";
		nat.enable = true;

		interfaces.eno1 = {
			useDHCP = false;
			ipv4.addresses = [
				{
					address = "10.10.30.1";
					prefixLength = 24;
				}
			];
		};
	};

	# Bridge
#	networking = {
#		bridges.br0.interfaces = [ "eno1" "wlp3s0" ];
#	};
}
