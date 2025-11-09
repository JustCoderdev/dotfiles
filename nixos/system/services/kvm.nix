{ config, lib, pkgs, settings, ... }:

let
	inherit (settings) username;
	
	cfg = config.system.services.kvm;
in

{
	config = lib.mkIf cfg.enable
	{
		environment.systemPackages = with pkgs; [ qemu ];

		programs.virt-manager.enable = true;
		users.users.${username}.extraGroups = [ "libvirtd" "kvm" ];

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
		enable = lib.mkEnableOption "kvm daemon";
		allowedBridges = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			description = "List of bridge devices that can be used by qemu:///session";
			default = [];
		};
	};
}

