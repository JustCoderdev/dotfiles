{
	description = "Nix6OS flake";

	inputs.nixpkgs.url = "nixpkgs/nixos-25.11";

	outputs = { self, nixpkgs }:

	let
		lib = nixpkgs.lib;
		supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
		forAllSystems = lib.attrsets.genAttrs supportedSystems;
		nixpkgsFor = forAllSystems(system: import nixpkgs { inherit system; });
	in

	{
		# nixosModules.default =;
		packages = forAllSystems
		(
			system:
			let
				pkgs = nixpkgsFor.${system};
				image = import ./nix6OS.nix
				{
					pkgs = pkgs.pkgsStatic;
					stage-1-files = {
						init = pkgs.pkgsStatic.bash;
					};
				};
			in
			{
				default = pkgs.writeShellScriptBin "emulate-nix6os"
				(
					"${pkgs.qemu}/bin/qemu-system-x86_64"
					+ " -kernel ${image.kernel-bzimage}"
					+ " -initrd ${image.initrd}"
				);
			}
		);

		devShells = forAllSystems
		(
			system:
			let pkgs = nixpkgsFor.${system}; in
			{
				default = pkgs.mkShell {
					packages = [ self.packages.${system}.default ];
				};
			}
		);
	};
}

