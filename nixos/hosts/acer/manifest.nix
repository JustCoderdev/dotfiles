{
	hardware =
	{
		system = "x86_64-linux";
		type = "laptop";

		audio.capable = true;
		bluetooth.capable = true;

		cpu.intel = {
			architecture = "sandy-bridge";
			has-iGPU = true;
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
				laptop-monitor = add-display "VGA-1" "1920x1080" "0x0";
			};
		};
	};
}
