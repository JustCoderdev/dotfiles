{ name, lib }:

let
	mkStrOption = (
		description:
		lib.mkOption {
			inherit description;
			type = lib.types.str;
		}
	);

	mkReadOnly = (
		default:
		{ inherit default; readOnly = true; }
	);
in

{
	name = (mkStrOption "The name of the network")
		// (mkReadOnly name);

	# TODO: Check for correctness
	netid = mkStrOption "The id of the network";
	netmask = lib.mkOption {
		description = "The mask of the network";
		type = lib.types.int;
	};

	domain-lan = lib.mkOption {
		description = "The subdomain name of the network (<subdomain>.lan)";
		type = lib.types.str;
		default = name;
	};

	hosts = lib.mkOption {
		description = "The hosts in this network";
		default = { };
		type = lib.types.attrsOf
		(
			lib.types.submodule
			(
				{ name, ... }:
				{
					config =
					{
						# TODO: should assert that `name` is a valid ip in range of the network id w mask
						# assertions = [ {
						# 	assertion = (builtins.match regex.address.ipv4 name) != null;
						# 	message = "The ip of the host is not an ip ('${name}')";
						# } ];
					};

					options =
					{
						hostname = mkStrOption "The hostname of the device with this ip in this network";
					};
				}
			)
		);
	};
}

