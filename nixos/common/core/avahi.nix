{ ... }:

{
	services.avahi =
	{
		enable = true;
		openFirewall = true;

		nssmdns4 = true;
		nssmdns6 = false;

		ipv4 = true;
		ipv6 = true;

		# wideArea = false;

		publish = {
			enable = true;
			addresses = true;
			domain = true;
			userServices = true;
		};
	};
}
