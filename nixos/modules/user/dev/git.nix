{ settings, ... }:
let
	username = settings.username;
	dotfiles = settings.dotfiles_path;
in {
	programs.git = {
		enable = true;
	};

#	home.file = let
#		gitpath = "${dotfiles}/git";
#		homepath = "/home/${username}";
#	in {
#		"${homepath}/.gitconfig".source = "${gitpath}/.gitconfig";
#		"${homepath}/.gitignore_global".source = "${gitpath}/.gitignore_global";
#	};
}
