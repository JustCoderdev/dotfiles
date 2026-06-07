{ pkgs, ... }:

{
	# Set your time zone.
	time.timeZone = "Europe/Rome";

	# Select internationalisation properties.
	i18n = {
		defaultLocale = "en_US.UTF-8";
		extraLocaleSettings = {
			LC_ADDRESS = "it_IT.UTF-8";
			LC_IDENTIFICATION = "it_IT.UTF-8";
			LC_MEASUREMENT = "it_IT.UTF-8";
			LC_MONETARY = "it_IT.UTF-8";
			LC_NAME = "it_IT.UTF-8";
			LC_PAPER = "it_IT.UTF-8";
			LC_TELEPHONE = "it_IT.UTF-8";
			LC_TIME = "it_IT.UTF-8";
		};

		# inputMethod = {
		# 	enable = true;
		# 	type = "fcitx5";
		# 	fcitx5.addons = with pkgs; [
		# 		fcitx5-mozc
		# 		fcitx5-gtk
		# 	];
		# };
	};

	# environment.defaultPackages = [ pkgs.kdePackages.fcitx5-configtool ];
}
