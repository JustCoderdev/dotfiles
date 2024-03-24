{ pkgs, ... }:

pkgs.writeShellApplication {
	name = "rebuild-system";
	runtimeInputs = with pkgs; [ git vim ];
	text = (builtins.readFile ./nixos-rebuild.sh);
}
