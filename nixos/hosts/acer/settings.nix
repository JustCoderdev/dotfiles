rec {
	hostname = "acer";
	profile = "personal";
	username = "ryuji";

	runningVM = false;

	dotfiles_path = ../../../.;
	dotfiles_abspath = "/.dotfiles";
	config_path = "/home/${username}/.config";
	cache_path = "/home/${username}/.cache";

	system = "x86_64-linux";
	special_pkgs = {
		unfree = [
			"obsidian"
			"google-chrome"
			"helvetica-neue-lt-std"
			"apple-fonts"
			"improved-tube"
		];
		insecure = [ "electron-24.8.6" ];
	};
}

