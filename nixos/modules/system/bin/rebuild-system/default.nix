{ config, lib, pkgs, ... }:

with lib;
let cfg = config.system.bin.rebuild-system; in

{
	config = mkIf cfg.enable {
		environment.systemPackages = with pkgs; [
			(writeShellApplication {
					name = "rebuild-system";
					runtimeInputs = with pkgs; [ git vim ];
					text = (builtins.readFile ./rebuild-system.sh);
			})
		];
	};
}
