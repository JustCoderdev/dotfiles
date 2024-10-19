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
		];

		system.activationScripts."link_dotfiles".text = ''
function link {
	from="$1"; from_filename="''${from##/*/}";
	to="$2"; to_filename="''${3:-$from_filename}";

	# If file exists and is link
	if [ -L "''${to}/''${to_filename}" ]; then
		unlink "''${to}/''${to_filename}"
		# echo "Unlinking ' ''${to}/''${to_filename}'"
	fi

	# If file exists
	if [ -e "''${to}/''${to_filename}" ]; then
		echo "[ERROR] Linking ' ''${from_filename}' to ' ''${to}/''${to_filename}': file exists"
		return 0; # Must be 0 to avoid triggering -e
	fi

	# Link
	if ln -snf "''${from}" "''${to}/''${to_filename}"; then
		echo "[OK]    Linked ' ''${from_filename}' to ' ''${to}/''${to_filename}'"
	else
		echo "[ERROR] Linking ' ''${from_filename}' to ' ''${to}/''${to_filename}': return code ''${?}"
	fi
}

# Dotfiles
echo ""
echo "Linking Dotfiles"
echo "----------------------------"
link "${dotpath}/alacritty" "${cpath}"  # Alacritty
link "${dotpath}/clangd"    "${cpath}"  # Clang
link "${dotpath}/i3"        "${cpath}"  # i3
link "${dotpath}/MangoHud"  "${cpath}"  # MangoHud
link "${dotpath}/waybar"    "${cpath}"  # Waybar

# Setting weird links
link "${dotpath}/clangd/.clang-format"    "${uhome}"  # Clang format
link "${dotpath}/emacs/.emacs"            "${uhome}"  # Emacs
link "${dotpath}/emacs/.emacs.custom.el"  "${uhome}"  # Emacs
link "${dotpath}/emacs/.emacs.extra"      "${uhome}"  # Emacs

mkdir -p "${cpath}/nvim"
link "${dotpath}/nvim"      "${cpath}/nvim" "${uname}" # Nvim

echo ""
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
				telegram-desktop
				vlc
				tor

				piper  # Mouse software
			])
			(lib.mkIf cfg.image-editing (with pkgs; [
				gimp
				krita
			]))
			(lib.mkIf cfg.video-editing (with pkgs; [
				obs-studio
				davinci-resolve
			]))
			(lib.mkIf cfg.game-developing (with pkgs; [
				unityhub
				blender
				godot_4
			]))
#			(lib.mkIf cfg.developer (with pkgs; [
#				kicad
#			]))
		]);

		services.ratbagd.enable = true;

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
