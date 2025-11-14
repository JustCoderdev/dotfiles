{ pkgs, config, options, lib, settings, ... }:

let
	inherit (settings) username;

	cfg = config.common.core.audio;
in

{
	config = lib.mkMerge
	[
		(
			lib.mkIf (cfg.backend == cfg.available-backends.pipewire)
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
			lib.mkIf (cfg.backend == cfg.available-backends.pulseaudio)
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
		backend = lib.mkOption {
			description = "What underlying backend is used for audio support";
			type = lib.types.enum cfg.available-backends-list;
			default = cfg.available-backends.pulseaudio;
		};

		# -------------------- #

		available-backends =
		let
			add-backend = (
				name:
				lib.mkOption {
					description = "Fixed name for ${name} backend";
					type = lib.types.str;
					readOnly = true;
					default = name;
				}
			);
		in
		{
			pulseaudio = (add-backend "pulseaudio");
			pipewire = (add-backend "pipewire");
		};

		available-backends-list = lib.mkOption {
			description = "All available audio backends";
			type = lib.types.listOf lib.types.str;
			readOnly = true;
			default = with cfg.available-backends; [ pulseaudio pipewire ];
		};
	};
}
