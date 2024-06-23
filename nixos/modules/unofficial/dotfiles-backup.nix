{ pkgs, settings, ... }:

let
	dotfiles-backup = pkgs.stdenv.mkDerivation {
		name = "dotfiles-backup";

		version = "1.0";
		src = settings.dotfiles_path;

		installPhase = ''
			mkdir -p $out/current-dotfiles
			touch $out/timemark
			date > $out/timemark
			cp -r . $out/current-dotfiles
		'';
	};
	current-system = pkgs.writeShellApplication {
		name = "current-system";
		text = ''
# Check if you are not being redirected
if [ -t 1 ]; then
	echo -n "Current configuration found at: "
fi

echo ${dotfiles-backup}/current-dotfiles
'';
	};
in

{
	environment.systemPackages = [
		dotfiles-backup
		current-system
	];
}
