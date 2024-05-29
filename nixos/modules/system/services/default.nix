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
				description = "Enable docker support";
				default = false;
			};
			samba.enable = lib.mkOption {
				type = lib.types.bool;
				description = "Enable samba support";
				default = false;
			};
			virtualbox.enable = lib.mkOption {
				type = lib.types.bool;
				description = "Enable virtualbox support";
				default = false;
			};
		};
	};
}
