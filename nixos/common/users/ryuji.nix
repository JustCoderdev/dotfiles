{ config, lib, pkgs, settings, ... }:

let
	cfg = config.common.users.ryuji;
	titleCase = text: lib.concatStrings [
		(lib.toUpper (builtins.substring 0 1 text))
		(builtins.substring 1 (builtins.stringLength text) text)
	];

	uname = settings.username;
in

{
	config = lib.mkIf cfg.enable {
		# NixOS (Generation 96 Nixos Uakari hyprland-24.05 (Linux 6.6), built on 2024-05-14)
		system.nixos.tags = [ "${uname}" ];

		systemd.tmpfiles.rules =
		let
			uhome = "/home/${uname}";
		in
		[
#			Type Path                           Mode User     Group Age Argument
			"d   ${uhome}/Developer             0755 ${uname} users"
			"d   ${uhome}/Developer/Github      0755 ${uname} users"
			"d   ${uhome}/Developer/Projects    0755 ${uname} users"
			"d   ${uhome}/Pictures/Screenshots  0755 ${uname} users"
		];

		users.users.${uname} = {
			name = uname;
			description = (titleCase uname);

			isNormalUser = true;
			createHome = true;

			# packages = with pkgs; [ ];
			extraGroups = [ "networkmanager" "wheel" ];

			openssh.authorizedKeys.keys = [
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDY+uqI9B48MnbNJzXlgvGSxHTuWdGy3bxMOD7UW0Dt7 ryuji@msi"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKhRn86zFXUmXsC7isRVu6WBa5t+eOvK+J7/niCZ/Wq/ ryuji@acer"
			];
		};

		environment.systemPackages = with pkgs; [
			google-chrome
			firefox

			obsidian

			vlc
			audacity
			emulsion

			obs-studio
		]
		++ lib.optionals (cfg.image-editing)   [ gimp krita ]
		++ lib.optionals (cfg.video-editing)   [ davinci-resolve ]
		++ lib.optionals (cfg.game-developing) [ blender ];
	};
}
