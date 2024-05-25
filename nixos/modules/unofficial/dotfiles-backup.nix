{ stdenv, settings }:

stdenv.mkDerivation {
	name = "dotfiles-backup";

	version = "1.0";
	src = settings.dotfiles_path;

	installPhase = ''
		mkdir -p $out/run/current-dotfiles
		cp -r . $out/run/current-dotfiles
	'';
}
