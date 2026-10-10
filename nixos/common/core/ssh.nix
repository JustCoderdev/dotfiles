{ config, settings, ... }:

let
	inherit (settings) username;

	uhome = "/home/${username}";
	hostname = config.networking.hostName;
in

{
	config =
	{
		services.gnome.gcr-ssh-agent.enable = false; # this or sshAgent
		services.openssh =
		{
			enable = true;
			openFirewall = true;

			settings =
			{
				PermitRootLogin = "no";
				Banner = builtins.toFile "sshd-banner" "You are accessing ${hostname}, one of _my_ devices. DO NOT TOUCH\n";

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
					path = "${uhome}/.ssh/id_github_justcode";
				}
				{
					type = "ed25519";
					comment = "${username}@${hostname}";
					path = "${uhome}/.ssh/id_${hostname}_${username}";
				}
			];
		};

		# TODO: move to user stuff
		programs.gnupg.agent.enable = false; # Prompt for passphrase
		programs.ssh =
		{
			startAgent = true;

			# TODO: Add woking `knownHosts`

			extraConfig = ''
# github
# <https://superuser.com/questions/232373/how-to-tell-git-which-private-key-to-use>
Host github.com
	HostName github.com
	IdentitiesOnly yes # Force to use only this identity file
	IdentityFile "${uhome}/.ssh/id_github_justcode"

Host tangled.org
	HostName tangled.org
	IdentitiesOnly yes # Force to use only this identity file
	IdentityFile "${uhome}/.ssh/id_github_justcode"

# Ryuji
# <https://unix.stackexchange.com/questions/494483/specifying-an-identityfile-with-ssh>
Host *
	User ${username}
	IdentityFile "${uhome}/.ssh/id_${hostname}_${username}"
	IdentitiesOnly no
'';

			# Options are ordered following
			# 	`man ssh_config`

			# Available `ssh -Q key`
			hostKeyAlgorithms =
			[
				# sshd defaults as of 2025-04-13
				"ssh-ed25519-cert-v01@openssh.com"
				"ecdsa-sha2-nistp256-cert-v01@openssh.com"
				"ecdsa-sha2-nistp384-cert-v01@openssh.com"
				"ecdsa-sha2-nistp521-cert-v01@openssh.com"
				"sk-ssh-ed25519-cert-v01@openssh.com"
				"sk-ecdsa-sha2-nistp256-cert-v01@openssh.com"
				"rsa-sha2-512-cert-v01@openssh.com"
				"rsa-sha2-256-cert-v01@openssh.com"
				"ssh-ed25519"
				"ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521"
				"sk-ecdsa-sha2-nistp256@openssh.com"
				"sk-ssh-ed25519@openssh.com"
				"rsa-sha2-512,rsa-sha2-256"

				# Needed to access C2960
				"ssh-rsa"
			];

			# Available `ssh -Q key`
			ciphers =
			[
				# sshd defaults as of 2025-04-13
				"chacha20-poly1305@openssh.com"
				"aes128-ctr,aes192-ctr"  "aes256-ctr"
				"aes128-gcm@openssh.com" "aes256-gcm@openssh.com"

				# Needed to access C2960
				"aes128-cbc" "3des-cbc"
				"aes192-cbc" "aes256-cbc"
			];

			# Available `ssh -Q kex`
			kexAlgorithms =
			[
				# sshd defaults as of 2025-04-13
				"sntrup761x25519-sha512,sntrup761x25519-sha512@openssh.com"
				"mlkem768x25519-sha256"
				"curve25519-sha256,curve25519-sha256@libssh.org"
				"ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521"
				"diffie-hellman-group-exchange-sha256"
				"diffie-hellman-group16-sha512"
				"diffie-hellman-group18-sha512"
				"diffie-hellman-group14-sha256"

				# Needed to access C2960
				"diffie-hellman-group1-sha1"
			];
		};
	};
}
