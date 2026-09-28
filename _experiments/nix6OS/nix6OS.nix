{
	pkgs          ? import <nixpkgs> { }
	, kernel      ? pkgs.linuxPackages.kernel
	, kernel-args ? [ ] # [ "root=fstab" ] # "init=${stage-2}/bin/bash"
	, stage-1     ? null # pkgs.writeShellScript "stage-1" '' '';
	, stage-2     ? null # pkgs.writeShellScript "stage-2" '' '';
}:

{
	inherit kernel kernel-args stage-1 stage-2;

	kernel-args-formatted = builtins.concatStringsSep " " kernel-args;
	kernel-bzimage = "${kernel}/bzImage";
}

# Used to generate menuentry
# NOTE: the drive uuid comes from the build script
#
# ```
# menuentry "NixOS" --class nixos --unrestricted {
# search --set=drive1 --fs-uuid F4AE-D825
#   linux ($drive1)//kernels/8a1...-linux-6.12.93-bzImage [\]
#      init=/nix/store/in0...-nixos-system-msi-disko-i3-nvidia-ryuji-25.11.20260630.b6018f8/init [\]
#      quiet nosgx root=fstab splash loglevel=7 lsm=landlock,yama,bpf nvidia-drm.modeset=1 nvidia-drm.fbdev=1
#   initrd ($drive1)//kernels/v1p...-initrd-linux-6.12.93-initrd
# }
# ```
#
