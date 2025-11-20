{ config, lib, pkgs, ... }:

let
	cfg = config.common.users.school;
	self-manifest = config.common.manifest.self;
in

{
	config = lib.mkIf (cfg.enable)
	{
		users.users.school =
		{
			description = "School";

			isNormalUser = true;
			createHome = true;
			initialPassword = "school";

			packages = with pkgs; []
			++ lib.lists.optionals (self-manifest.hardware.graphics.desktop-environment.enable)
			(
				[
					google-chrome
					obsidian vlc emulsion
				]
			);
		};
	};

	# ------------------------------------------------------------ #

	options.common.users.school =
	{
		enable = lib.mkEnableOption "ryuji school user" // { default = true; };
	};
}

