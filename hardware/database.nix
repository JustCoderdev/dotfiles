let
	get-attrs =
	(
		list:
		builtins.listToAttrs (builtins.map (val:
			if builtins.isAttrs val then { inherit (val) name; value = val; }
			else if builtins.isString val then { name = val; value = val; }
			else abort "cannot get attrs")
		list)
		// { all = list; }
	);
in
rec {
	system = get-attrs [ "x86_64-linux" ];
	type   = get-attrs [ "desktop" "laptop" "virtual-machine" "raspi3" ];

	cpu =
	let arch = architecture.cpu; in
	{
		intel = get-attrs (import ./cpu/intel/processor.nix arch.manufacturer.intel arch.intel);
	};

	gpu =
	let arch = architecture.gpu; in
	{
		nvidia = get-attrs (import ./gpu/nvidia/board.nix arch.manufacturer.nvidia arch.nvidia);
		radeon = get-attrs (import ./gpu/radeon/board.nix arch.manufacturer.radeon arch.radeon);
	};

	architecture =
	{
		cpu =
		{
			manufacturer = get-attrs [ "intel" ];
			intel = let arch = (import ./cpu/intel/architecture.nix); in
			{
				atom = get-attrs arch.atom;
				core = get-attrs arch.core;
			};
		};

		gpu =
		{
			manufacturer = get-attrs [ "nvidia" "radeon" ];
			nvidia = get-attrs (import ./gpu/nvidia/architecture.nix);
			radeon = get-attrs (import ./gpu/radeon/architecture.nix);
		};
	};
}
