{ system, type, cpu, gpu, ... }:

{
	hardware =
	{
		system = system.x86_64-linux;
		type = ;  # type.<type>; # type: desktop, raspi3, laptop, virtual-machine

		audio.capable = false;
		bluetooth.capable = false;

		cpu = ; # cpu.<manufacturer>.<model>;
	};

	# -------------------- #
}

