{ pkgs, ... }:

{
	services.xserver.displayManager.sddm = {
		enable = true;

		wayland.enable = true;
		enableHidpi = true;

		autoNumlock = true;
		theme = "ternix";  #terminal nix
	};

#	environment.systemPackages = let
#		theme-name = "ternix";
#		ternix = pkgs.stdenv.mkDerivation rec {
#			name = "ternix-sddm-theme";
#			src = pkgs.fetchFromGitHub {
#				owner = "JustCoderdev";
#				repo = "dotfiles";
#				rev = "";
#				sha256 = "";
#			};
#
#			sourceRoot = "${src.name}/sddm/themes/${theme-name}";
#
#			installPhase = ''
#				mkdir -p $out/share/sddm/themes
#				cp -r $src $out/share/sddm/themes/sugar-dark
#			'';
#		};
#	in [ ternix ];
}
