{ config, lib, ... }:

let
	available-in-profile = "i3-desktop";

	profile-enabled = lib.lists.any
		(profile: profile == available-in-profile)
		config.jcconfs.profiles;
in

{
	programs.git.enable = true && profile-enabled;

	home.file = lib.mkIf (profile-enabled)
	{
		".gitconfig".source = ./.gitconfig;
		".gitignore_global".source = ./.gitignore_global;
	};
}
