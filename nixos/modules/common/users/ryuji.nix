{ config, lib, pkgs, settings, ... }:

let
	username = settings.username;
	cfg = config.common.users.ryuji;
in {
	config = lib.mkIf cfg.enable {

#  The default is {option}`system.nixos.tags` separated by
#  "-" + "-" + {env}`NIXOS_LABEL_VERSION` environment
#  variable (defaults to the value of
#  {option}`system.nixos.version`)

# NixOS (Generation 96 Nixos Uakari hyprland-24.05 (Linux 6.6), built on 2024-05-14)

		# Allowed [a-zA-Z0-9:_\.-]*
		system.nixos.label = let
			nx = config.system.nixos;

			name = nx.codeName;    # Uakari
			version = nx.release;  # 24.05

		in
			"Label_test_";
#			lib.concatStringsSep " " (
#			[ nx.name ] ++
#			(lib.sort (x: y: x < y) nx.tags)
#			++ [ config.system.nixos.version ]
#		);


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
