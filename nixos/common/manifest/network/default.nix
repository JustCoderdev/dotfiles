{
	home =
	{
	};

	disp = 
	{
	};

	sub = 
	{
	};

	garden = 
	{
		netid = "10.255.250.0";
		mask = 24;

		lan-domain = "garden"; # garden.lan

		hosts = {
			"10.255.250.1" = {
				hostname = "msi";
				services = { };
			}
		};
	};
}

# -------------------- #

{
	interfaces = {
		wireless = {
			wlp3s0.network = garden;
		};

		ethernet = {
			eno1 = {
				network = garden;

				self-ip = "10.255.250.9";
				dhcp = true;
			};
		};

		virtual = {
			wg-server = {
				network = garden;
				self-ip = "10.255.250.9";
			};
		};
	};
}
