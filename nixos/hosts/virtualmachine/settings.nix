rec {
	hostname = "virtualmachine";
	profile = "personal";
	username = "ryuji";

	runningVM = true;

	dotfiles_path = ../../../.;
	dotfiles_abspath = "/.dotfiles";
	config_path = "/home/${username}/.config";
	cache_path = "/home/${username}/.cache";

	system = "x86_64-linux";
	special_pkgs = {
		insecure = [
			"electron-24.8.6"
			"python-2.7.18.6"
		];
		unfree = [
			"nvidia-x11"
			"nvidia-settings"
			"google-chrome"
			"obsidian"
			"discord"
			"steam"
			"steam-run"
			"steam-original"
			"davinci-resolve"
			"helvetica-neue-lt-std"
			"apple-fonts"
		];
	};
}
