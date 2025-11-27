{ config, ... }:

let
	available-in-profile = "develop-environment";

	profile-enabled = lib.lists.any
		(profile: profile == available-in-profile)
		config.jcconfs.profiles;
in

{
	programs.zsh = lib.mkIf (profile-enabled)
	{
		enable = true;
		completionInit = "";

		initContent = ''
export DOT_NIXOS=1;
export DOT_FILES="/home/$${USER}/.config/dotfiles"
source "''${DOT_FILES}/confs/modules/zsh/.zshrc"
'';
	};
}
