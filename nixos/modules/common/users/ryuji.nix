{ config, lib, pkgs, settings, ... }:

let
	username = settings.username;
	cfg = config.common.users.ryuji;
	titleCase = text: lib.concatStrings [
		(lib.toUpper (builtins.substring 0 1 text))
		(builtins.substring 1 (builtins.stringLength text) text)
	];
in {
	config = let
		uname = username;
		uhome = "/home/${uname}";
		cpath = "${uhome}/.config";
		dotpath = settings.dotfiles_path;
	in
	lib.mkIf cfg.enable {
	# NixOS (Generation 96 Nixos Uakari hyprland-24.05 (Linux 6.6), built on 2024-05-14)
		system.nixos.tags = [ "${username}" ];

		systemd.tmpfiles.rules = [
#			Type Path                          Mode User     Group Age Argument
			"d   ${uhome}/Developer             0755 ${uname} users"
			"d   ${uhome}/Developer/Github      0755 ${uname} users"
			"d   ${uhome}/Developer/Projects    0755 ${uname} users"
			"d   ${uhome}/Pictures/screenshots  0755 ${uname} users"
			"d   /home/WDC_WD10                 0755 ${uname} users"
			"L+  /home/WDC_WD10 - - - - ${uhome}/HDisk"

			# Dotfiles
#			"L+  ${dotpath}/alacritty - - - - ${cpath}"  # Alacritty
#			"L+  ${dotpath}/clangd    - - - - ${cpath}"  # Clang
#			#"L+  ${dotpath}/hypr      - - - - ${cpath}"  # Hyprland
#			"L+  ${dotpath}/i3        - - - - ${cpath}"  # i3
#			"L+  ${dotpath}/MangoHud  - - - - ${cpath}"  # MangoHud
#			"L+  ${dotpath}/nvim      - - - - ${cpath}"  # Nvim
#			"L+  ${dotpath}/waybar    - - - - ${cpath}"  # Waybar

			# Setting weird links
#			"L+  ${dotpath}/clangd/.clang-format"  "${uhome}"         # Clang format
#			#"L+  ${dotpath}/i3/scripts/bin/*"      "/usr/local/bin"   # i3
#			#"L+  ${dotpath}/plymouth"              "/etc"             # Plymouth
#			"L+  ${dotpath}/zsh"                   "${uhome}/.zsh"    # Zsh
#			#"L+  ${dotpath}/zsh/.zshrc"            "${uhome}"         # Zsh
		];

		system.activationScripts."link_dotfiles".text = ''
function link {
	from="$1"; to="$2";

	unlink $to
	ln -snf $from $to;
	echo "Linking $1 --> $2"
}

# Dotfiles
link "${dotpath}/alacritty" "${cpath}"  # Alacritty
link "${dotpath}/clangd"    "${cpath}"  # Clang
link "${dotpath}/i3"        "${cpath}"  # i3
link "${dotpath}/MangoHud"  "${cpath}"  # MangoHud
link "${dotpath}/waybar"    "${cpath}"  # Waybar
link "${dotpath}/emacs"     "${cpath}"  # Emacs

# Setting weird links
link "${dotpath}/clangd/.clang-format"  "${uhome}"               # Clang format
link "${dotpath}/zsh"                   "${uhome}/.zsh"          # Zsh

mkdir -p "${cpath}/nvim"
link "${dotpath}/nvim"                  "${cpath}/nvim/${uname}" # Nvim
'';

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
				vlc
				tor
				telegram-desktop
			])
			(lib.mkIf cfg.image-editing (with pkgs; [
				gimp
				krita
			]))
			(lib.mkIf cfg.video-editing (with pkgs; [
				obs-studio
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
