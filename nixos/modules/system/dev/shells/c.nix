{ pkgs, ... }:

let
	cshell = pkgs.mkShell {
		buildInputs = with pkgs; [ clang ];
	};
in {
	environment.systemPackages = with pkgs; [
		(writeShellApplication {
			name = "CShell";
			runtimeInputs = with pkgs; [ zsh ];
			text = "zsh --init-file ${cshell}";
		})
	];
}
