{ config, lib, pkgs, ... }:

with lib;

let
	FLAGS="-xc -Wall -Wextra -Werror -Wpedantic -pedantic -pedantic-errors -std=c89 -fcolor-diagnostics -lm";
	cfg = config.system.bin.backlight;
	backlight-der = with pkgs; (callPackage stdenv.mkDerivation {
		name = "backlight";
		version = "1.0";

		src = ./.;

		# Compilation dependencies
		nativeBuildInputs = [ clang ];
		buildInputs = [ ];

		buildPhase = ''
			clang ${FLAGS} "backlight.c" -o "backlight"
			chmod +x "backlight"
		'';

		installPhase = ''
			mkdir -p $out/bin
			cp backlight $out/bin
		'';
	});
in

{
	config = mkIf cfg.enable {
		security.sudo.extraRules = [{
			commands = [{
				command = "${backlight-der}";
				options = [ "NOPASSWD" ];
			}];
			groups = [ "wheel" ];
		}];

		environment.systemPackages = [ backlight-der ];
	};
}
