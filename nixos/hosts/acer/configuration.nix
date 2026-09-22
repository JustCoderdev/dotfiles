{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [ geteduroam ];
	programs.nm-applet.enable = true;

	# For:
	# - Sebastian League's Digital Logic Sim
	programs.nix-ld.enable = true;

	_experimental.nix6OS =
	{
		enable = true;
		fs-uuid = "EF07-9D32";
	};
}

