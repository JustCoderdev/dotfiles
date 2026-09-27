{ system, type, cpu, ... }:

{
	hardware =
	{
		system = system.aarch64-linux;
		type = type.raspi3;

		# cpu = ???;

		audio.capable = false;
		bluetooth.capable = false;
		graphics.capable = false;
	};

	# -------------------- #

	software =
	{
		ssh.pubkey =
		{
			"ryuji"               = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM6h9IvfxHJHhzP4ifsVU3FKiqOOMOdo3xjLVZbvBGRD";
			"ryuji_builderclient" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ2jmKDK7lygtwqkNqH6Y5NzYp9BwcNR8KEZzEA0m9/s";
		};
	};
}

