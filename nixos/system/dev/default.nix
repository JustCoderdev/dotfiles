{ config, lib, settings, ... }:

let
	cfg = config.system.dev;

	inherit (settings) username;
	uhome = "/home/${username}";
in

{
	imports = [
		./android.nix
		./arduino.nix
		./c.nix
		./net.nix
	];

	config =
	{
		systemd.tmpfiles.rules = lib.mkIf (cfg.enable)
		[
#			Type Path                        Mode User     Group Age Argument
			"d   ${uhome}/Developer          0755 ${username} users"
			"d   ${uhome}/Developer/Github   0755 ${username} users"
			"d   ${uhome}/Developer/Projects 0755 ${username} users"
		];
	};

	# ------------------------------------------------------------ #

	options.system.dev = 
	{
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Enable development environment";
			default = false;
		};
	};
}

