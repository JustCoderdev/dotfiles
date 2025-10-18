{ config, lib, ... }:

{
	imports = [
		./common/core
		./common/manifest
		./common/users

		./system/desktop
		./system/dev
		./system/gaming
		./system/services

		./unofficial/modules
	];

	config = {
		documentation.nixos.enable = false;
		system.stateVersion = "23.11"; # Did you read the comment?
	};

	options.host = {
		isVM = lib.mkOption {
			type = lib.types.bool;
			description = "Is the current host a VM";
			default = false;
		};
	};
}
