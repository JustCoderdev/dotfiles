{ config, lib, ... }:

{
	imports =
	[
		./common/core
		./common/environments
		./common/manifest
		./common/users

		./system/desktop
		./system/services

		./unofficial/modules
	];

	config.system.stateVersion = "23.11"; # Did you read the comment?
}
