{ name, lib, nix-net-lib }:

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
	domain = (mkStrOption "The name of the network")
		// (mkReadOnly name);

	ipv4 = lib.mkOption {
		description =  "The ip address of the network followed by the netmask";
		type = lib.types.nullOr nix-net-lib.lib.types.ip4Network;
		example = "1.2.3.4/5";
		default = null;
	};
}

