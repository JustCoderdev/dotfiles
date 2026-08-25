{ config, lib, ... }:

let
	cfg = config.jcconfs.module.ssh;

	# Same options as in nixpkgs.programs.ssh.knownHosts
	knownHosts =
	let
		get-known-host = (
			hostname: domains: publicKey:
			rec {
				inherit publicKey;
				extraHostNames = (builtins.map (domain: "${hostname}.${domain}.lan") domains);

				# required by interface
				certAuthority = false;
				publicKeyFile = null;
				hostNames = [ hostname ] ++ extraHostNames;
			}
		);
	in
	{
		# jarvis = (get-known-host "jarvis" [ "home"                 ] "");
		quiss  = (get-known-host "quiss"  [ "home"        "garden" ] "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBQXf/BHJdFdd5JFEfrP4IdUcQPKryN8hFySvxZFwK/K");
		wise   = (get-known-host "wise"   [        "flat" "garden" ] "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOK05zx+zekMnUpJ7qog1r/yNrsMDVcDXyny1GdZGog4");
		msi    = (get-known-host "msi"    [        "flat" "garden" ] "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPUEbijsahIeiJKnYE/X25k8YjbBSmPSz2j31kOCNczd");
		# acer   = (get-known-host "acer"   [ "home"                 ] "");
		asus   = (get-known-host "asus"   [ "home" "flat" "garden" ] "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM6iFgCu/HH1IaHszu1lFvPPLGCJ+FmApHEBc3QawV1r");
	};

	knownHostsFile = builtins.toFile "user_known_hosts"
	(
		(
			lib.concatMapStringsSep "\n"
			(
				val:
				let
					cauth = lib.optionalString val.certAuthority "@cert-authority";
					names = builtins.concatStringsSep "," val.hostNames;
					pbkey = if val.publicKey != null then val.publicKey else builtins.readFile val.publicKeyFile;
				in
				"${cauth} ${names} ${pbkey}"
			)
			(builtins.attrValues knownHosts)
		)
		+ "\n"
	);
in

{
	config = lib.mkIf (cfg.enable)
	{
		programs.ssh =
		{
			enable = true;

			enableDefaultConfig = false;
			matchBlocks."*" =
			{
				forwardAgent = false;
				addKeysToAgent = "no";
				compression = false;
				serverAliveInterval = 0;
				serverAliveCountMax = 3;
				hashKnownHosts = false;
				userKnownHostsFile = "${knownHostsFile} ~/.ssh/known_hosts";
				controlMaster = "no";
				controlPath = "~/.ssh/master-%r@%n:%p";
				controlPersist = "no";
			};
		};
	};

	# ------------------------------------------------------------ #

	options.jcconfs.module.ssh =
	{
		enable = lib.mkEnableOption "ssh secure shell client custom configuration";
	};
}
