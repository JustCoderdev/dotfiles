{ name, config, lib, jc-lib }:

{
	name = jc-lib.mkStrOptionRO "The name of the network" name;

	# netid = jc-lib.mkStrRXOption "The id of the network" jc-lib.regex.address.ipv4;
	netid = jc-lib.mkStrOption "The id of the network";
	netmask = jc-lib.mkIntOption "The mask of the network";

	domain-lan = lib.mkOption {
		description = "The subdomain name of the network (<hostname>.<domain>.lan)";
		type = lib.types.str;
		default = name;
	};

	hosts = jc-lib.mkSubmodOption "The hosts in this network"
	(
		{ name, ... }:
		{
			config =
			{
				# TODO: should assert that `name` is a valid ip in range of the network id w mask
				# assertions = [ {
				# 	assertion = (builtins.match jc-lib.regex.address.ipv4 name) != null;
				# 	message = "The ip of the host is not an ip ('${name}')";
				# } ];
			};

			options =
			{
				hostname = jc-lib.mkStrOption "The hostname of the device with this ip in this network";
			};
		}
	);
};

