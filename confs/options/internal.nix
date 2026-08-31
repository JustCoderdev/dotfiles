{ lib, pkgs, ... }:

let
	profiles-list =
	[
		      "i3-desktop" # i3, i3status, fusuma
		"hyprland-desktop" # hyprland, waybar

		 "develop-environment" # alacritty, emacs, git, neovim, zsh, ssh
		    "game-environment" # mangohud
		      "vr-environment" # mangohud

		"ryuji-user" # firefox
	];
in

{
	options.jcconfs =
	{
		inherit (import ./common.nix { inherit lib pkgs; }) host icon-theme wallpapers_path;

		user.profiles = lib.mkOption {
			description = "List of profiles to enable";
			type = lib.types.listOf (lib.types.enum profiles-list);
		};
	};
}
