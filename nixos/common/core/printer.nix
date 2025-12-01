# Nixos wiki page
# <https://nixos.wiki/wiki/Printing>

{ config, lib, ... }:

let
	cfg = config.common.core.printing;
in

{
	# Enter CUPS configuration here <http://localhost:631>

	config = lib.mkIf (cfg.enable)
	{
		# Enable CUPS to print documents.
		services.printing.enable = true;
	};

	# ------------------------------------------------------------ #

	options.common.core.printing =
	{
		enable = lib.mkEnableOption "printing support";
	};
}
