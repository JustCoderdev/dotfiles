{ pkgs, config, options, lib, settings, ... }:

let
	inherit (settings) username;

	cfg = config.common.core.audio;
in

{
	config = lib.mkMerge
	[
		(
			lib.mkIf (cfg.frontend == cfg.available-frontends.pipewire)
			{
				services.pulseaudio.enable = false;

				# Install control script
				environment.systemPackages = with pkgs; [ pamixer ];

				# Enable sound with pipewire.
				security.rtkit.enable = true;
				services.pipewire = {
					enable = true;

					alsa.enable = true;
					alsa.support32Bit = true;
					pulse.enable = true;
					jack.enable = true;
				};
			}
		)

		(
			lib.mkIf (cfg.frontend == cfg.available-frontends.pulseaudio)
			{
				services.pipewire.enable = false;

				# Install control script
				environment.systemPackages = with pkgs; [ pavucontrol alsa-utils ];

				# Enable sound with pulseaudio.
				services.pulseaudio = {
					enable = true;
					support32Bit = true;
				};

				users.users.${username}.extraGroups = [ "audio" ];
			}
		)
	];

	# ------------------------------------------------------------ #

	options.common.core.audio = 
	{
		enable = lib.mkEnableOption "audio support";
		frontend = lib.mkOption {
			description = "What underlying 'driver' is used for audio support";
			type = lib.types.enum cfg.available-frontends-list;
			default = cfg.available-frontends.pulseaudio;
		};

		# -------------------- #

		available-frontends =
		let
			add-frontend = (
				name:
				lib.mkOption {
					description = "Fixed name for ${name} frontend";
					type = lib.types.str;
					readOnly = true;
					default = name;
				}
			);
		in
		{
			pulseaudio = (add-frontend "pulseaudio");
			pipewire = (add-frontend "pipewire");
		};

		available-frontends-list = lib.mkOption {
			description = "All available audio frontends";
			type = lib.types.listOf lib.types.str;
			readOnly = true;
			default = with cfg.available-frontends; [ pulseaudio pipewire ];
		};
	};
}
