{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		(writeShellApplication {
				name = "rebuild-system";
				runtimeInputs = with pkgs; [ git vim ];
				text = (builtins.readFile ./rebuild-system.sh);
		})
	];
}
