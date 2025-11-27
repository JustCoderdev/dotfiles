{ config, ... }:

let
	available-in-profile = "develop-environment";

	profile-enabled = lib.lists.any
		(profile: profile == available-in-profile)
		config.jcconfs.profiles;
in

{
	programs.ssh = lib.mkIf (profile-enabled)
	{
		enable = true;
		addKeysToAgent = "yes";
	};
}
