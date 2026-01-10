{ lib, config, pkgs, settings, ... }:

let
	inherit (settings) username;

	cfg = config.common.core.ssh;
	secrets = config.common.core.secrets;

	uhome = "/home/${username}";
	hostname = config.networking.hostName;
in

{
	config =
	{
		# Prompt for passphrase
		programs.gnupg.agent.enable = false;
		programs.ssh =
		{
			startAgent = true;

			# TODO: Check why it doesn't work
			# knownHosts."github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
			knownHosts =
			let
				get-known-host = (
					hostname: domains: publicKey:
					{
						inherit publicKey;
						extraHostNames = (builtins.map (domain: "${hostname}.${domain}.lan") domains);
					}
				);
			in
			{
				jarvis = (get-known-host "jarvis" [ "home"                 ] "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM6h9IvfxHJHhzP4ifsVU3FKiqOOMOdo3xjLVZbvBGRD");
				quiss  = (get-known-host "quiss"  [ "home"        "garden" ] "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL01mLMcme/rAl5VbJYM+dpaHm4XH3eKYgchzJ3eGsKi");
				wise   = (get-known-host "wise"   [        "flat" "garden" ] "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5ceb2qO05uEyS978K4xIu6Xk+cq+VoshMS8OaxVNVC");

				msi    = (get-known-host "msi"    [        "flat" "garden" ] "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDY+uqI9B48MnbNJzXlgvGSxHTuWdGy3bxMOD7UW0Dt7");
				acer   = (get-known-host "acer"   [ "home"                 ] "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKhRn86zFXUmXsC7isRVu6WBa5t+eOvK+J7/niCZ/Wq/");
				asus   = (get-known-host "asus"   [ "home" "flat" "garden" ] "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILN9Ijk0y+p2Ewngw3ZIV8v0YuGkLTLA7jJXX6aYiC7D");

				iphone-tp-2_0 = (get-known-host "iphone-tp-2_0" [ ] "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDshsbcBThxrbEKPzmv5L+S3C6TtD7Yb0KFmK6p98lFFuaWG0ATjUneBPOLa8+bjXcKrQtnfC9S6XpOQLgw3NqHxqeFTHRskgn8kIMEnsTmnTJf3G/+bIQsiBT3othh11tVadyPCUZ0K0/uN5zCqEIYXoFWy0ydHeoeE0f+3ZtWhv9megUZTBxPJWJcaVzyrPuMd1imzZiwdcSTCqtar0TjfU3s9YAJ4F06PZZ/zGNTPI4lUyXwFwHVWJj6j9tK5NVJam2rRpRVOpXY7w4PpmAMT88Uc4lrSBz1QuGCrmzajz57VbzxTxbPvjTwwXvTy/AmVFA2xvYxO4yzVWv+aFiFJsWCUaSCLu1qN/t6Xj3Hkl/jHzBkhnqXvn/xWmoje0IxTjt/WkbuPCuPtwu9vlAhYv+OT4khKopZmwBm0hdTZImFIrmT6QowWGb+7kkCRmicLxHScGDFhFSM4Dgs4qGN6B6yiUU70fTJn/5pKgM2F6KxfdqYeIFU1RnqtcC3vc=");
			};

			# Set default keys
			extraConfig = ''
# github
# <https://superuser.com/questions/232373/how-to-tell-git-which-private-key-to-use>
Host github.com
	HostName github.com
	IdentitiesOnly yes # Force to use only this identity file
	IdentityFile "${uhome}/.ssh/id_github_justcode"

# Ryuji
# <https://unix.stackexchange.com/questions/494483/specifying-an-identityfile-with-ssh>
Host *
	User ${username}
	IdentityFile "${uhome}/.ssh/id_${hostname}_${username}"
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
		services.openssh =
		{
			enable = true;
			openFirewall = true;

			banner = ''
You are accessing ${hostname}, one of my devices. DO NOT TOUCH
'';

			settings =
			{
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
					path = "${uhome}/.ssh/id_github_justcode";
				}
				{
					type = "ed25519";
					comment = "${username}@${hostname}";
					path = "${uhome}/.ssh/id_${hostname}_${username}";
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
			enable = lib.mkEnableOption "cloudflared ssh proxy";
			hosts = lib.mkOption {
				type = lib.types.listOf lib.types.str;
				description = "Hosts that are going to use the cloudflare proxy";
				default = [ ];
			};
		};
	};
}
