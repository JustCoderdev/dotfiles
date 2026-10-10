{ ... }:

{
	jcbin.update-system.enable = true;

	common.core =
	{
		secrets =
		{
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
	};

	modules.services =
	{
		# samba.enable = true;

		nixbuilder.server = {
			enable = true;
			maxJobs = 4;
			features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
			systems = [ "x86_64-linux" "aarch64-linux" "i686-linux" "armv7l-linux" "armv6l-linux" ];
		};
	};
}
