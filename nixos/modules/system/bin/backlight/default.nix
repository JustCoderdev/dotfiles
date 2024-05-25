{ config, lib, pkgs, ... }:

with lib;

let
	FLAGS="-xc -Wall -Wextra -Werror -Wpedantic -pedantic -pedantic-errors -std=c89 -fcolor-diagnostics -lm";
	cfg = config.system.bin.backlight;
in

{
	config = mkIf cfg.enable {
		environment.systemPackages = with pkgs; [
			(callPackage stdenv.mkDerivation rec {
				name = "backlight";
				version = "1.0";

				src = ./.;

				# Compilation dependencies
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
			})
		];
	};
}
