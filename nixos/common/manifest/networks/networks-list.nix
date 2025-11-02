{
	home =
	{
		netid = "192.168.7.0";
		netmask = 24;
	};

	dorm = 
	{
		netid = "192.168.1.0";
		netmask = 24;
	};

	garden = 
	{
		netid = "10.255.250.0";
		netmask = 24;

		# domain-lan = "garden"; # garden.lan # defaults to name

		# hosts = {
		# 	"10.255.250.1" = {
		# 		hostname = "msi";
		# 		services = { };
		# 	}
		# };
	};
}

