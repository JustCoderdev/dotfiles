{ ... }:

abort

''
Brand servers may require extra kernel modules be included into initrd
(boot.initrd.extraKernelModules in configuration.nix) For example HP Proliant
needs "hpsa" module to see the disk drive.
''

{
	common.core.bootloader.grub.enable = true;
	boot.loader.grub.device = "/dev/sda";

	# boot.kernelParams = [ "console=ttyS0,115200n8" ];
	# boot.loader.grub.extraConfig = ''
# serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1
# terminal_input serial
# terminal_output serial
# '';
}
