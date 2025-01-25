{ settings, ... }:

let
	hostname = settings.hostname;
	username = settings.username;
	homepath = "/home/${hostname}";
in

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
			PermitRootLogin = "no";
			X11Forwarding = true;
			UsePAM = true;

			PasswordAuthentication = true;
			UseDns = false;
		};

		# Generate missing keys
		hostKeys = [
			{
				type = "ed25519";
				comment = "107036402+JustCoderdev@users.noreply.github.com";
				path = "${homepath}/.ssh/id_github_justcode";
			}
			{
				type = "ed25519";
				comment = "${username}@${hostname}";
				path = "${homepath}/.ssh/id_${hostname}_${username}";
			}
		];
	};

	# Set public authKey
	# needs `PasswordAuthentication = false`
	users.users.${username}.openssh.authorizedKeys.keys = [
 		# msi
		# ""

		# acer
		# ""

		# server-cat
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO6h5xWAlFFP3J0mcjUGQGaW+fKIi441VXPif3PuzTTT"
	];
}
