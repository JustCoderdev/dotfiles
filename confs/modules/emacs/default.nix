{ config, ... }:

let
	available-in-profile = "develop-environment";

	profile-enabled = lib.lists.any
		(profile: profile == available-in-profile)
		config.jcconfs.profiles;
in

{
	programs.emacs.enable = true && profile-enabled;

	home.file = lib.mkIf (profile-enabled)
	{
		".emacs".source = ./.emacs;
		".emacs.custom.el".source = ./.emacs.custom.el;
		".emacs.extra" = {
			source = ./.emacs.extra;
			recursive = true;
		};
	};
}
