rec {
	hostname = "aaaaa";
	username = "bbb";

	runningVM = false;

	config_path = "/home/${username}/.config";
	cache_path = "/home/${username}/.cache";

	system = "x86_64-linux";
	special_pkgs = {
		insecure = [ ];
		unfree = [ ];
	};
}

