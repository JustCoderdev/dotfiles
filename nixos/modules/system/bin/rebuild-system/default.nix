{ config, lib, pkgs, ... }:

let cfg = config.system.bin.rebuild-system; in

{
	config = lib.mkIf cfg.enable {
		security.sudo = {
			extraRules = [{
				commands = [{
					command = "/run/current-system/sw/bin/rebuild-system";
					options = [ "NOPASSWD" ];
				}];
				groups = [ "wheel" ];
			}];
		};

		environment.systemPackages =  [
			(pkgs.writeShellApplication {
				name = "rebuild-system";
				runtimeInputs = with pkgs; [ git vim ];
				text = (builtins.readFile ./rebuild-system.sh);
			})
		];
	};
}
