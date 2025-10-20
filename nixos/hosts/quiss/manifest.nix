{
	hardware =
	{
		system = "x86_64-linux";
		type = "desktop";

		audio.capable = false;
		bluetooth.capable = false;

		cpu.intel.architecture = "ivy-bridge";
		gpu.radeon.architecture = "gcn-1"; # Radeon HD 6750

		graphics =
		{
			capable = true;
			desktop-environment.enable = false;

			displays = { };
		};
	};

	# -------------------- #

}

