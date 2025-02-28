{ config, lib, pkgs, settings, ... }:

let
	cfg = config.common.users.ryuji;
	titleCase = text: lib.concatStrings [
		(lib.toUpper (builtins.substring 0 1 text))
		(builtins.substring 1 (builtins.stringLength text) text)
	];

	uname = settings.username;
	uhome = "/home/${uname}";
	cpath = "/home/${uname}/.config";
	dpath = settings.dotfiles_path;
in

{
	config = lib.mkIf cfg.enable {
		# NixOS (Generation 96 Nixos Uakari hyprland-24.05 (Linux 6.6), built on 2024-05-14)
		system.nixos.tags = [ "${uname}" ];

		systemd.tmpfiles.rules = [
#			Type Path                           Mode User     Group Age Argument
			"d   ${uhome}/Developer             0755 ${uname} users"
			"d   ${uhome}/Developer/Github      0755 ${uname} users"
			"d   ${uhome}/Developer/Projects    0755 ${uname} users"
			"d   ${uhome}/Pictures/screenshots  0755 ${uname} users"
		];

		# system.activationScripts."link_dotfiles".text = ''
# 	function link {
# 		from="$1"; from_filename="''${from##/*/}";
# 		to="$2"; to_filename="''${3:-$from_filename}";

# 		# If file exists and is link
# 		if [ -L "''${to}/''${to_filename}" ]; then
# 			unlink "''${to}/''${to_filename}"
# 			echo "[WARN] Unlinking ''${to}/''${to_filename}"
# 		fi

# 		# If file exists
# 		if [ -e "''${to}/''${to_filename}" ]; then
# 			echo "[FAIL] Linking   ''${from_filename} to ''${to}/''${to_filename}: file exists"
# 			return 0; # Must be 0 to avoid triggering -e
# 		fi

# 		# Link
# 		if ln -snf "''${from}" "''${to}/''${to_filename}"; then
# 			echo "[ OK ] Linked    ''${from_filename} to ''${to}/''${to_filename}"
# 		else
# 			echo "[FAIL] Linking   ''${from_filename} to ''${to}/''${to_filename}: return code ''${?}"
# 		fi
# 	}

# 	# Dotfiles
# 	echo ""
# 	echo "Linking Dotfiles"
# 	echo "----------------------------"
# 	link "${dpath}/alacritty"               "${cpath}"  # Alacritty
# 	link "${dpath}/clangd"                  "${cpath}"  # Clang
# 	link "${dpath}/i3"                      "${cpath}"  # i3
# 	link "${dpath}/waybar"                  "${cpath}"  # Waybar

# 	# Setting home links
# 	link "${dpath}/clangd/.clang-format"    "${uhome}"  # Clang format
# 	link "${dpath}/emacs/.emacs"            "${uhome}"  # Emacs
# 	link "${dpath}/emacs/.emacs.custom.el"  "${uhome}"  # Emacs
# 	link "${dpath}/emacs/.emacs.extra"      "${uhome}"  # Emacs

# 	# Setting weird links
# 	mkdir -p "${cpath}/nvim"
# 	chown ${uname}:users "${cpath}/nvim"
# 	link "${dpath}/nvim" "${cpath}/nvim" "${uname}" # Nvim
# 	echo ""
# '';

		users.users.${uname} = {
			name = uname;
			description = (titleCase uname);

			isNormalUser = true;
			createHome = true;

			# packages = with pkgs; [ ];
			extraGroups = [ "networkmanager" "wheel" ];
		};

		# List packages installed in system profile.
		environment.systemPackages = (lib.mkMerge [
			(with pkgs; [
				firefox
				google-chrome

				obsidian
				anytype

				emulsion
				vlc
				tor

				audacity
				obs-studio

				baobab  # disk space
				piper   # Mouse software
			])
			(lib.mkIf cfg.image-editing (with pkgs; [
				gimp
				krita
			]))
			(lib.mkIf cfg.video-editing (with pkgs; [
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
