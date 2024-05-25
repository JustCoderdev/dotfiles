{ pkgs, settings, ... }:

{
	# User account
	users.users.${settings.username} = {
		name = settings.username;
		description = settings.username;

		isNormalUser = true;
		createHome = true;

		extraGroups = [ "networkmanager" "wheel" ];
		# packages = with pkgs; [ ];
	};

	# List packages installed in system profile.
	environment.systemPackages = with pkgs; [
		firefox
		obsidian
		gimp
	];
}
