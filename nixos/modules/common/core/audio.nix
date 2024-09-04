{ pkgs, config, lib, settings, ... }:

let
	cfg = config.common.core.audio;
	username = settings.username;
in

{
	config = lib.mkMerge [

		(lib.mkIf cfg.pipewire.enable {
			sound.enable = false; #alsa
			hardware.pulseaudio.enable = false;

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

				# use the example session manager (no others are packaged yet so this is enabled by default,
				# no need to redefine it in your config for now)
				#media-session.enable = true;
			};
		})

		(lib.mkIf cfg.pulseaudio.enable {
			sound.enable = true; #alsa
			hardware.pulseaudio = {
				enable = true;
				support32Bit = true;

				extraConfig = ''
					load-module module-combine-sink
					load-module module-null-sink sink_name=@Microphone
					update-sink-proplist @Microphone device.description='"Virtual input audio (custom)"'
				'';
			};


			# Install control script
			environment.systemPackages = with pkgs; [ pavucontrol ];

			users.users.${username}.extraGroups = [ "audio" ];
		})
	];
}
