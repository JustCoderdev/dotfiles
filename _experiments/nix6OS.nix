{
	pkgs ? import <nixpkgs> { }
}:

let
	kernel-drv = pkgs.linuxPackages.kernel;
	initrd-drv = abort "AAAAA";
in

{
	# stage-1-script = ;
	# stage-2-script = ;
	kernel = kernel-drv;
	initrd = initrd-drv;
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
