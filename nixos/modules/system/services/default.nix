{ lib, ... }:

with lib;

{
	imports = [
		./docker.nix
		./samba.nix
		./virtualbox.nix
	];

	options = {
		system.services = {
			docker.enable = mkOption {
				type = types.bool;
				description = "Enable docker support";
				default = false;
			};
			samba.enable = mkOption {
				type = types.bool;
				description = "Enable samba support";
				default = false;
			};
			virtualbox.enable = mkOption {
				type = types.bool;
				description = "Enable virtualbox support";
				default = false;
			};
		};
	};
}
