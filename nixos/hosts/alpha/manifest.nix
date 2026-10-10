{ system, type, cpu, ... }:

{
	hardware =
	{
		system = system.x86_64-linux;
		type = type.desktop;

		cpu = cpu.intel.xeon_e5530;

		audio.capable = false;
		bluetooth.capable = false;
		graphics.capable = false;

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

	software =
	{
		ssh.pubkey."ryuji" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINAr/IUoqeskTARnRlhH0vGfvBVq0auLoF46sZHZV6rd";

		syncthing =
		{
			enable = true;
			identification = "EVKQHPZ-LRN5AAK-4ZKEHAT-TCMDQTN-S5X6UMQ-OPB27GX-B3RA4GK-BTJJMA5";
		};

		wireguard."wg-server" =
		{
			enable = true;
			publicKey = "kqE1ydN54oum12jd2T8GALlqc/+5DbSDE5TOPY1+1lU=";
			self-address = "10.255.250.7";
		};
	};
}

