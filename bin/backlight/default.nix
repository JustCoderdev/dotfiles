{ stdenv, clang }:

stdenv.mkDerivation {
	name = "backlight";
	version = "1.0";
	src = ./.;

	# Compilation - Runtime dependencies
	nativeBuildInputs = [ clang ];
	buildInputs = [ ];
	
	buildPhase = ''
clang -xc -Wall -Wextra -Werror -Wpedantic \
-pedantic -pedantic-errors -std=c89 \
-fcolor-diagnostics -lm \
"backlight.c" -o "backlight"
chmod +x "backlight"
'';

	installPhase = ''
mkdir -p $out/bin
cp backlight $out/bin
'';
}
