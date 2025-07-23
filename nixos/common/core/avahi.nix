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

		publish = {
			enable = true;
			addresses = true;
			domain = true;
			userServices = true;
		};
	};
}
