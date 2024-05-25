{ pkgs, ... }:

{
	boot.kernelParams = [ "quiet" ];
	boot.plymouth = {
		enable = true;

		# logo = ../.;
		# theme = "macOS";
		# themePackages = with pkgs; [ ]; # adi1090x/plymouth-themes 25, 75
	};
}
