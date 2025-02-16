{ ... }:

{
	imports = [
		./common/core
		./common/users

		./system/desktop
		./system/dev
		./system/gaming
		./system/services
	];

	system.stateVersion = "23.11"; # Did you read the comment?
}
