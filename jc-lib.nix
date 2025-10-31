{ lib }:

let
	inherit (lib) mkOption types;

	regex = {
		address = {
			mac = "^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$";
			# ipv4 = "^(?:(?:25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\\.){3}(?:25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])$";
		};
	};
in

{
	inherit regex;

	# Null or type RO
	# ---------------------------------------- #

	mkNullOrStrOptionRO = (
		description: default:
		mkOption {
			inherit description default;
			type = types.nullOr types.str;
			readOnly = true;
		}
	);

	mkNullOrIntOptionRO = (
		description: default:
		mkOption {
			inherit description default;
			type = types.nullOr types.int;
			readOnly = true;
		}
	);

	mkNullOrEnumOptionRO = (
		description: enum-items: default:
		mkOption {
			inherit description default;
			type = types.nullOr (types.enum enum-items);
			readOnly = true;
		}
	);


	# Type RO
	# ---------------------------------------- #

	mkSubmodOptionRO = (
		description: submodule: default:
		mkOption {
			inherit description default;
			type = types.attrsOf (types.submodule (submodule));
			readOnly = true;
		}
	);

	mkStrOptionRO = (
		description: default:
		mkOption {
			inherit description default;
			type = types.str;
			readOnly = true;
		}
	);

	mkIntOptionRO = (
		description: default:
		mkOption {
			inherit description default;
			type = types.int;
			readOnly = true;
		}
	);

	# Type
	# ---------------------------------------- #

	mkStrOption = (
		description:
		mkOption {
			inherit description;
			type = types.str;
		}
	);

	mkStrRXOption = (
		description: regex:
		mkOption {
			inherit description;
			type = types.strMatching regex;
		}
	);

	mkIntOption = (
		description:
		mkOption {
			inherit description;
			type = types.int;
		}
	);

	mkBoolOption = (
		description:
		mkOption {
			inherit description;
			type = types.bool;
		}
	);

	mkStrOptionWexample = (
		description: example:
		mkOption {
			inherit description example;
			type = types.str;
		}
	);

	mkListOption = (
		description: subtype:
		mkOption {
			inherit description;
			type = types.listOf subtype;
			default = [ ];
		}
	);

	mkAttrsOption = (
		description: subtype:
		mkOption {
			inherit description;
			type = types.attrsOf subtype;
			default = { };
		}
	);

	mkSubmodOption = (
		description: submodule:
		mkOption {
			inherit description;
			type = types.attrsOf (types.submodule (submodule));
			default = { };
		}
	);

	mkEnumOption = (
		description: enum-items:
		mkOption {
			inherit description;
			type = types.enum enum-items;
		}
	);

	# Null or type
	# ---------------------------------------- #

	mkNullOrStrOption = (
		description:
		mkOption {
			inherit description;
			type = types.nullOr types.str;
			default = null;
		}
	);

	mkNullOrStrRXOption = (
		description: regex:
		mkOption {
			inherit description;
			type = (types.nullOr (types.strMatching regex));
			default = null;
		}
	);

	mkNullOrEnumOption = (
		description: enum-items:
		mkOption {
			inherit description;
			type = types.nullOr (types.enum enum-items);
			default = null;
		}
	);
}

