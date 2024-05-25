{ pkgs, ... }:

let
	cshell = import ./c.nix { inherit pkgs; };
in {
	default = cshell;
	c = cshell;
}
