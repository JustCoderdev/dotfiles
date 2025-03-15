{ config, pkgs, settings, ... }:

let
	quiss-ip  = "10.0.0.14";
	quiss-mac = "f4:6d:04:99:dc:9a";
	quiss-wake-pkg = pkgs.writeShellScriptBin "quiss-wake" "wakeonlan ${quiss-mac}";
in

{
	# Create MC Virtual Sink
	hardware.pulseaudio = {
		extraConfig = ''
pactl load-module module-null-sink sink_name=MCVirtualSink sink_properties="device.description='Minecraft\ Virtual\ Sink'"
pactl load-module module-loopback source=MCVirtualSink.monitor sink=alsa_output.pci-0000_00_1f.3.analog-stereo

# load-module module-combine-sink
# load-module module-null-sink sink_name=virtmic sink_properties=device.description=Virtual_Microphone_Sink
# load-module module-remap-source master=virtmic.monitor source_name=virtmic source_properties=device.description=Virtual_Microphone
'';
	};

	# Nvidia support
	hardware.nvidia = {
		modesetting.enable = true;

		# GPU Support for GeForce GTX 1050Ti
		package = config.boot.kernelPackages.nvidiaPackages.stable;

		# Enable this if you have graphical issues
		powerManagement.enable = false;

		# Works on modern Nvidia GPUs (Turing or newer)
		powerManagement.finegrained = false;

		# Use open source driver
		open = false;

		# Enable the Nvidia settings menu,
		nvidiaSettings = false;
	};

	# nfs support
	# <https://nixos.wiki/wiki/NFS>

	# Network settings
	networking = {

		hosts = {
			"${quiss-ip}" = [ "nixcache.local" ]; # Quiss
		};

#		# Network switching
#		bridges.br0.interfaces = [ "eno1" "v-wlp3s1" ];
#
#		interfaces.v-wlp3s1 = {
#			virtual = true;
#			virtualType = "tap"; # Layer2
#		};
#
#		interfaces.br0 = {
#			useDHCP = true;
#			ipv4.addresses = [
#				{
#					address = "10.0.0.1";
#					prefixLength = 24;
#				}
#			];
#		};
	};


	# VPN
	# WG SETUP <https://wiki.nixos.org/w/index.php?title=WireGuard&mobileaction=toggle_view_desktop>
	# P2P VPN <https://www.procustodibus.com/blog/2020/11/wireguard-point-to-point-config/>
	# networking = {
	# 	nat.internalInterfaces = [ "wg0" "eno1" ];
	# 	firewall.allowedUDPPorts = [ 51820 80 ];

	# 	wireguard = {
	# 		enable = true;
	# 		interfaces."wg0" = {

	# 			ips = [ "10.0.1.1/24" ];
	# 			listenPort = 51820;

	# 			peers = [
	# 				{ 
	# 					name = "mobile";
	# 					publicKey = "TDEa07WlhgPSQUm1Epzri8j4/+LSC8I1Suxoc9U8mWU=";
	# 					allowedIPs = [ "10.0.1.0/24" ];
	# 					persistentKeepalive = 25;
	# 				}
	# 			];

	# 			# generatePrivateKeyFile = true;
	# 			privateKeyFile = "/home/${settings.username}/.wireguard-keys/private";
	# 		};
	# 	};
	# };


	# Install setup software
	environment.systemPackages = (with pkgs; [
		piper      # Mouse software
		wakeonlan  # Wakeonlan utility

		# wireguard-tools # Wireguard tools :O
	]) ++ [
		quiss-wake-pkg  # Wakeup Quiss
	];


	# Mouse service
	services.ratbagd.enable = true;


	networking.firewall.allowedUDPPorts = [ 80 ];
	services.nginx.enable = true;
	services.nginx.virtualHosts."msi.host.local" = {
		root = "/var/www/msi";
	};


#	# Network routing
#	# src: <https://www.reddit.com/r/NixOS/comments/1i89lh2/comment/m8s1g8t/?context=3>

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

		nat = {
			enable = true;
			internalIPs = [ "10.0.0.0/24" "10.0.1.0/24" ];
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
