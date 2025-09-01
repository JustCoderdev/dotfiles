{ config, lib, pkgs, ... }:

let
	cfg = config.system.dev.c;
in

{
	config = lib.mkIf cfg.enable
	{
		documentation = {
			enable = true;
			dev.enable = true;

			man = {
				enable = true;
				generateCaches = false;
			};
		};

		environment.systemPackages = with pkgs; [
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
			jetbrains.clion
			vscode

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
