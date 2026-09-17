{ lib, pkgs, config, ... }:

# <https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/system/boot/stage-1-init.sh>
# <https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/system/boot/stage-1.nix>

let
	cfg = config._experimental.nix6OS;

	nix6OS = import ./nix6OS.nix
	{
		inherit pkgs;
		stage-1 = pkgs.writeScript "stage-1-script" # config.system.build.bootStage1;
''
#!
'';
		stage-2 = "${pkgs.bash}/bin/bash";
		# kernel-args = config.boot.kernelParams;
	};

	initrd-filename = "n6os-initrd-0";
	kernel-filename = "n6os-linux-6.12.93-bzImage";
	# coreutils-filename = "coreutils";

	inherit (nix6OS) stage-1 stage-2 kernel-args-formatted;
in
{
	config.boot.loader.grub = lib.mkIf (cfg.enable)
	{
		extraEntries = ''
menuentry "nix6OS" {
search --set=drive1 --fs-uuid ${cfg.fs-uuid}
  linux ($drive1)//n6os/${kernel-filename} init=${stage-2} ${kernel-args-formatted}
  initrd ($drive1)//n6os/${initrd-filename}/initrd
}
'';

		extraFiles =
		{
			"/n6os/${kernel-filename}"    = "${nix6OS.kernel}/bzImage";
			"/n6os/${initrd-filename}"    = stage-1;
			# "/n6os/${coreutils-filename}" = pkgs.coreutils;
		};
	};

	# ------------------------------------------------------------ #

	options._experimental.nix6OS =
	{
		enable = lib.mkEnableOption "nix6OS experimental module";
		fs-uuid = lib.mkOption {
			type = lib.types.str;
			example = "F4AE-D825";
		};
	};
}

