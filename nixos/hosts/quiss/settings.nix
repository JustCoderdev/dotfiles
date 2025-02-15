rec {
	hostname = "quiss";
	username = "ryuji";

	runningVM = false;

	config_path = "/home/${username}/.config";
	cache_path = "/home/${username}/.cache";

	system = "x86_64-linux";
	special_pkgs = {
		insecure = [ ];
		unfree = [
			"google-chrome"
			"obsidian"
			"anytype"
			"apple-fonts"
			"helvetica-neue-lt-std"
		];
	};
}

