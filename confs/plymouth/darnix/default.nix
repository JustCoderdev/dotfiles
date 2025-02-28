# Took this bit from the catppuccini plymouth theme repo
# Link: <https://github.com/NixOS/nixpkgs/blob/nixos-23.11/pkgs/data/themes/catppuccin-plymouth/default.nix>
{ stdenv }:

mkDerivation {
	name = "darnix-plymouth-theme";
	src = ./.;

	installPhase = ''
sed -i 's:\(^ImageDir=\)/usr:\1'"$out"':' darnix.plymouth
sed -i 's:\(^ScriptFile=\)/usr:\1'"$out"':' darnix.plymouth

mkdir -p $out/share/plymouth/themes/darnix
cp -r * $out/share/plymouth/themes/darnix
'';
}
