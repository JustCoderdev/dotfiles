{ config, lib, pkgs, ... }:

let
	cfg = config.common.core.hardware;
	using-cpu-intel = cfg.cpu.manufacturer == "intel";
	using-gpu-nvidia = cfg.gpu.manufacturer == "nvidia";
	using-gpu-amd = cfg.gpu.manufacturer == "amd";
in

{
	imports = [ ./nvidia.nix ./radeon.nix ];

	config =
	{
		# -- CPU INTEL -- #

		boot.initrd.kernelModules = []
			++ lib.optionals (using-cpu-intel) [ "i915" ];
	};

	# ------------------------------------------------------------ #

	options.common.core.hardware = 
	let
		mkStrOption = (
			description:
			lib.mkOption { inherit description; type = lib.types.nullOr lib.types.str; default = null; }
		);
		mkEnumOption = (
			description: enum-items:
			lib.mkOption { inherit description; type = lib.types.nullOr (lib.types.enum enum-items); default = null; }
		);
	in
	{
		cpu = {
			manufacturer = mkEnumOption "CPU manufacturer" [ "intel" "amd" ];
			architecture = mkStrOption "CPU architecture";
			has-iGPU = lib.mkEnableOption "Has integrated gpu (for laptops)";
		};

		gpu = {
			manufacturer = mkEnumOption "GPU manufacturer" [ "intel" "amd" "nvidia" ];
			architecture = mkStrOption "GPU architecture";
			offload = {
				enable = lib.mkOption {
					description = "Whether to enable gpu offload";
					type = lib.types.bool;
					default = cfg.cpu.has-iGPU;
				};
				intelBusId = mkStrOption "Intel bus id";
				nvidiaBusId = mkStrOption "Nvidia bus id";
			};
		};

		displays = lib.mkOption {
			description = "All displays connected to device";
			default = { };
			type = lib.types.attrsOf (
				lib.types.submodule (
					{
						options = {
							identifier = lib.mkOption {
								description = "The identifier of the display given by `xrandr -q`";
								type = lib.types.str;
								example = "DP-0";
							};

							resolution = lib.mkOption {
								description = "The resolution of the display";
								type = lib.types.str;
								example = "1920x1080";
							};

							position = lib.mkOption {
								description = "The position relative to other displays";
								type = lib.types.str;
								example = "1920x0";
							};
						};
					}
				)
			);
		};
	};
}

