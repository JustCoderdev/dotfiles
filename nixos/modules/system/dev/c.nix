{ config, lib, pkgs, ... }:

with lib;
let cfg = config.system.dev.c; in

{
	config = mkIf cfg.enable {
		environment.systemPackages = with pkgs; [
			glibcInfo
			glibc

			clang-tools
			clang
			gcc

			gnumake
			gdb

			file
		];
	};

#	libGL
#	xorg.libXinerama
#	xorg.libX11.dev
#	xorg.libXft
#	xorg.libXcursor
#	xorg.libXrandr
#	xorg.libXi.dev
}
