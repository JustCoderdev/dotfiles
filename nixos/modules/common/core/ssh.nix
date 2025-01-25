{ settings, ... }:

{
	# Some programs need SUID wrappers, can be configured
	# further or are started in user sessions.
	# programs.mtr.enable = true;
	programs.gnupg.agent = {
		enable = true;
	 	enableSSHSupport = true;
	};

	# Enable the OpenSSH daemon.
	services.openssh = {
		enable = true;
		banner = "My computer, please don't touch it :(";

		openFirewall = true;
		settings = {
			PasswordAuthentication = true;
			PermitRootLogin = "no";
			X11Forwarding = true;
			# KbdInteractinveAuthentication = false;
		};
	};

	# Set public authKey
	# needs `PasswordAuthentication = false`
	users.users.${settings.username}.openssh.authorizedKeys.keys = [
 		# msi
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID5kTMGWCKE1lY/oDaaur4Wegt93PDFYrM3TQO9Qoprk 107036402+JustCoderdev@users.noreply.github.com"

		# acer
		# ""
	];
}
