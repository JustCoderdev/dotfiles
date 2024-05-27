{ config, lib, pkgs, ... }:

let cfg = config.system.dev.c; in

{
	config = lib.mkIf cfg.enable {
		documentation = {
			enable = true;

			nixos.enable = true;
			dev.enable = true;

			man = {
				enable = true;
				generateCaches = false;
			};
		};

		environment.systemPackages = with pkgs; [
			glibcInfo
			glibc

			man-pages
			man-pages-posix
			clang-manpages
			linux-manual
			stdmanpages
			stdman

			clang-tools
			clang
			gcc

			gdb gf
			gnumake
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
