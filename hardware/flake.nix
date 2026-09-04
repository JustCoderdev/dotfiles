{
	description = "JC Hardware Database";

	outputs = { ... }:
	rec {
		database = import ./database.nix;

		nixosModules =
		{
			gpu =
			{
				nvidia = import ./modules/gpu/nvidia.nix database;
			};

			special =
			{
				raspi3 = import ./modules/special/raspi3.nix;
			};
		};
	};
}
