{ system, type, cpu, gpu, ... }:

{
	hardware =
	{
		system = system.x86_64-linux;
		type   = type.laptop;

		audio.capable = true;
		bluetooth.capable = true;

		cpu = cpu.intel.celeron_887;

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

	# -------------------- #

	software =
	{
		wireguard."wg-server" =
		{
			enable = true;
			publicKey = "ulvrJVLPHQGFiAs5g6PRravcyxutnL1XP5Ne4+Egrn0=";
			self-address = "10.255.250.6";
		};
	};
}
