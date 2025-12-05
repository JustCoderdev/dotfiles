{ config, lib, pkgs, ... }:

let
	cfg = config.common.users.school;
	self-manifest = config.common.manifest.self;
in

{
	config = lib.mkIf (cfg.enable)
	{
		jcconfs.users = [ "school" ];

		users.users.school =
		{
			description = "School";
			isNormalUser = true;

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
		enable = lib.mkEnableOption "school user";
	};
}

