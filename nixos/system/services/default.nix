{ lib, ... }:

{
	imports = [
		./docker.nix
		./immich.nix
		./jellyfin.nix
		./nixbuilder.nix
		./nixcache.nix
		./kvm.nix
		./samba.nix
		./servarr.nix
		./virtualbox.nix
		./webserver.nix
	];
}
