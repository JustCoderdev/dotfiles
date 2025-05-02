{ lib, config, pkgs, settings, ... }:

let
	cfg = config.common.core.ssh;
	secrets = config.common.core.secrets;

	hostname = settings.hostname;
	username = settings.username;
	homepath = "/home/${username}";
in

{
	disabledModules = [ "services/networking/cloudflared.nix" ];
	imports = [ 
		# "${unstable-path}/nixos/modules/services/networking/cloudflared.nix"
		../../unofficial/cloudflared.nix
	];

	# ------------------------------------------------------------ #

	config =
	{
		# Prompt for passphrase
		programs.gnupg.agent.enable = false;
		programs.ssh =
		{
			# Check permissions and add keys to ssh agent
			# $ eval "$(ssh-agent -s)"
			# $ ssh-add ~/.ssh/...
			startAgent = true;

			# knownHosts = {
			# 	"switch.local".publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDO+9uie4nmHjCRgYbn8s1WeLj/jSKotEO08cZ6j2ZUffkOeTOh2e+1AAB+NYMDeF/q96K/dbHWT/Ip2W2p0CjNHcVlixIToKrd8UqD6mUmp7JE5/S1h9P1wZPKS3zbe3fyJ2sA+8ALucbWdYBlZyWU0ZWji5dzFTa0GFi976d8hj1oNbBCZBiajWzayUJeNhVCxPytLBAAodJuTgieAJ8K3wPX0q7Pf0Mz3JPetmMbt/wTkQU4cems8we0d8bkXbox3EW/TUQx7i2GF+xs3E+Q7C7SqjyzhUnDK4UWIO8SbGYmvsKIJEmyix7O21a0Y/5tEm0RXS1TcFp1wg4WIejP";

			# 	"alpha.server.local".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKfJlm+Spo7dn2bgfsikaJrm2tts4mVdzgou5+yEqg5X";
			# 	 "beta.server.local".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA/IbY/KBg/V4ZHUoJ02/WdetpcyvqR1K1D4fD7PuJOk";
			# 	"quiss.server.local".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOrn6ho3e3IVEKrZWsWP2hkAHt1KT2N0FHG3JnRN+I7F";

			# 	 "msi.host.local".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDY+uqI9B48MnbNJzXlgvGSxHTuWdGy3bxMOD7UW0Dt7";
			# 	"acer.host.local".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKhRn86zFXUmXsC7isRVu6WBa5t+eOvK+J7/niCZ/Wq/";

			# 	"github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
			# };

			# Set default keys
			extraConfig = ''
# github
# <https://superuser.com/questions/232373/how-to-tell-git-which-private-key-to-use>
Host github.com
	HostName github.com
	IdentitiesOnly yes # Force to use only this identity file
	IdentityFile "${homepath}/.ssh/id_github_justcode"

# Ryuji
# <https://unix.stackexchange.com/questions/494483/specifying-an-identityfile-with-ssh>
Host *
	User ${username}
	IdentityFile "${homepath}/.ssh/id_${hostname}_${username}"
	IdentitiesOnly no
''
			+
			lib.strings.optionalString (cfg.cloudflared-proxy.enable) (
				builtins.concatStringsSep "\n" (
					lib.lists.forEach (cfg.cloudflared-proxy.hosts) (
						host:
						''
# Cloudflared proxy
# <https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/use-cases/ssh/ssh-cloudflared-authentication/>
Host ${host}
	ProxyCommand ${pkgs.cloudflared}/bin/cloudflared access ssh --hostname %h
''
					)
				)
			);

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

		unofficial.services.cloudflared =
		{
			enable = lib.mkDefault cfg.cloudflared-proxy.enable;
			certificateFile = secrets.cloudflare.origin-cert.path;
		};

		# -------------------- #

		assertions = lib.lists.optionals (cfg.cloudflared-proxy.enable) ([ {
			message = "Cloudflared proxy is enabled for ssh but the origin certificate is not installed or it's path is null";
			assertion = secrets.cloudflare.origin-cert.installed == true
						&& secrets.cloudflare.origin-cert.path != null;
		} ]);
	};

	# ------------------------------------------------------------ #

	options.common.core.ssh =
	{
		cloudflared-proxy =
		{
			enable = lib.mkEnableOption "Enable cloudflared as an ssh proxy";
			hosts = lib.mkOption {
				type = lib.types.listOf lib.types.str;
				description = "Hosts that are going to use the cloudflare proxy";
				default = [ ];
			};
		};
	};
}
