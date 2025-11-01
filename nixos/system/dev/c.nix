{ config, lib, pkgs, ... }:

let
	dev-cfg = config.system.dev;
	cfg = dev-cfg.c;
in

{
	config = lib.mkIf (dev-cfg.enable && cfg.enable)
	{
		documentation = {
			enable = true;
			dev.enable = true;

			man = {
				enable = true;
				generateCaches = false;
			};
		};

		environment.systemPackages = with pkgs;
		[
			# Docs
			glibc glibcInfo
			man-pages man-pages-posix
			clang-manpages linux-manual
			stdmanpages stdman

			# Compilation
			clang-tools clang
			gcc gnumake nasm

			# Tools
			ascii ripgrep

			# Debugging
			gdb valgrind
			gf file
		];
	};

	# ------------------------------------------------------------ #

	options.system.dev.c = 
	{
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Add c development tools and libs";
			default = false;
		};
	};
}
