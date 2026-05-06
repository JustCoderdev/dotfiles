{ pkgs, ... }:

let
	serial-devices = [ "ttyUSB0" "ttyUSB1" ];
in

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

	boot.kernelParams = [ ]
		++ builtins.map (dev: "console=${dev},115200n8") serial-devices
		;

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
	# systemd.services."serial-getty@".enable = false;

	# Configure our own serial-getty@ttyS0 service
	systemd.services = { "serial-getty@".enable = false; }
		// builtins.listToAttrs
		(
			builtins.map
			(
				dev:
				{
					name = "serial-getty@${dev}";
					value =
					{
						enable = true;
						wantedBy = [ "getty.target" ];
						after = [ "systemd-user-sessions.service" ];
						wants = [ "systemd-user-sessions.service" ];
						serviceConfig =
						{
							Type = "idle";
							Restart = "always";
							ExecStart = "${pkgs.util-linux}/bin/agetty --login-program ${pkgs.shadow}/bin/login --noclear --keep-baud ${dev} 115200,57600,38400,9600 vt220";
							UtmpIdentifier = dev;
							StandardInput = "tty";
							StandardOutput = "tty";
							TTYPath = "/dev/${dev}";
							TTYReset = "yes";
							TTYVHangup = "yes";
							IgnoreSIGPIPE = "no";
							SendSIGHUP = "yes";
						};
					};
				}
			)
			serial-devices
		)
		;

	# Serial
	# Source: <https://github.com/nix-community/srvos/blob/main/nixos/common/serial.nix>
	# systemd.services."serial-getty@".environment.TERM = "xterm-256color";
}
