{ lib, ... }:

{
	imports = [
		./docker.nix
		./nixbuilder.nix
		./nixcache.nix
		./kvm.nix
		./samba.nix
		./virtualbox.nix
		./webserver.nix
	];
}
