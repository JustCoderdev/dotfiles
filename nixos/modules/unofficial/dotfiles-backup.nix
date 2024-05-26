{ pkgs, settings, ... }:

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
	current-system = pkgs.writeShellApplication {
		name = "current-system";
		text = ''
			echo "Visiting current configuration"
			pushd ${dotfiles-backup}/current-dotfiles
		'';
	};
in

{
	environment.systemPackages = [
		dotfiles-backup
		current-system
	];
}
