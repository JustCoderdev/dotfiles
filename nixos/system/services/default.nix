{ lib, ... }:

{
	imports = [
		./docker.nix
		./nixbuilder.nix
		./nixcache.nix
		./samba.nix
		./virtualbox.nix
		./webserver.nix
	];
}
