{ stdenv, pkgs, settings }:
let
	dotfiles = settings.dotfiles_path;
	FLAGS="-xc -Wall -Wextra -Werror -Wpedantic -pedantic -pedantic-errors -std=c89 -fcolor-diagnostics -lm";
in
stdenv.mkDerivation rec {
	name = "backlight";
	version = "1.0";

	src = "${dotfiles}/i3/scripts";

	# Compilation dependency
	nativeBuildInputs = [ pkgs.clang ];
	buildInputs = [ ];

	buildPhase = ''
		clang ${FLAGS} "backlight.c" -o "backlight"
		chmod +x "backlight"
	'';

	installPhase = ''
		mkdir -p $out/bin
		cp backlight $out/bin
	'';
}
# {
# 	environment.systemPackages = [(
# 		pkgs.writeShellApplication {
# 			name = "backlight";
# 			text = (builtins.readFile "${i3Bin_path}/backlight");
# 		}
# 	)];
# }


