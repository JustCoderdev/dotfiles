let
	# ------------------------------------------------------------ #
	# -------------------START OF TEST---------------------------- #
	# ------------------------------------------------------------ #

	test-type =
	rec {
		# Utils
		new-type = name: matchFn: isAtomic: { __jc_type = name; __jc_isSameAs = matchFn; __jc_isAtomicType = isAtomic; __jc_isOptional = false; };

		# External Interface
		# -------------------- #

		TYPE-OF-TYPE = set
		{
			__jc_type         = enum str [ ];
			__jc_isSameAs     = func;
			__jc_isAtomicType = bool;
			__jc_isOptional   = bool;

			# __jc_subtype     = opt TYPE-OF-TYPE;
			# __jc_setdef      = opt list set { name = str; value = TYPE-OF-TYPE; };
			# __jc_valid_vals  = opt list __jc_subtype;
		};

		opt = type: type // { __jc_isOptional = true; };

		# Types
		free = new-type "free"     (_: true)        false;

		str  = new-type "string"   builtins.isStr   true;
		int  = new-type "integer"  builtins.isInt   true;
		bool = new-type "bool"     builtins.isBool  true;
		flt  = new-type "float"    builtins.isFloat true;
		pth  = new-type "path"     builtins.isPath  true;
		func = new-type "func"     builtins.isFunc  true;

		set  = def: (new-type "set"  builtins.isAttrs false)  // { __jc_sdef;

		list = subtype:              new-list-type "list" builtins.isList            subtype;
		enum = subtype: valid-vals: (new-list-type "enum" subtype.__jc_baseMatchFunc subtype) // { __jc_valid_values = valid-vals; };


		# Functions
		# -------------------- #

		doMatch =
		(
			type: value:
			# TODO: Assert that `type` is a Type
			assert builtins.isAttrs type;
			assert type ? "__jc_type";
			assert type ? "__jc_isSameAs";
			assert type ? "__jc_isAtomicType";
			# Base types
			if type.__jc_sameAs value then false
			else if type.__jc_isAtomicType then true

			else (
				# Set type
				if type.__jc_type == set.__jc_type
				then
					assert builtins.isAttrs type.__jc_subtype;
					assert type ? "__jc_subtype";
					builtins.isAttrs value
					&& builtins.attrNames value == builtins.attrNames type.__jc_subtype
					&& builtins.all (attrname: doMatch type."${attrname}" value."${attrname}") builtins.attrNames value
				else
				(
				# List and Enum types
					abort "unknown type"
				)
			)
		);
	# ------------------------------------------------------------ #
	# --------------------END OF TEST----------------------------- #
	# ------------------------------------------------------------ #

	# ------------------------------------------------------------ #

	type =
	rec {
		# Types
		# -------------------- #

		# BaseType := { __jc_type: String; }
		# SetType  := { __jc_type: String; __jc_set: [ { name: String; value: Type } ]; }
		# ListType := { __jc_type: String; __jc_subtype: Type; }
		# EnumType := { __jc_type: String; __jc_subtype: Type; __jc_valid_values: [Any] }
		new-base-type = type:             { __jc_type = type;                         };
		new-rec-type  = type: definition: { __jc_type = type; __jc_def = definition;  };

		str  = new-base-type "string";
		int  = new-base-type "integer";
		bool = new-base-type "bool";
		flt  = new-base-type "float";
		pth  = new-base-type "path";

		set  = definition: new-rec-type "set"  definition;
		list = definition: new-rec-type "list" definition;

		enum = subtype: valid-vals: (new-rec-type "enum" subtype) // { __jc_valid_values = valid-vals; };


		# Functions
		# -------------------- #

		doMatch =
		(
			type: value:
			assert builtins.isAttrs type;
			assert type ? "__jc_type";
			# Base types
			if      type.__jc_type == str.__jc_type  then builtins.isStr   value
			else if type.__jc_type == int.__jc_type  then builtins.isInt   value
			else if type.__jc_type == bool.__jc_type then builtins.isBool  value
			else if type.__jc_type == flt.__jc_type  then builtins.isFloat value
			else if type.__jc_type == pth.__jc_type  then builtins.isPath  value
			else (
				# Set type
				if type.__jc_type == set.__jc_type
				then
					assert builtins.isAttrs type.__jc_subtype;
					assert type ? "__jc_subtype";
					builtins.isAttrs value
					&& builtins.attrNames value == builtins.attrNames type.__jc_subtype
					&& builtins.all (attrname: doMatch type."${attrname}" value."${attrname}") builtins.attrNames value
				else
				(
				# List and Enum types
					abort "unknown type"
				)
			)
		);

	};
in

with type;

let
	arch-type = struct
	{
		name = str;
		year = int;
	};
in

{
	hardware = struct
	{
		system = enum str [ "x86_64-linux" ];
		type   = enum str [ "desktop" "laptop" "virtual-machine" "raspi3" ];

		cpu = struct
		{
			intel = struct
			{
				name     = str;
				cores    = int;
				year     = int;
				has-igpu = bool;
				arch     = arch-type;
			};
		};
	};
}
