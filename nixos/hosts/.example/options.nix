{ ... }:

{
	jcbin = {
		backlight.enable = false;
		boomer.enable = false;
		eep.enable = false;
		gopro-control.enable = false;
		mount-configs.enable = false;
		rebuild-system.enable = false;
		umount-configs.enable = false;
	};

	common = {
		core = {
			network.wakeOn = {
				lan.enabledFor = [ ];
				wlan.enabledFor = [ ];
				knownDevices = { };
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

	system =
	{
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
			rtmp = {
				enable = false;
				openFirewall = false;
				proxy.enable = false;
			};
			samba.enable = false;
			syncthing = 
			{
				enable = false;
				openFirewall = false;

				folders = [ ];
				devices =
				let
					add-device = (address: id: { inherit address id; });
				in
				{ };
			};
			virtualbox.enable = false;
			wireguard = {
				openFirewall = false;
				client =
				{
					enable = true;
					servers."<name>" = {
						endpoint = "<hostname>:51820";
						publicKey = "";
						self-ip = "";
						allowed-ips = [ ];
					};
				};
			};
			webserver.enable = false;
		};
	};
}
