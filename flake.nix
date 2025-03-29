{
	description = "JC NixOS System flake";

	inputs = {

		nixpkgs.url = "nixpkgs/nixos-24.11";
		nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

		jcbin = {
			url = "path:./bin";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		jcconfs = {
			url = "path:./confs";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		stylix = {
			url = "github:danth/stylix/release-24.11";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nix-minecraft = {
			url = "github:Infinidoge/nix-minecraft";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# disko = {
		# 	url = "github:nix-community/disko/v1.11.0";
		# 	inputs.nixpkgs.follows = "nixpkgs";
		# };
	};

	outputs = { self, nixpkgs, nixpkgs-unstable, jcbin, jcconfs, stylix, nix-minecraft }@inputs:
	let
		dotfiles = ./.;

		darnix-overlay = (
			final: prev: { darnix-plymouth-theme = jcconfs.packages.darnix-plymouth-theme; }
		);

		lib = nixpkgs.lib;
		nixos-hardware = fetchTarball {
			url = "https://github.com/NixOS/nixos-hardware/tarball/0ed819e708af17bfc4bbc63ee080ef308a24aa42";
			sha256 = "0n83riy6j6vlsjcsjp1w704ag5db8gyd3qap0ir4gl8ffanm4kr3";
		};

		getModules = (
			settings: [
				jcbin.nixosModules.all
				jcconfs.nixosModules.home { inherit (settings) username; }
				jcconfs.nixosModules.stylix
				stylix.nixosModules.stylix
				./nixos
			]
#			++
#			(let diskopath = "${dotfiles}/nixos/hosts/${settings.hostname}/disko.nix"; in
#				lib.optionals (lib.pathExists diskopath) [
#					disko.nixosModules.disko
#					diskopath
#				]
#			)
		);

		systemBuilder = (
			hostname: system: username:
			let
				settings = {
					inherit hostname;
					inherit system;
					inherit (import ./confs/settings/${username}.nix) username dotfiles_path special_pkgs;
				};
				pkgs-unstable = import nixpkgs-unstable {
					inherit system;
					config = let spkgs = settings.special_pkgs; in {
						permittedInsecurePackages = spkgs.insecure;
						allowUnfreePredicate = pkg: builtins.elem
							(nixpkgs.lib.getName pkg) spkgs.unfree;
					};
				};
			in
			lib.nixosSystem {
				inherit system;
				specialArgs = { inherit inputs pkgs-unstable settings dotfiles darnix-overlay; };
				modules = (getModules settings) ++ [
					./nixos/hosts/${hostname}/hardware-configuration.nix
					./nixos/hosts/${hostname}/boot.nix
					./nixos/hosts/${hostname}/options.nix
					./nixos/hosts/${hostname}/configuration.nix
				];
			}
		);

		isoBuilderCD = (
			system: username:
			let
				settings = {
					hostname = "nixiso";
					inherit system;
					inherit (import ./confs/settings/${username}.nix) username dotfiles_path special_pkgs;
				};
			in
			lib.nixosSystem {
				inherit system;
				specialArgs = { inherit inputs settings dotfiles darnix-overlay; };
				modules = (getModules settings) ++ [
					({ pkgs, modulesPath, ... }: {
						imports = [
							"${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
						];

						jcbin = {
							rebuild-system.enable = true;
							mount-configs.enable = true;
						};

						# Enable SSH in the boot process.
						systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
					})
				];
			}
		);

		imgBuilderSD-raspi3 = (
			build-platform-system:
			username:
			let
				settings = {
					hostname = "niximg";
					system = "aarch64-linux";
					inherit (import ./confs/settings/${username}.nix) username dotfiles_path special_pkgs;
				};
			in
			lib.nixosSystem {
				inherit (settings) system;
				specialArgs = { inherit inputs settings dotfiles darnix-overlay; };
				modules = (getModules settings) ++
				[
					({ pkgs, modulesPath, ... }: {
						imports = [
							# "${modulesPath}/installer/sd-card/sd-image-raspberrypi.nix"
							"${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
							"${nixos-hardware}/raspberry-pi/3"
						];


						jcbin = {
							rebuild-system.enable = true;
							mount-configs.enable = true;
						};

						# Other
						sdImage.compressImage = false;
						hardware.enableRedistributableFirmware = true;

						# Enable SSH in the boot process.
						systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];

						# Reduce memory usage
						boot.tmp.cleanOnBoot = true;
						documentation.nixos.enable = false;
						swapDevices = [ { device = "/swapfile"; size = 1024; } ];

						# Enable cross compilation
						nixpkgs.config.allowUnsupportedSystem = true;
						nixpkgs.hostPlatform = { inherit (settings) system; };
						nixpkgs.buildPlatform.system = build-platform-system;
					})
				];
			}
		);


		supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
		forAllSystems = lib.genAttrs supportedSystems;
		listAllSystems = lib.lists.forEach supportedSystems;
		nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
	in

	{
		# nixos-rebuild switch --flake .#<hostname>
		nixosConfigurations =
		{
			virtualmachine = systemBuilder "virtualmachine" "x86_64-linux" "ryuji";
			msi            = systemBuilder "msi"            "x86_64-linux" "ryuji";
			acer           = systemBuilder "acer"           "x86_64-linux" "ryuji";
			quiss          = systemBuilder "quiss"          "x86_64-linux" "ryuji";
		}
		//
		builtins.listToAttrs (
			listAllSystems (
				system:
				{
					name = "iso-${system}";
					value = isoBuilderCD system "ryuji";
				}
			)
		)
		//
		builtins.listToAttrs (
			listAllSystems (
				build-platform-system:
				{
					name = "img-raspi3_build-${build-platform-system}";
					value = imgBuilderSD-raspi3 build-platform-system "ryuji";
				}
			)
		);

		# nix build
		# packages.${system} = { };

		# nix run
		apps = forAllSystems (
			system: let pkgs = nixpkgsFor.${system}; in
			{
				# test-iso-x86_64 = {
				# 	type = "app";
				# 	program = "nix-shell -p qemu --command 'qemu-system-x86_64 -enable-kvm -m 256 -cdrom result/iso/nixos-*.iso'";
				# };

				# build-img-raspi3 = {
				# 	type = "app";
				# 	program = "nix build .#nixosConfigurations.img-raspi3.config.system.build.sdImage";
				# };
			}
			# //
			# builtins.listToAttrs (
			# 	listAllSystems (
			# 		system:
			# 		{
			# 			name = "build-iso-${system}";
			# 			value = {
			# 				type = "app";
			# 				program = "nix build .#nixosConfigurations.iso-${system}.config.system.build.isoImage";
			# 			};
			# 		}
			# 	)
			# )
		);

		# nix develop
		devShell = forAllSystems (
			system: let pkgs = nixpkgsFor.${system}; in
			{
				default = pkgs.mkShell {
					shellHook = '' zsh && exit '';
					buildInputs = with pkgs; [ git vim ];
				};
			}
		);
	};
}
