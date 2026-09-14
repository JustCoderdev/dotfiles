{ lib, pkgs, config, ... }:
let
	cfg = config._experimental.nix6OS;

	nix6OS = import ./nix6OS.nix
	{
		inherit pkgs;
		stage-1 = config.system.build.bootStage1;
		# kernel-args = config.boot.kernelParams;
	};

	initrd-filename = "n6ox-initrd-0";
	kernel-filename = "n6os-linux-6.12.93-bzImage";

	inherit (nix6OS) stage-1 stage-2 kernel-args-formatted;
in
{
	config.boot.loader.grub = lib.mkIf (cfg.enable)
	{
		extraEntries = ''
menuentry "nix6OS" {
search --set=drive1 --fs-uuid ${cfg.fs-uuid}
  linux ($drive1)//${kernel-filename} init=${stage-2} ${kernel-args-formatted}
  initrd ($drive1)//${initrd-filename}/initrd
}
'';

		extraFiles =
		{
			"${kernel-filename}" = "${nix6OS.kernel}/bzImage";
			"${initrd-filename}" = stage-1;
		};
	};

	# ------------------------------------------------------------ #

	options._experimental.nix6OS =
	{
		enable = lib.mkEnableOption "nix6OS experimental module";
		fs-uuid = lib.mkOption {
			type = lib.type.str;
			example = "F4AE-D825";
		};
	};
}

