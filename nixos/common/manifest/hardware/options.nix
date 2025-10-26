{ name, lib, config, jc-lib, ... }:

let
	arch-data = import ./processors-architectures.nix;
	hardware-types = [ "desktop" "laptop" "virtual-machine" "raspi3" ];

	get-attr-names = (attr: lib.attrsets.mapAttrsToList (name: _: name) attr);
	add-yearRO-opt = jc-lib.mkIntOptionRO "The year the architecture was released";
in

{
	system = jc-lib.mkStrOptionWexample "The platform the host is running on" "x86_64-linux";
	type = jc-lib.mkEnumOption "What kind of hardware is this host running on" hardware-types;

	audio.capable = jc-lib.mkBoolOption "Whether the host is capable of using audio peripherals";
	bluetooth.capable = jc-lib.mkBoolOption "Whether the host is capable of bluetooth communication";

	# -------------------- #

	cpu =
	let
		has-iGPU = lib.mkEnableOption "Has integrated gpu (for laptops)";
	in
	{
		# amd = {
		# 	inherit has-iGPU;
		# 	architecture = jc-lib.mkNullOrEnumOption "Amd cpu architecture" (get-attr-names arch-data.cpu.amd);
		# };
		intel =
		let
			self = config.hardware.cpu.intel;
			self-arch = self.architecture;
			self-data = arch-data.cpu.intel.${self-arch};
		in
		{
			inherit has-iGPU;
			architecture = jc-lib.mkNullOrEnumOption "Intel cpu architecture" (get-attr-names arch-data.cpu.intel);
			year = (add-yearRO-opt self-data.year);
		};
	};

	# -------------------- #

	gpu =
	{
		# intel = {};
		radeon =
		let
			self = config.hardware.gpu.radeon;
			self-arch = self.architecture;
			self-data = arch-data.gpu.radeon.${self-arch};
		in
		{
			architecture = jc-lib.mkNullOrEnumOption "Amd gpu architecture" (get-attr-names arch-data.gpu.radeon);
			year = (add-yearRO-opt self-data.year);
		};

		nvidia =
		let
			self = config.hardware.gpu.nvidia;
			self-arch = self.architecture;
			self-data = arch-data.gpu.nvidia.${self-arch};
		in
		{
			architecture = jc-lib.mkNullOrEnumOption "Nvidia gpu architecture" (get-attr-names arch-data.gpu.nvidia);
			offload = {
				enable = lib.mkOption {
					description = "Whether to enable gpu offload";
					type = lib.types.bool;
					default = config.hardware.cpu.intel.has-iGPU;
				};
				intelBusId = jc-lib.mkNullOrStrOption "Intel bus id";
				nvidiaBusId = jc-lib.mkNullOrStrOption "Nvidia bus id";
			};

			# -------------------- #

			year = (add-yearRO-opt self-data.year);

			gt-turing = lib.mkOption {
				description = "Whether the gpu has the architecture greater turing";
				type = lib.types.bool;
				default = arch-data.gpu.nvidia.turing.year > self-data.year;
				readOnly = true;
			};

			ge-turing = lib.mkOption {
				description = "Whether the gpu has the architecture greater or equal to turing";
				type = lib.types.bool;
				default = arch-data.gpu.nvidia.turing.year >= self-data.year;
				readOnly = true;
			};

			driver-name = jc-lib.mkNullOrStrOptionRO "The name of the driver package for this gpu" self-data.driver-name;
		};
	};

	# -------------------- #

	graphics =
	{
		capable = jc-lib.mkBoolOption "Whether the host is capable of graphics processing";

		desktop-environment.enable = lib.mkEnableOption "xserver suite";
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
}

