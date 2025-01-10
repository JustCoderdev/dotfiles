{ config, lib, pkgs, ... }:

let
	FLAGS="-xc -Wall -Wextra -Werror -Wpedantic -pedantic -pedantic-errors -std=c89 -fcolor-diagnostics -lm";
	cfg = config.system.bin.backlight;
in

{
	config = lib.mkIf cfg.enable {
#		security.sudo.extraRules = [{
#			commands = [{
#				command = "/run/current-system/sw/bin/backlight";
#				options = [ "NOPASSWD" ];
#			}];
#			groups = [ "wheel" ];
#		}];

		environment.systemPackages = [
			(pkgs.callPackage pkgs.stdenv.mkDerivation {
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
