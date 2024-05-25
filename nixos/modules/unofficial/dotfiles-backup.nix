{ stdenv, settings }:

stdenv.mkDerivation {
	name = "dotfiles-backup";

	version = "1.0";
	src = settings.dotfiles_path;

	installPhase = ''
		mkdir -p $out/share/current-dotfiles
		cp -r . $out/share/current-dotfiles
	'';
}

# /nix/store/i3mxngx5sk1lxg1ccbv3sycgxw4avan9-dotfiles-backup
