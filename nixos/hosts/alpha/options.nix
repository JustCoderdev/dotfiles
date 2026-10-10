{ ... }:

{
	jcbin.update-system.enable = true;

	common.core.secrets =
	{
		nginx.vhosts."alpha.home.lan" = {
			cert = {
				installed = true;
				path = "/etc/nginx-certs/alpha_home_lan-cert.crt";
			};
			key = {
				installed = true;
				path = "/etc/nginx-certs/alpha_home_lan-cert.key";
			};
		};
	};

	modules.services =
	{
		samba.enable = true;

		nixbuilder.server =
		{
			enable = true;
			maxJobs = 8;
		};
	};
}
