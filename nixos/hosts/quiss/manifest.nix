{
	hardware =
	{
		system = "x86_64-linux";
		type = "desktop";

		cpu.intel.architecture = "ivy-bridge";
		gpu.amd.architecture = "gcn1"; # Radeon HD 6750

		graphics =
		{
			enable = true;
			desktop-environment.enable = false;
			displays = { };
		};
	};

	# -------------------- #

}

