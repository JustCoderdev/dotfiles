{ config, lib, settings, ... }:

let
	inherit (settings) username;

	hostname = config.networking.hostName;

	server_cfg = config.modules.services.nixbuilder.server;
	client_cfg = config.modules.services.nixbuilder.client;

	sshkey_path = "/home/${username}/.ssh/id_${hostname}_${username}_nixbuilder";
	buildclient_user = "buildclient";
	buildclient_group = "buildclients";
in

{
	# Builders guides
	# - Distributed Builds <https://nix.dev/manual/nix/2.24/advanced-topics/distributed-builds>
	# - Nixos on ARM <https://nixos.wiki/wiki/NixOS_on_ARM#Build_your_own_image_natively>

	config = lib.mkMerge
	[
		(
			# CLIENT
			lib.mkIf (builtins.length client_cfg.builders > 0)
			{
				nix = {
					distributedBuilds = true;
					buildMachines = lib.lists.forEach client_cfg.builders (
						builder:
						{
							inherit (builder) hostName maxJobs systems;
							supportedFeatures = builder.features;
							speedFactor = builder.priority;

							protocol = "ssh"; # ssh-ng
							publicHostKey = null; # The (base64-encoded) public host key of this builder
							sshKey = sshkey_path; # private key to use to authenticate with the build machine
							sshUser = buildclient_user; # username to log into the remote host
						}
					);
				};

				services.openssh.hostKeys = [ {
					type = "ed25519";
					comment = "${username}_${buildclient_user}@${hostname}";
					path = sshkey_path;
				} ];


				# programs.ssh.matchBlocks =
				# (
				# 	builtins.listToAttrs
				# 	(
				# 		lib.lists.forEach client_cfg.Builders
				# 		(
				# 			builder:
				# 			{
				# 				name = builder.hostName;
				# 				value =
				# 				{
				# 					user = buildclient_user ;
				# 					identitiesOnly = true;
				# 					identityFile = sshkey_path;
				# 				};
				# 			}
				# 		)
				# 	)
				# );

				programs.ssh.extraConfig = lib.strings.concatStrings (
					lib.lists.forEach client_cfg.builders (
						builder:
''
Host ${builder.hostName}
	User ${buildclient_user}
	IdentitiesOnly yes
	IdentityFile "${sshkey_path}"
''
					)
				);
			}
		)

		(
			# SERVER
			lib.mkIf server_cfg.enable
			{
				boot.binfmt.emulatedSystems = lib.lists.remove (config.nixpkgs.hostPlatform.system) server_cfg.systems;
				nix.settings.trusted-users =  [ buildclient_user ];

				users.groups."${buildclient_group}" = {};
				users.users."${buildclient_user}" =
				{
					isNormalUser = true;
					createHome = false;

					group = buildclient_group;

					openssh.authorizedKeys.keys = [
						"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICCvXFlkamJe11+AXQiZ0U2LEa8xrozhvAiwhtT//O1S ryuji_buildclient@alpha"
						"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMJgN39OtOvSFiJjOOoeo/Pcr0YghSXIaykX+jX03lqH ryuji_buildclient@beta"

						# quiss key - not a client
						"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ2jmKDK7lygtwqkNqH6Y5NzYp9BwcNR8KEZzEA0m9/s ryuji_buildclient@jarvis"
						"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOK05zx+zekMnUpJ7qog1r/yNrsMDVcDXyny1GdZGog4 ryuji_buildclient@wise"

						"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEZrsLB5QXClVYmeTYNZfOoiPvsndbiAIYG9wuiIdJUz ryuji_buildclient@msi"
						"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGY2BUEKMAB6K1uEHuYy2V7k1lt2FrPH1oQ9jimRO/fS ryuji_buildclient@acer"
						"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdgiQXUALwdkdhB4gfcIABtB09Bk/Ukpt5x8LiD0D5M ryuji_buildclient@asus"
					];
				};
			}
		)
	];

	# ------------------------------------------------------------ #

	options.modules.services.nixbuilder =
	{
		server = {
			enable = lib.mkOption {
				type = lib.types.bool;
				description = "Configure this device as a nixbuilder";
				default = false;
			};
			maxJobs = lib.mkOption {
				type = lib.types.int;
				description = "The number of concurrent jobs supported by the builder";
				default = 1;
			};
			features = lib.mkOption {
				type = lib.types.listOf lib.types.str;
				description = "The features of the builder";
				default = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
			};
			systems = lib.mkOption {
				type = lib.types.listOf lib.types.str;
				description = "The systems supported by the builder";
				default = [ "x86_64-linux" "aarch64-linux" "i686-linux" "armv7l-linux" "armv6l-linux" ];
			};
		};

		client.builders = lib.mkOption {
			default = [];
			description = "Known builders that the client can offload the work to";
			type = lib.types.listOf (
				lib.types.submodule (
					{ ... }:
					{
						options = {
							hostName = lib.mkOption {
								description = "How to reach the builder";
								type = lib.types.str;
							};
							maxJobs = lib.mkOption {
								description = "The number of concurrent jobs the builder supports";
								type = lib.types.int;
								default = 1;
							};
							priority = lib.mkOption {
								description = "The computational priority of this builder";
								type = lib.types.int;
								default = 1;
							};
							features = lib.mkOption {
								description = "The features of the builder";
								type = lib.types.listOf lib.types.str;
								default = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
							};
							systems = lib.mkOption {
								description = "The systems supported by the builder";
								type = lib.types.listOf lib.types.str;
								default = [ "x86_64-linux" "aarch64-linux" "i686-linux" "armv7l-linux" "armv6l-linux" ];
							};
						};
					}
				)
			);
		};
	};
}

