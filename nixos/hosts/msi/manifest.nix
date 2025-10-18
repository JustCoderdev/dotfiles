{
	hardware =
	{
		system = "x86_64-linux";
		type = "desktop";

		audio.capable = true;
		bluetooth.capable = true;

		cpu.intel.architecture = "coffee-lake";
		gpu.nvidia.architecture = "pascal";

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
				a0-digiquest = add-display "hdmi-0" "1920x1080" "0x0";
				a1-digiquest = add-display "hdmi-1" "1920x1080" "0x0";
				b0-asus =      add-display "dp-0"   "1920x1080" "1920x0";
				b1-asus =      add-display "dp-1"   "1920x1080" "1920x0";
			};
		};
	};

	# -------------------- #
}
