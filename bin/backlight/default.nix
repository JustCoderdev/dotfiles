{ config, lib, pkgs, ... }:

let
	cfg = config.jcbin.backlight;
	package = pkgs.stdenv.mkDerivation {
		name = "backlight";
		version = "1.0";
		src = ./.;

		# Compilation - Runtime dependencies
		nativeBuildInputs = [ pkgs.clang ];
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
	};
in

{
	config = lib.mkIf cfg.enable {
		security.sudo.extraRules = [{
			commands = [{
				command = "${package}/bin/backlight";
				options = [ "NOPASSWD" ];
			}];
			groups = [ "wheel" ];
		}];

		environment.systemPackages = [ package ];
	};

	options.jcbin.backlight = {
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Add backlight to PATH";
			default = false;
		};
	};
}
