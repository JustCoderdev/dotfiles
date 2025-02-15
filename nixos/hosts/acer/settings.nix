rec {
	hostname = "acer";
	username = "ryuji";

	runningVM = false;

	config_path = "/home/${username}/.config";
	cache_path = "/home/${username}/.cache";

	system = "x86_64-linux";
	special_pkgs = {
		unfree = [
			"obsidian"
			"anytype"
			"google-chrome"
			"helvetica-neue-lt-std"
			"apple-fonts"
			"improved-tube"
			"ciscoPacketTracer8"
		];
		insecure = [ "electron-24.8.6" ];
	};
}

