{
	description = "JC NixOS System flake";

	inputs = {

		nixpkgs.url = "nixpkgs/nixos-24.11";
		# nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

		jcbin = {
			url = "path:./bin";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		jcconfs = {
			url = "path:./confs";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# disko = {
		# 	url = "github:nix-community/disko/v1.11.0";
		# 	inputs.nixpkgs.follows = "nixpkgs";
		# };
	};

	outputs = { self, nixpkgs, jcbin, jcconfs }@inputs:
	let
		dotfiles = ./.;

		darnix-overlay = (
			final: prev: { darnix-plymouth-theme = jcconfs.packages.darnix-plymouth-theme; }
		);

		lib = nixpkgs.lib;

		getModules = (
			settings: [
				jcbin.nixosModules.all
				jcconfs.nixosModules.home { inherit (settings) username; }
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
			in
			lib.nixosSystem {
				inherit system;
				specialArgs = { inherit inputs settings dotfiles darnix-overlay; };
				modules = (getModules settings) ++ [
					./nixos/hosts/${hostname}/hardware-configuration.nix
					./nixos/hosts/${hostname}/boot.nix
					./nixos/hosts/${hostname}/options.nix
					./nixos/hosts/${hostname}/configuration.nix
				];
			}
		);

		isoBuilder = (
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

						# Enable SSH in the boot process.
						systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
						services.openssh.settings.PermitRootLogin = lib.mkForce "yes";
						nixpkgs.hostPlatform = system;
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
		nixosConfigurations = {
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
					# build using
					# nix build .#nixosConfigurations.iso-${SYSTEM}.config.system.build.isoImage
					name = "iso-${system}";
					value = isoBuilder system "ryuji";
				}
			)
		);

		# nix build
		# packages.${system} = { };

		# nix run
		apps = forAllSystems (
			system: let pkgs = nixpkgsFor.${system}; in
			{
				# install = {
				# 	type = "app";
				# 	program = "...";
				# };
				test-iso-x86_64 = {
					type = "app";
					program = "nix-shell -p qemu --command 'qemu-system-x86_64 -enable-kvm -m 256 -cdrom result/iso/nixos-*.iso'";
				};
			}
			//
			builtins.listToAttrs (
				listAllSystems (
					system:
					{
						name = "build-iso-${system}";
						value = {
							type = "app";
							program = "nix build .#nixosConfigurations.iso-${system}.config.system.build.isoImage";
						};
					}
				)
			)
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
