rec {
	hostname = "quiss";
	profile = "personal";
	username = "ryuji";

	runningVM = false;

	dotfiles_path = ../../../.;
	dotfiles_abspath = "/.dotfiles";
	config_path = "/home/${username}/.config";
	cache_path = "/home/${username}/.cache";

	system = "x86_64-linux";
	special_pkgs = {
		insecure = [ ];
		unfree = [
			"obsidian"
			"anytype"
			"apple-fonts"
			"helvetica-neue-lt-std"
		];
	};
}

