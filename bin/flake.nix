# Idea from
# <https://discourse.nixos.org/t/how-to-pass-through-nixosmodules-in-flakes/18064/3>

{
	description = "JC Binary Executables";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-24.11";
	};
	
	outputs = { self, nixpkgs, ... }:
	{
		nixosModules = {
			backlight = import ./backlight/default.nix;
			rebuild-system = import ./rebuild-system/default.nix;
		};
	};
}
