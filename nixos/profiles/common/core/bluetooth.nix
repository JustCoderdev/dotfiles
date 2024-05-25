{ ... }:

{
	# Enable bluetooth
	hardware.bluetooth = {
		enable = true;

		settings.General.Experimental = true;
	};

	# Bluetooth GUI
	services.blueman.enable = true;
}
