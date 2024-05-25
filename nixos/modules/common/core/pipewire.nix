{ pkgs, ... }:

{
	sound.enable = false; #alsa
	hardware.pulseaudio.enable = false;

	# Install control script
	environment.systemPackages = with pkgs; [
		pamixer
	];

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
}
