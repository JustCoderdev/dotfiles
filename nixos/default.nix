{ config, lib, ... }:

{
	imports = [
		./common/core
		./common/users

		./system/desktop
		./system/dev
		./system/gaming
		./system/services
	];

	config = {
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
