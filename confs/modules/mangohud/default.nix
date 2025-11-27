{ config, ... }:

let
	available-in-profile = "game-environment";

	profile-enabled = lib.lists.any
		(profile: profile == available-in-profile)
		config.jcconfs.profiles;
in

{
	home.file = lib.mkIf (profile-enabled)
	{
		".config/MangoHud/MangoHud.conf".source = ./MangoHud.conf;
	};
}
