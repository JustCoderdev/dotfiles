{ lib, pkgs, ... }:

let
	id-from-name = (
		name:
		builtins.replaceStrings [" "] ["_"]
			(lib.strings.toLower name)
	);
	add-light = (
		where: name:
		lib.attrsets.nameValuePair
			(id-from-name name)
			({ inherit where name; })
	);
	add-climate = (
		zone: name:
		lib.attrsets.nameValuePair (id-from-name name) (
			{
				inherit zone name;
				heat = true;
				cool = false;
				standalone = true;
			}
		)
	);
	add-cover = add-light;
	lights =
	[
		(add-light 11 "Luce Entrata")
		(add-light 24 "Luce Corridoio")

		(add-light 12 "Luce Salotto EST")
		(add-light 13 "Luce Salotto OVEST")
		(add-light 14 "Luce Salotto SUD")
		(add-light 22 "Luce Salotto Balcone EST")
		(add-light 23 "Luce Salotto Balcone OVEST")

		(add-light 15 "Luce Cucina SUD")
		(add-light 16 "Luce Cucina EST")
		(add-light 17 "Luce Cucina Piano Lavoro")
		(add-light 18 "Luce Cucina OVEST")
		(add-light 21 "Luce Cucina Balcone")

		(add-light 31 "Luce Matrimoniale")
		(add-light 32 "Luce Matrimoniale Alto")
		(add-light 33 "Luce Matrimoniale Balcone")

		(add-light 34 "Luce Cameretta")

		(add-light 35 "Luce Bagno")
		(add-light 36 "Luce Bagno Specchio")
	];
	climates =
	[
		(add-climate 1 "Termostato Salotto")
		(add-climate 2 "Termostato Matrimoniale")
		(add-climate 3 "Termostato Cameretta")
		(add-climate 4 "Termostato Bagno")
	];
	covers =
	[
		(add-cover 41 "Tapparella Salotto OVEST 1")
		(add-cover 42 "Tapparella Salotto OVEST 2")
		(add-cover 43 "Tapparella Salotto SUD")

		(add-cover 44 "Tapparella Cucina SUD")
		(add-cover 45 "Tapparella Cucina EST")

		(add-cover 46 "Tapparella Matrimoniale")

		(add-cover 47 "Tapparella Cameretta EST")
		(add-cover 48 "Tapparella Cameretta NORD")

		(add-cover 49 "Tapparella Bagno")
	];
in
(pkgs.formats.yaml {}).generate "myhome-nix.yaml"
{
	hl4684 =
	{
		mac = "00:03:50:01:06:48";
		light = builtins.listToAttrs lights;
		climate = builtins.listToAttrs climates;
		cover = builtins.listToAttrs covers;
	};
}
