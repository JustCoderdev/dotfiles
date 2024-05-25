{ pkgs, ... }:

{
	boot.kernelParams = [ "quiet" ];
	boot.plymouth = {
		enable = true;

		# logo = ../.;
		theme = "darnix";
		themePackages =
		let
			# Took this bit from the catppuccini plymouth theme repo
			# Link: <https://github.com/NixOS/nixpkgs/blob/nixos-23.11/pkgs/data/themes/catppuccin-plymouth/default.nix>
			theme-name = "darnix";
			darnix = with pkgs; stdenv.mkDerivation rec {
				name = "darnix-plymouth-theme";
				src = fetchFromGitHub {
					owner = "JustCoderdev";
					repo = "dotfiles";
					rev = "eed7d3275f80bc530b6770c9a0404fd9ffdf7a52";
					hash = "sha256-q4nHxhV1rDNInTxaC6ejZjoGZLBba4sWnFLK+BeKpno=";
				};

				sourceRoot = "${src.name}/plymouth/themes/${theme-name}";

				installPhase = ''
					#runHook preInstall
					sed -i 's:\(^ImageDir=\)/usr:\1'"$out"':' ${theme-name}.plymouth
					sed -i 's:\(^ScriptFile=\)/usr:\1'"$out"':' ${theme-name}.script
					mkdir -p $out/share/plymouth/themes/${theme-name}
					cp -r * $out/share/plymouth/themes/${theme-name}
					#runHook postInstall
				'';
			};
		in
		[ darnix ];
	};
}
