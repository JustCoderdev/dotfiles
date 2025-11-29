{ config, lib, ... }:

let
	available-in-profile = "develop-environment";

	profile-enabled = lib.lists.any
		(profile: profile == available-in-profile)
		config.jcconfs.profiles;
in

{
	programs.tmux.enable = true && profile-enabled;

	# ------------------------------------------------------------ #

	options.jcconfs.module.tmux =
	{
		enable = lib.mkEnableOption "waybar wayland navbar custom configuration";
	};
}
