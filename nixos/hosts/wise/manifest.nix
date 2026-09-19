{ system, type, cpu, gpu, ... }:

{
	# <https://www.parkytowers.me.uk/thin/wyse/3040/>
	hardware =
	{
		system = system.x86_64-linux;
		type = type.desktop;

		audio.capable = false;
		bluetooth.capable = false;
		graphics.capable = false;

		cpu = cpu.intel.atom_x5-Z8350;

		interfaces.wireless."wlo1".mac = "c8:58:c0:37:fe:ce";
	};

	# -------------------- #

	software =
	{
		ssh.pubkey =
		{
			"ryuji"               = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5ceb2qO05uEyS978K4xIu6Xk+cq+VoshMS8OaxVNVC";
			"ryuji_builderclient" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOK05zx+zekMnUpJ7qog1r/yNrsMDVcDXyny1GdZGog4";
		};

		wireguard =
		{
			"wg-server" =
			{
				enable = true;
				publicKey = "F8qzOVcYphb81XE0s/AndbKYf7ZYXR4g1mCNRseSFDI=";
				self-address = "10.255.250.1";
			};

			"wg-giugio" =
			{
				enable = true;
				publicKey = "F8qzOVcYphb81XE0s/AndbKYf7ZYXR4g1mCNRseSFDI=";
				self-address = "10.255.249.1";
			};
		};
	};
}


