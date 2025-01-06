{ pkgs, lib, settings, ... }:

let
	# Took this bit from the catppuccini plymouth theme repo
	# Link: <https://github.com/NixOS/nixpkgs/blob/nixos-23.11/pkgs/data/themes/catppuccin-plymouth/default.nix>
	theme-name = "darnix";
	darnix-theme = pkgs.stdenv.mkDerivation rec {
		name = "darnix-plymouth-theme";
		src = pkgs.fetchFromGitHub {
			owner = "JustCoderdev";
			repo = "dotfiles";
			rev = "9af46b860ee3a076f822a0dd028c86a710682b14";
			hash = "sha256-/pEB8Q8ueWq/jZUChAKjgt2dPBHYazYxwE3ghhV/oZw=";
		};

		sourceRoot = "${src.name}/plymouth/themes/${theme-name}";

		installPhase = ''
			runHook preInstall
			sed -i 's:\(^ImageDir=\)/usr:\1'"$out"':' ${theme-name}.plymouth
			sed -i 's:\(^ScriptFile=\)/usr:\1'"$out"':' ${theme-name}.plymouth
			mkdir -p $out/share/plymouth/themes/${theme-name}
			cp -r * $out/share/plymouth/themes/${theme-name}
			runHook postInstall
		'';
	};
in

{
	boot.initrd.systemd.enable = true;
	boot.kernelParams = [
		"quiet" "splash"
		"plymouth.debug" # log at /var/log/plymouth-debug.log
	];

	boot.plymouth = lib.mkIf (!settings.runningVM) {
		enable = true;

		# logo = ../.;
		theme = "darnix";
		themePackages = [ darnix-theme ];
	};
}
