{ config, lib, jc-lib, settings, ... }:

let
	self-manifest = config.common.manifest.self;

	networks-list = import ./network/networks-list.nix;
in

{
	config =
	{
		# Put network hosts in manifest
		# -------------------- #
		# common.manifest.networks =

		# common.manifest.networks = (
		# 	builtins.listToAttrs (
		# 		builtins.map (
		# 			network:
		# 			{
		# 				name = network.name;
		# 				value =
		# 				{
		# 					# hosts = ();
		# 				};
		# 			}
		# 		) (common.manifest.networks)
		# 	)
		# );
	};
}

