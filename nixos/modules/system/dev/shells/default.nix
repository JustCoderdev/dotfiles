{ inputs, lib, settings, ... }:

let
	callDevelop = lib.callPackageWith ({
		inherit inputs settings;
	});
in
{
	c = callDevelop ./c.nix {};
}
