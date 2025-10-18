{
	hardware =
	{
		system = "x86_64-linux";
		type = "laptop";

		audio.capable = true;
		bluetooth.capable = true;

		cpu.intel = {
			architecture = "ice-lake";
			has-iGPU = true;
		};
		gpu.nvidia = {
			architecture = "maxwell";
			offload = {
				enable = true;
				intelBusId = "PCI:0:2:0";
				nvidiaBusId = "PCI:2:0:0";
			};
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
				b-ex-monitor = add-display "HDMI-1" "1920x1080" "1920x0";
			};
		};
	};

	# -------------------- #
}
