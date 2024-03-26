{ pkgs, ... }:

{
	#nixpkgs.config.allowUnfree = true;
	fonts.fonts = with pkgs; [
		roboto-mono
	];
}
