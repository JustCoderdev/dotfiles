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

	# Create new ssh key
	# ssh-keygen \
	#	-t ed25519 -C "107036402+JustCoderdev@users.noreply.github.com" \
	#	-f ~/.ssh/id_github_justcode
	# <enter passphrase>
	# ssh-add ~/.ssh/id_github_justcode

	# Set public authKey
	# needs `PasswordAuthentication = false`
	users.users.${settings.username}.openssh.authorizedKeys.keys = [
		# "" # msi
	];
}
