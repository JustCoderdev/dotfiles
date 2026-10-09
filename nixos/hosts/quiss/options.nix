{ ... }:

{
	jcbin.update-system.enable = true;

	common.core =
	{
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

# 			nginx.vhosts."quiss.home.lan" = {
# 				cert = {
# 					installed = true;
# 					path = "/etc/nginx-certs/quiss_home_lan-cert.crt";
# 				};
# 				key = {
# 					installed = true;
# 					path = "/etc/nginx-certs/quiss_home_lan-cert.key";
# 				};
# 			};
		};

		ssh.cloudflared-proxy =
		{
			enable = true;
			hosts = [
				"jarvis-cf.foxburrow.org"
				"quiss-cf.foxburrow.org"
				"wise-cf.foxburrow.org"
				"msi-cf.foxburrow.org"
			];
		};
	};

	modules.services.nixbuilder.server = {
		enable = true;
		maxJobs = 4;
		features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
		systems = [ "x86_64-linux" "aarch64-linux" "i686-linux" "armv7l-linux" "armv6l-linux" ];
	};
}
