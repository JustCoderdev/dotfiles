{ config, lib, pkgs, settings, ... }:

let
	username = settings.username;
	cfg = config.common.users.ryuji;
	titleCase = text: lib.concatStrings [
		(lib.toUpper (builtins.substring 0 1 text))
		(builtins.substring 1 (builtins.stringLength text) text)
	];
in {
	config = lib.mkIf cfg.enable {
	# NixOS (Generation 96 Nixos Uakari hyprland-24.05 (Linux 6.6), built on 2024-05-14)
		system.nixos.tags = [ "${username}" ];

		systemd.tmpfiles.rules = let
			uname = username;
			uhome = "/home/${uname}";
		in [
#			Type Path                          Mode User     Group Age Argument
			"d   ${uhome}/Developer             0755 ${uname} users"
			"d   ${uhome}/Developer/Github      0755 ${uname} users"
			"d   ${uhome}/Developer/Projects    0755 ${uname} users"
			"d   ${uhome}/Pictures/screenshots  0755 ${uname} users"
			"d   /home/WDC_WD10                 0755 ${uname} users"
			"L   /home/WDC_WD10 - - - - ${uhome}/HDisk"
		];

		users.users.${username} = {
			name = username;
			description = (titleCase username);

			isNormalUser = true;
			createHome = true;

			# packages = with pkgs; [ ];
			extraGroups = [ "networkmanager" "wheel" ];
		};

		# List packages installed in system profile.
		environment.systemPackages = (lib.mkMerge [
			(with pkgs; [
				firefox
				obsidian
				emulsion
				newsflash
			])
			(lib.mkIf cfg.image-editing (with pkgs; [
				gimp
				krita
			]))
			(lib.mkIf cfg.video-editing (with pkgs; [
				obs-studio # Add to home-manager
				davinci-resolve
			]))
#			(lib.mkIf cfg.developer (with pkgs; [
#				kicad
#			]))
		]);

		# GTK dark theme (hopefully)
		environment.etc = {
			"xdg/gtk-2.0/gtkrc".text = "gtk-application-prefer-dark-theme=1";

			"xdg/gtk-3.0/settings.ini".text = ''
[Settings]
gtk-error-bell=false
gtk-application-prefer-dark-theme=1
'';

			"xdg/gtk-4.0/settings.ini".text = ''
[Settings]
gtk-error-bell=false
gtk-application-prefer-dark-theme=1
'';
		};

	};
}
