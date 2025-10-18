{ lib }:

let
	inherit (lib) mkOption types;
in

{
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
			type = types.nullOr types.str; default = null;
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

