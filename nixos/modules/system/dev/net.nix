{ config, lib, pkgs, ... }:

let cfg = config.system.dev.net; in

{
	config = lib.mkIf cfg.enable {
		environment.systemPackages = with pkgs; [
			ciscoPacketTracer8
			wireshark
			putty
		];
	};
}

