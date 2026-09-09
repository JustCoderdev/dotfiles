{ lib, pkgs, config, ... }:
let
	nix6OS = import ./nix6OS.nix { inherit pkgs; };

	initrd-filename = "n6ox-initrd-0";
	kernel-filename = "n6os-linux-6.12.93-bzImage";
	kernel-args = builtins.concatStringsSep " " nix6OS.kernel-args; # config.boot.kernelParams

	stage-1 = if nix6OS.stage-1 != null then nix6OS.stage-1 else config.system.build.bootStage1;
	inherit (nix6OS) stage-2;
in
{
	config.boot.loader.grub =
	{
		extraEntries = ''
menuentry "nix6OS" {
search --set=drive1 --fs-uuid F4AE-D825 # valid only on MSI!!
  linux ($drive1)//${kernel-filename} init=${stage-2} ${kernel-args}
  initrd ($drive1)//${initrd-filename}
}
'';

		extraFiles =
		{
			"${kernel-filename}" = "${nix6OS.kernel}/bzImage";
			"${initrd-filename}" = stage-1;
		}
		# // lib.attrsets.optionalAttrs (nix6OS.initrd != null) { "${initrd-filename}" = nix6OS.initrd; }
		;
	};
}

