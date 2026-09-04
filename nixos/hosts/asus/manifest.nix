{ system, type, cpu, gpu, ... }:

{
	hardware =
	{
		system = system.x86_64-linux;
		type = type.laptop;

		audio.capable = true;
		bluetooth.capable = true;

		cpu = cpu.intel.core_i5-1035G1;
		gpu = gpu.nvidia.geforce-mx130;
		gpu_offload =
		{
			enable = true;
			intelBusId = "PCI:0:2:0";
			nvidiaBusId = "PCI:2:0:0";
		};

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
				a-ig-monitor = add-display "eDP-1"  "1920x1080" "0x0";
				b-ex-monitor = add-display "HDMI-1" "1920x1080" "-1920x0";
			};
		};

		interfaces.wireless."wlo1".mac = "c8:58:c0:37:fe:ce";
	};

	# -------------------- #

	software =
	{
		wireguard =
		{
			"wg-server" =
			{
				enable = true;
				publicKey = "2KrNqM7coD0YRs9ggk+s2PmEwrH/6tuS5BwP+GS4T2w=";
				self-address = "10.255.250.4";
			};
		};
	};
}
