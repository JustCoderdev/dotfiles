{ system, type, cpu, gpu, ... }:

{
	hardware =
	{
		system = system.x86_64-linux;
		type = type.desktop;

		audio.capable = true;
		bluetooth.capable = true;

		cpu = cpu.intel.core_i5-8400;
		gpu = gpu.nvidia.gtx-1050-ti;

		graphics =
		{
			capable = true;
			desktop-environment.enable = true;

			displays =
			let
				add-display = identifier: resolution: position:
					{ inherit identifier resolution position; };
			in
			{
				a0-digiquest = add-display "HDMI-0" "1920x1080" "0x0";
				a1-digiquest = add-display "HDMI-1" "1920x1080" "0x0";
				b0-asus =      add-display "DP-0"   "1920x1080" "1920x0";
				b1-asus =      add-display "DP-1"   "1920x1080" "1920x0";
			};
		};

		interfaces =
		let
			add-to-network  = (name: ipv4: { network = { inherit name ipv4; }; dhcp.enabled = (ipv4 == null); });
			add-wireless-details = (mac-addr: wakeOnWlanEnabled: { inherit mac-addr; wakeOnWlan.enabled = wakeOnWlanEnabled; });
			add-wired-details    = (mac-addr: wakeOnLanEnabled:  { inherit mac-addr; wakeOnLan.enabled  = wakeOnLanEnabled;  });
		in
		{
			wired =
			{
				eno1   = { } // (add-wired-details "" false);
				wlp3s0 = { } // (add-wired-details "" false);
			};

			wireless.wlo1 = { }
				// (add-wireless-details "d4:3b:04:51:45:28" false)
				// (add-to-network "flat" "192.168.1.5")
				;

			virtual.wireguard.wg-server.network =
			{
				name = "garden";
				publicKey = "FHDRB/hzK85kTPMDJH6IZTRakcy3tl8Qy9vLG7/JujQ=";
				self-address = "10.255.250.5";
			};
		};
	};

	# -------------------- #

	software =
	{
		wireguard."wg-server" =
		{
			enable = true;
			publicKey = "FHDRB/hzK85kTPMDJH6IZTRakcy3tl8Qy9vLG7/JujQ=";
			self-address = "10.255.250.5";
		};
	};
}
