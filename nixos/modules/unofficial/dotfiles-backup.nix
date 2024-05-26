{ pkgs, settings }:

let
	dotfiles-backup = pkgs.stdenv.mkDerivation {
		name = "dotfiles-backup";

		version = "1.0";
		src = settings.dotfiles_path;

		installPhase = ''
			mkdir -p $out/current-dotfiles
			cp -r . $out/current-dotfiles
		'';
	};
in

{
	environment.systemPackages =  [
		(pkgs.callPackage dotfiles-backup)
		(pkgs.writeShellApplication {
			name = "current-dotfiles";
			text = ''
				# /nix/store/i3mxngx5sk1lxg1ccbv3sycgxw4avan9-dotfiles-backup
				echo ${dotfiles-backup}
				cd ${dotfiles-backup}
			'';
		})
	];
}
