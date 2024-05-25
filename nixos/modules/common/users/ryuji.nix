{ config, lib, pkgs, settings, ... }:

let
	username = settings.username;
	cfg = config.common.users.ryuji;
in {
	config = lib.mkIf cfg.enable {

		systemd.tmpfiles.rules = [
			"d /home/${username}/Developer           0755 ${username} users"
			"d /home/${username}/Developer/Github    0755 ${username} users"
			"d /home/${username}/Developer/Projects  0755 ${username} users"
		];

		users.users.${username} = {
			name = username;
			description = username;

			isNormalUser = true;
			createHome = true;

			# packages = with pkgs; [ ];
			extraGroups = [ "networkmanager" "wheel" ];
		};

		# List packages installed in system profile.
		environment.systemPackages = (lib.mkMerge [
			(with pkgs; [
				firefox
				obsidian
				emulsion
			])

			(lib.mkIf cfg.image-editing (with pkgs; [
				gimp
				krita
			]))
			(lib.mkIf cfg.video-editing (with pkgs; [
				obs-studio # Add to home-manager
				davinci-resolve
			]))
			(lib.mkIf cfg.developer (with pkgs; [
				putty
				kicad
			]))
		]);
	};
}
