{ ... }:

{
	jcbin.rebuild-system.enable = true;

	common.core =
	{
		network.wakeOn =
		{
			# lan.enabledFor = [ "eno1" "enp8s2" ];
			knownDevices.acer = "a4:17:31:10:9e:ed";
		};

		secrets = 
		{
			cloudflare = {
				origin-cert.installed = true;
				tunnel-creds."home".installed = true;
			};

			discord.hooks."foxburrow" = {
				rebuilds.installed = true;
				errors.installed = true;
			};

			nginx.vhosts."quiss.home.lan" = {
				cert = {
					installed = true;
					path = "/etc/nginx-certs/quiss_home_lan-cert.crt";
				};
				key = {
					installed = true;
					path = "/etc/nginx-certs/quiss_home_lan-cert.key";
				};
			};
		};

		ssh.cloudflared-proxy =
		{
			enable = true;
			hosts = [
				"jarvis-cf.foxburrow.org"
				"quiss-cf.foxburrow.org"
				"msi-cf.foxburrow.org"
			];
		};
	};

	system.services =
	{
		avahi.enable = true;

		nixbuilder.server = {
			enable = true;
			maxJobs = 4;
			features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
			systems = [ "x86_64-linux" "aarch64-linux" "i686-linux" "armv7l-linux" "armv6l-linux" ];
		};

		samba.enable = true;
	};
}
