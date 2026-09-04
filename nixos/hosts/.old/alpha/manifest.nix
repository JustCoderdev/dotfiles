{
	hardware =
	{
		system = "x86_64-linux";
		type = "desktop";

		cpu.intel.architecture = "westmere";

		interfaces =
		let
			add-to-network  = (name: ipv4: { network = { inherit name ipv4; }; dhcp.enabled = (ipv4 == null); });
			add-wireless-details = (mac-addr: wakeOnWlanEnabled: { inherit mac-addr; wakeOnWlan.enabled = wakeOnWlanEnabled; });
			add-wired-details    = (mac-addr: wakeOnLanEnabled:  { inherit mac-addr; wakeOnLan.enabled  = wakeOnLanEnabled;  });
		in
		{
			wired =
			{
				enp3s4f0 = { } // (add-wired-details "1c:c1:de:be:c6:c4" false);
				enp3s4f1 = { } // (add-wired-details "1c:c1:de:be:c6:c5" false);
			};
		};
	};

	# -------------------- #

	software = { };
}

