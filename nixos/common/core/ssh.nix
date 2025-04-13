{ settings, ... }:

let
	hostname = settings.hostname;
	username = settings.username;
	homepath = "/home/${username}";
in

{
	# Prompt for passphrase
	programs.gnupg.agent.enable = false;
	programs.ssh = {
		# Check permissions and add keys to ssh agent
		# $ eval "$(ssh-agent -s)"
		# $ ssh-add ~/.ssh/...
		startAgent = true;

		kexAlgorithms = [
			"diffie-hellman-group1-sha1" # Needed to access C2960
		];

		knownHosts = {
			"alpha.server.local".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKfJlm+Spo7dn2bgfsikaJrm2tts4mVdzgou5+yEqg5X";
			 "beta.server.local".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA/IbY/KBg/V4ZHUoJ02/WdetpcyvqR1K1D4fD7PuJOk";
			"quiss.server.local".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOrn6ho3e3IVEKrZWsWP2hkAHt1KT2N0FHG3JnRN+I7F";

			 "msi.host.local".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDY+uqI9B48MnbNJzXlgvGSxHTuWdGy3bxMOD7UW0Dt7";
			"acer.host.local".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKhRn86zFXUmXsC7isRVu6WBa5t+eOvK+J7/niCZ/Wq/";

			"github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
		};

		# Set as default keys
		extraConfig = ''
# github
# <https://superuser.com/questions/232373/how-to-tell-git-which-private-key-to-use>
Host github.com
	HostName github.com
	IdentitiesOnly yes # Force to use only this identity file
	IdentityFile "${homepath}/.ssh/id_github_justcode"

# SSH
# <https://unix.stackexchange.com/questions/494483/specifying-an-identityfile-with-ssh>
Host *
	User ${username}
	IdentityFile "${homepath}/.ssh/id_${hostname}_${username}"
	IdentitiesOnly yes # Force to use only this identity file
'';
	};


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
}
