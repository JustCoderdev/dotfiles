{ lib, ... }:

{
	imports = [
		./docker.nix
		./samba.nix
		./virtualbox.nix
	];

	options = {
		system.services = {
			docker.enable = lib.mkOption {
				type = lib.types.bool;
				description = "Enable docker daemon";
				default = false;
			};
			samba.enable = lib.mkOption {
				type = lib.types.bool;
				description = "Enable samba daemon";
				default = false;
			};
			virtualbox.enable = lib.mkOption {
				type = lib.types.bool;
				description = "Enable virtualbox daemon";
				default = false;
			};
		};
	};
}
