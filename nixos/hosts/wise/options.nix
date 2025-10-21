{ ... }:

{
	jcbin.rebuild-system.enable = true;

	common = {
		core = {
			network.wakeOn = {
				lan.enabledFor = [ "enp1s0" ];
				knownDevices.msi = "d4:3b:04:51:45:28";
			};

			secrets = {
				cloudflare.origin-cert.installed = true;
				discord.hooks."foxburrow".rebuilds.installed = true;
			};

			ssh.cloudflared-proxy = {
				enable = true;
				hosts = [
					"jarvis.foxburrow.org"
					"quiss.foxburrow.org"
				];
			};
		};

		users =
		{
			ryuji.enable = true;
			neko-agent.enable = true;
			hass-agent.enable = false;
		};
	};

	system = {
		services = {
			nixbuilder.client.builders =
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
				(gen-builder "10.0.0.1" 6)
				(gen-builder "192.168.1.5" 6)
			];
			nixcache = {
				enable = true;
				instance-host = "10.0.0.1";
			};
		};
	};
}
