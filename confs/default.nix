{ config, lib, pkgs, settings, ... }:

let
	inherit (settings) special-pkgs;
	inherit (config.jcconfs) username;
in

{
	config =
	{
		# --- enable when 23.05 => 23.11 --- #
		manual.html.enable = false;          #
		manual.manpages.enable = false;      #
		# ---------------------------------- #


		# DO NOT TOUCH
		nixpkgs.config = {
			permittedInsecurePackages = special-pkgs.insecure;
			allowUnfreePredicate = pkg:
				builtins.elem (lib.getName pkg) special-pkgs.unfree;
		};

		programs.home-manager.enable = true;

		home = {
			inherit username;
			homeDirectory = "/home/${username}";
			stateVersion = "23.11";
		};
	};
}
