{ config, pkgs, ... }:

{
	# Create MC Virtual Sink
	hardware.pulseaudio = {
		extraConfig = ''
pactl load-module module-null-sink sink_name=MCVirtualSink sink_properties="device.description='Minecraft\ Virtual\ Sink'"
pactl load-module module-loopback source=MCVirtualSink.monitor sink=alsa_output.pci-0000_00_1f.3.analog-stereo

#					load-module module-combine-sink
#					load-module module-null-sink sink_name=virtmic sink_properties=device.description=Virtual_Microphone_Sink
#					load-module module-remap-source master=virtmic.monitor source_name=virtmic source_properties=device.description=Virtual_Microphone
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

	# Network settings
	networking = {

		hosts = {
			"10.0.0.11"   = [ "nixcache.local" ]; # Quiss
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

	# Install setup software
	environment.systemPackages = with pkgs; [
		piper   # Mouse software
	];

	# Mouse service
	services.ratbagd.enable = true;



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

			# dhcp
			dhcp-range = [ "br-lan,10.0.0.2,10.0.0.14,1h" ];
			dhcp-host = [
				"msi,10.0.0.1"
				"f4:6d:04:99:dc:9a,quiss,infinite"
			];
			dhcp-option = "option:router,10.0.0.1";

			interface = "eno1";
			no-hosts = true;
		};
	};

	networking = {
		nftables.enable = true;
		firewall.trustedInterfaces = [ "eno1" ];
		networkmanager.unmanaged = [ "interface-name:eno1" ];

		nat = {
			enable = true;
			internalIPs = [ "10.0.0.0/28" ];
			internalInterfaces = [ "eno1" ];

			forwardPorts = [
				{ # 10.0.0.11:22 >>#<< 192.168.7.142:4022
					proto = "tcp";
					sourcePort = 4022;
					destination = "10.0.0.11:22";
				}

				{ # 10.0.0.11:80 >>#<< 192.168.7.142:4080
					proto = "tcp";
					sourcePort = 4080;
					destination = "10.0.0.11:80";
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
