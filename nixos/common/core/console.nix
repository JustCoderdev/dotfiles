{ pkgs, ... }:

{
	# Configure console keymap
	console =
	{
		enable = true;
		useXkbConfig = true;

		# Fonts in /etc/static/kbd/consolefonts
		# font = "${pkgs.kbd}/share/consolefonts/Lat2-Terminus16.psfu.gz";
	};


	# Serial console
	# ------------------------------------------------------------ #
	# Source: <https://wiki.nixos.org/wiki/Serial_Console>

	boot.kernelParams = [ "console=ttyS0,115200n8" "console=tty1" ];

	# Enable early console output during boot
	boot.consoleLogLevel = 7;  # Show all kernel messages
	boot.initrd.verbose = true;  # Show initrd messages

	# Tell grub about serial
	boot.loader.grub.extraConfig = ''
serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1
terminal_input serial
terminal_output serial
'';

	# Disable the upstream getty module's automatic configuration for serial-getty@
	systemd.services."serial-getty@".enable = false;

	# Configure our own serial-getty@ttyS0 service
	systemd.services."serial-getty@ttyS0" =
	{
		enable = true;
		wantedBy = [ "getty.target" ];
		after = [ "systemd-user-sessions.service" ];
		wants = [ "systemd-user-sessions.service" ];
		serviceConfig =
		{
			Type = "idle";
			Restart = "always";
			ExecStart = "${pkgs.util-linux}/bin/agetty --login-program ${pkgs.shadow}/bin/login --noclear --keep-baud ttyS0 115200,57600,38400,9600 vt220";
			UtmpIdentifier = "ttyS0";
			StandardInput = "tty";
			StandardOutput = "tty";
			TTYPath = "/dev/ttyS0";
			TTYReset = "yes";
			TTYVHangup = "yes";
			IgnoreSIGPIPE = "no";
			SendSIGHUP = "yes";
		};
		environment.TERM = "xterm-256color";
	};

	# Serial
	# Source: <https://github.com/nix-community/srvos/blob/main/nixos/common/serial.nix>
	# systemd.services."serial-getty@".environment.TERM = "xterm-256color";
}
