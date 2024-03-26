{ nixpkgs, settings, ... }:

{
	nixpkgs.config.allowUnfree = true;
	virtualisation.virtualbox.host = {
		enable = true;
		enableExtensionPack = true;
	};

	users.users.${settings.username}.extraGroups = [ "vboxusers" ];
}
