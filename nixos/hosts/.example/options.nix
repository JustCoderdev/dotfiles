{ ... }:

{
	host.isVM = false;

	jcbin = {
		backlight.enable = false;
		boomer.enable = false;
		mount-configs.enable = false;
		rebuild-system.enable = false;
		umount-configs.enable = false;
	};

	jcconfs.has_de = false;

	common = {
		core = {
			bluetooth.enable = false;
			hardware = {
				cpu = {
					manufacturer = null;
					architecture = null;
					has-iGPU = false;
				};
				gpu = {
					manufacturer = null;
					architecture = null;
					offload = {
						enable = false;
						intelBusId = "PCI:0:X:0";
						nvidiaBusId = "PCI:X:0:0";
					};
				};
				displays =
				let
					add-display = identifier: resolution: position:
						{ inherit identifier resolution position; };
				in
				{
					# Check all displays with xrandr
					display = add-display "HDMI-0" "1920x1080" "0x0";
				};
			};

			network.wakeOn = {
				lan.enabledFor = [ ];
				wlan.enabledFor = [ ];
				knownDevices = { };
			};

			audio = {
				pipewire.enable = false;
				pulseaudio.enable = false;
			};

			plymouth.enable = false;
			ssh.cloudflared-proxy = {
				enable = false;
				hosts = [ ];
			};
		};

		users = {
			ryuji = {
				enable = true;

				docs-editing = false;
				image-editing = false;
				video-editing = false;
				game-developing = false;
			};

			neko-agent.enable = true;
			hass-agent.enable = true;
		};
	};

	system = {
		desktop = {
			hyprland.enable = false;
			i3.enable = false;
			thunar.enable = false;
			xfce.enable = false;
		};

		dev = {
			android.enable = false;
			arduino.enable = false;
			c.enable = false;
			net.enable = false;
		};

		gaming.enable = false;

		services = {
			docker.enable = false;
			nixbuilder = {
				server.enable = false;
				client.builders =
				let
					gen-builder = (
						hostName: maxJobs:
						{
							inherit hostName maxJobs;
							features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
							systems = [ "x86_64-linux" "aarch64-linux" "i686-linux" "armv7l-linux" "armv6l-linux" ];
						}
					);
				in
				[
					(gen-builder "msi.host.local" 6)
				];
			};
			nixcache = {
				enable = false;
				instance-host = "msi.host.local";
			};
			routing =
			{
				enable = false;
				outnetwork.interface = "";
				subnetwork = {
					interface = "";
					address = "";
					mask = 0;
					self-ip = "";
				};
				dhcp = {
					enable = false;
					range = ""; 
					reserved-leases = [];
				};
				nat = {
					enable = false;
					forwarded-ports = [];
				};
			};
			samba.enable = false;
			virtualbox.enable = false;
			webserver.enable = false;
		};
	};
}
