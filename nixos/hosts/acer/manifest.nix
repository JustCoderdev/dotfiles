{ system, type, cpu, ... }:

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
				laptop-monitor = add-display "VGA-1" "1366x768" "0x0";
			};
		};
	};

	# -------------------- #

	software =
	{
		ssh.pubkey =
		{
			"ryuji"               = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOGw3APe4BXlKHZ2Bdqlp+neA3GdU47Os77Ez1RA2UUa";
			"ryuji_builderclient" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDtdYGCqkhftam2/wiUb0j4jUCE4f9xb4qmIxXZmc2p3";
		};

		syncthing =
		{
			enable = true;
			identification = "VOXIJHC-LVWDIBD-N2IYZNL-FNBIN2S-NZLKIRD-F7QXVI7-HKWPGKQ-RQZOBAR";
		};

		wireguard."wg-server" =
		{
			enable = true;
			publicKey = "QpJopfGsP1eoxHJyOgQpHQZrI8iUfu0LfoEnF8zmqWU=";
			self-address = "10.255.250.6";
		};
	};
}
