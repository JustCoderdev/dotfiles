# To run steam games with "utilities"
# `gamemoderun mangohud %command%``
# `strangle 60 gamemoderun mangohud %command%`

# Ideas taken from the awesome Reality.md <3
# Source: <https://git.uninetwork.net/reality-exe/nixos-config/src/commit/18fbcb74c220aec75507d2257b1412e31453953d/modules/nixos/software/vr/wivrn.nix>

# To run steam games with VR
# `PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1 %command%`

{ config, lib, pkgs, settings, nixpkgs-xr, ... }:

let
	inherit (settings) username;
	inherit (config.common.manifest.self.hardware) system;

	cfg = config.common.environments.gaming;
in

{
	# imports = [ ../../unofficial/modules/wivrn.nix ];

	config = lib.mkIf (cfg.enable)
	{
		# programs.lutris.enable = true; # TODO: on next release cycle

		# Steam
		programs.steam =
		{
			enable = true;
			gamescopeSession.enable = true;
			extraCompatPackages = with pkgs; [ proton-ge-bin wine ];
			remotePlay.openFirewall = true;
		};

		# Gamemode
		programs.gamemode.enable = true;
		users.users.${username}.extraGroups = [ "gamemode" ];

		environment.systemPackages = with pkgs;
		[
			discord        # Run with --disable-gpu
			libstrangle    # lock fps
			# mangohud     # Overlay (edit with goverlay) # enabled with home assistant
			prismlauncher  # Minecraft launcher
			lutris         # Game launcher

			wineWowPackages.stable
			protonup-ng
		]
		++ lib.lists.optionals (cfg.vr.enable)
		(
			[
				android-tools  # Used for meta quest?
			]
			++
			(with nixpkgs-xr.packages.${system}; [

				# inputs.lemonake.packages.x86_64-linux.wayvr
				wayvr      # Overlay for X11 and wayland
				# motoc      # MOnado Tracking Origin Calibration program
				# edrakon    # steamlink face tracking emulator
				# space-cal  # Space calibration

				# resolute   # ???
				xrizer   # OpenVR API compatibility
			])
		)
		;

		# VR
		# -------------------- #

		# Needed for xrizer to translate OpenGL into OpenXR
		services.xserver.displayManager.xserverArgs = [ "-core +iglx" ];

		services.wivrn = lib.mkIf (cfg.vr.enable)
		{
			enable = true;
			package = nixpkgs-xr.packages.${system}.wivrn;
			openFirewall = true;
			autoStart = true;

			highPriority = true;
			steam.importOXRRuntimes = true;
		};
	};

	# ------------------------------------------------------------ #

	options.common.environments.gaming =
	{
		enable = lib.mkEnableOption "the gaming environment";
		vr.enable = lib.mkEnableOption "the vr setup";

	};
}
