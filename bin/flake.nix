# Idea from
# <https://discourse.nixos.org/t/how-to-pass-through-nixosmodules-in-flakes/18064/3>

{
	description = "JC Binary Executables";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-24.11";
	};
	
	outputs = { self, nixpkgs, ... }:
	let
		modules = [
			"backlight"
			"mount-configs"
			"rebuild-system"
		];

		lib = nixpkgs.lib;

		toPathList = (ms: lib.lists.forEach ms (m: ./${m}/default.nix));
		toAttrsSet = (ms: lib.attrsets.genAttrs ms (m: import ./${m}/default.nix));
	in
	{
		nixosModules = (toAttrsSet modules) // {
			all = { ... }: { imports = toPathList modules; };
		};
	};
}
