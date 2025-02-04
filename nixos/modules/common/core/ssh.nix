{ settings, ... }:

let
	hostname = settings.hostname;
	username = settings.username;
	homepath = "/home/${username}";
in

{
	# Prompt for passphrase
	programs.gnupg.agent.enable = false;
	programs.ssh.startAgent = true;

	# Enable the OpenSSH daemon.
	services.openssh = {
		enable = true;
		openFirewall = true;

		banner = ''
			You are accessing ${hostname}, one of my computers. DO NOT TOUCH
		'';

		settings = {
			PermitRootLogin = "no";

			UsePAM = true;
			X11Forwarding = true;

			KbdInteractiveAuthentication = false;
			PasswordAuthentication = false;

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
	users.users.${username}.openssh.authorizedKeys.keys =
	[
		# msi
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDY+uqI9B48MnbNJzXlgvGSxHTuWdGy3bxMOD7UW0Dt7 ryuji@msi"

		# acer
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKhRn86zFXUmXsC7isRVu6WBa5t+eOvK+J7/niCZ/Wq/ ryuji@acer"

		# server-cat
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO6h5xWAlFFP3J0mcjUGQGaW+fKIi441VXPif3PuzTTT"
	];
}
