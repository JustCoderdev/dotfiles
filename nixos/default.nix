{ config, lib, ... }:

{
	imports =
	[
		./common/core
		./common/environments
		./common/hardware
		./common/manifest
		./common/users

		./modules/desktop
		./modules/services

		./unofficial/modules
	];

	config.system.stateVersion = "23.11"; # Did you read the comment?
}
