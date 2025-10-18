{ config, lib, jc-lib, ... }:

let
	cfg = config.common.core.hardware-manifest;

	# hosts-name = (
	# 	lib.attrsets.mapAttrsToList (name: _: name) (
	# 		lib.attrsets.filterAttrs
	# 		(
	# 			name: value:
	# 			!(lib.strings.hasPrefix "." name) && (value == "directory")
	# 		)
	# 		(builtins.readDir ./.)
	# 	)
	# );

	hosts-name = [ "msi" ];
in

{
	config.common.core.hardware-manifest =
	{
		hosts = (
			builtins.listToAttrs (
				builtins.map (
					host-name:
					{
						name = host-name;
						value = import ./${host-name}/manifest.nix;
					}
				) (hosts-name)
			)
		);
	};

	# ------------------------------------------------------------ #

	options.common.core.hardware-manifest =
	let
		get-attr-names = (
			attr:
			lib.attrsets.mapAttrsToList (name: _: name) attr
		);
	in
	{
		hosts = jc-lib.mkSubmodOption "The manifest for all known nixos devices" (
			{ hostname, config, ... }:
			{
				options =
				{
					hardware =
					{
						system = jc-lib.mkStrOptionWexample "The platform the host is running on" "x86_64-linux";

						cpu =
						let
							has-iGPU = lib.mkEnableOption "Has integrated gpu (for laptops)";
						in
						{
							# amd = {
							# 	inherit has-iGPU;
							# 	architecture = jc-lib.mkNullOrEnumOption "Amd cpu architecture" (get-attr-names cfg.architectures.cpu.amd);
							# };
							intel = {
								inherit has-iGPU;
								architecture = jc-lib.mkNullOrEnumOption "Intel cpu architecture" (get-attr-names cfg.architectures.cpu.intel);
							};
						};

						gpu =
						{
							# intel = {};
							amd = {
								architecture = jc-lib.mkNullOrEnumOption "Amd gpu architecture" (get-attr-names cfg.architectures.gpu.amd);
							};

							nvidia = {
								architecture = jc-lib.mkNullOrEnumOption "Nvidia gpu architecture" (get-attr-names cfg.architectures.gpu.nvidia);
								offload = {
									enable = lib.mkOption {
										description = "Whether to enable gpu offload";
										type = lib.types.bool;
										default = config.hardware.cpu.intel.has-iGPU;
									};
									intelBusId = jc-lib.mkNullOrStrOption "Intel bus id";
									nvidiaBusId = jc-lib.mkNullOrStrOption "Nvidia bus id";
								};
							};
						};

						graphics =
						{
							enable = lib.mkEnableOption "Whether to graphics support";
							desktop-environment.enable = lib.mkEnableOption "Should enable xserver suite of tools";
							displays = jc-lib.mkSubmodOption "All displays connected to device" (
								{
									options = {
										identifier = jc-lib.mkStrOptionWexample "The identifier of the display given by `xrandr -q`" "DP-0";
										resolution = jc-lib.mkStrOptionWexample "The resolution of the display" "1920x1080";
										position = jc-lib.mkStrOptionWexample "The position relative to other displays" "1920x0";
									};
								}
							);
						};
					};

					# -------------------- #

					software =
					{

					};
				};
			}
		);

		architectures =
		let
			add-year-opt = jc-lib.mkIntOptionRO "The year the architecture was released";
			arch-data = import ./architectures.nix;
			add-empty-submod = (
				name-list:
				builtins.listToAttrs (
					builtins.map (
						name:
						{
							inherit name;
							value = { };
						}
					) name-list
				)
			);
		in
		{
			cpu = 
			{
				# amd = [ "" "" ];

				intel = jc-lib.mkSubmodOptionRO "Intel cpu architecures" (
					{ name, ... }:
					{
						options =
						{
							year = (add-year-opt arch-data.cpu.intel.${name}.year);
						};
					}
				) (add-empty-submod (get-attr-names arch-data.cpu.intel));
			};

			# -------------------- #

			gpu = 
			{
				amd = jc-lib.mkSubmodOptionRO "Amd gpu architecures" (
					{ name, ... }:
					{
						options =
						{
							year = (add-year-opt arch-data.gpu.amd.${name}.year);
						};
					}
				) (add-empty-submod (get-attr-names arch-data.gpu.amd));

				nvidia = jc-lib.mkSubmodOptionRO "Nvidia gpu architecures" (
					{ name, ... }:
					let
						driver-name = arch-data.gpu.nvidia.${name}.driver-name;
					in
					{
						options =
						{
							year = (add-year-opt arch-data.gpu.nvidia.${name}.year);
							driver = {
								name = jc-lib.mkNullOrStrOptionRO "The name of the driver package for this gpu" driver-name;
								pkg = lib.mkOption {
									description = "The driver package for this gpu";
									type = lib.types.package;
									default = if driver-name == null then null else config.boot.kernelPackages.nvidiaPackages.${driver-name};
									readOnly = true;
								};
							};
						};
					}
				) (add-empty-submod (get-attr-names arch-data.gpu.nvidia));
			};
		};
	};
}
