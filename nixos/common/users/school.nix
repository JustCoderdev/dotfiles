{ config, lib, pkgs, ... }:

let
	cfg = config.common.users.school;
	self-manifest = config.common.manifest.self;

	username = "school";
in

{
	config = lib.mkIf (cfg.enable)
	{
		jcconfs.users = [ "${username}" ];

		nix.settings.allowed-users = [ "${username}" ];

		users.users.school =
		let
			titleCase = text: lib.concatStrings [
				(lib.toUpper (builtins.substring 0 1 text))
				(builtins.substring 1 (builtins.stringLength text) text)
			];
		in
		{
			description = "${titleCase username}";
			isNormalUser = true;

			initialPassword = "${username}";

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

