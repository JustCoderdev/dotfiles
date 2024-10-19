rec {
	hostname = "msi";
	profile = "personal";
	username = "ryuji";

	runningVM = false;

	dotfiles_path = ../../../.;
	dotfiles_abspath = "/.dotfiles";
	config_path = "/home/${username}/.config";
	cache_path = "/home/${username}/.cache";

	system = "x86_64-linux";
	special_pkgs = {
		insecure = [ "electron-24.8.6" "python-2.7.18.6"  ];
		unfree = [
			"nvidia-x11"
			"nvidia-settings"

			"helvetica-neue-lt-std"
			"apple-fonts"

			"steam"
			"steam-original"
			"steam-run"
			"steamcmd"

			"Oracle_VM_VirtualBox_Extension_Pack"

			"modrinth-app-unwrapped"
			"modrinth-app"

			"unityhub"

			"obsidian"
			"google-chrome"
			"improved-tube"
			"davinci-resolve"
			"discord"
		];
	};
}

