# To run steam games with "utilities"
# `gamemoderun mangohud %command%``
# `strangle 60 gamemoderun mangohud %command%`

{ config, lib, pkgs, settings, ... }:

let
	inherit (settings) username;

	cfg = config.common.environments.gaming;
in

{
	config = lib.mkIf (cfg.enable)
	{
		environment.systemPackages = with pkgs;
		[
			discord        # Run with --disable-gpu
			libstrangle    # lock fps
			# mangohud     # Overlay (edit with goverlay) # enabled with home assistant
			prismlauncher  # Minecraft launcher
			lutris

			wineWowPackages.stable
			protonup-ng
		];

		# programs.lutris.enable = true; # TODO: on next release cycle

		# Steam
		programs.steam =
		{
			enable = true;
			gamescopeSession.enable = true;
			extraCompatPackages = with pkgs; [ proton-ge-bin wine ];
		};

		# Gamemode
		programs.gamemode.enable = true;
		users.users.${username}.extraGroups = [ "gamemode" ];
	};

	# ------------------------------------------------------------ #

	options.common.environments.gaming =
	{
		enable = lib.mkEnableOption "the gaming environment";
	};
}
