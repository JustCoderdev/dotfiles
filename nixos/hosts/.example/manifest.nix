{
	hardware =
	{
		system = ""; # x86_64-linux
		type = "";   # desktop, raspi3, laptop, virtual-machine

		audio.capable = false;
		bluetooth.capable = false;

		cpu.intel.architecture = "";

		gpu.radeon.architecture = "";
		gpu.nvidia.architecture = "";

		graphics =
		{
			capable = false;
			desktop-environment.enable = false;

			displays =
			let
				add-display = identifier: resolution: position:
					{ inherit identifier resolution position; };
			in
			{
				# 0-digiquest = add-display "HDMI-0" "1920x1080" "0x0";
			};
		};
	};

	# -------------------- #
}

