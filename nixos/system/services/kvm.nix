{ config, lib, pkgs, settings, ... }:

let
	cfg = config.system.services.kvm;
in

{
	config = lib.mkIf cfg.enable
	{
		environment.systemPackages = with pkgs; [ qemu ];

		programs.virt-manager.enable = true;
		users.users.${settings.username}.extraGroups = [ "libvirtd" ];

		virtualisation.libvirtd =
		{
			enable = true;
			inherit (cfg) allowedBridges;

			qemu = {
				package = pkgs.qemu_kvm;
				runAsRoot = true;
				swtpm.enable = true;
				ovmf = {
					enable = true;
					packages = with pkgs; [
						(OVMF.override { secureBoot = true; tpmSupport = true; }).fd
					];
				};
			};
		};
	};

	# ------------------------------------------------------------ #

	options.system.services.kvm =
	{
		enable = lib.mkEnableOption "Enable kvm daemon";
		allowedBridges = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			description = "List of bridge devices that can be used by qemu:///session.";
		};
	};
}





