{ lib }:

let
	inherit (lib) mkOption types;
in

{
	mkNullOrStrOptionRO = (
		description:
		mkOption {
			inherit description;
			type = types.nullOr types.str;
			readonly = true;
			default = null;
		}
	);

	mkNullOrEnumOptionRO = (
		description: enum-items:
		mkOption {
			inherit description;
			type = types.nullOr (types.enum enum-items);
			readonly = true;
			default = null;
		}
	);

	# -------------------- #

	mkSubmodOptionRO = (
		description: submodule:
		mkOption {
			inherit description;
			type = types.attrsOf (types.submodule (submodule));
			readonly = true;
			default = { };
		}
	);

	mkIntOptionRO = (
		description:
		mkOption {
			inherit description;
			type = types.int;
			readonly = true;
		}
	);

	# -------------------- #

	mkStrOption = (
		description:
		mkOption {
			inherit description;
			type = types.str;
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

	# -------------------- #

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

