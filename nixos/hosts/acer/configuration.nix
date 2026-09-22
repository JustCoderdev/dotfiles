{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [ geteduroam ];

	# For:
	# - Sebastian League's Digital Logic Sim
	programs.nix-ld.enable = true;

	_experimental.nix6OS =
	{
		enable = true;
		fs-uuid = "EF07-9D32";
	};
}

