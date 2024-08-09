{ config, lib, pkgs, ... }:

let cfg = config.system.dev.c; in

{
	config = lib.mkIf cfg.enable {
		documentation = {
			enable = true;

			nixos.enable = false;
			dev.enable = true;

			man = {
				enable = true;
				generateCaches = false;
			};
		};

		environment.systemPackages = with pkgs; [
			# Docs
			glibc
			glibcInfo
			man-pages
			man-pages-posix
			clang-manpages
			linux-manual
			stdmanpages
			stdman

			# Compilation
			clang-tools
			clang gcc
			gnumake

			# Tools
			ascii
			ripgrep

			# Debugging
			gdb gf
			valgrind
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
