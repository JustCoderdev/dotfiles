database:

{
	cpu, # { manufacturer, arch = { name, year } }
	board, # { name, year, arch = { name, year }, driver-name }

	desktop_environment_available ? false,

	offload_enable ? false,
	offload_intelBusId ? null,
	offload_nvidiaBusId ? null,
}:

{ config, lib, pkgs, ... }:

# TODO: Assert types

assert offload_enable -> (offload_intelBusId != null && offload_nvidiaBusId != null);
assert cpu ? "manufacturer" && cpu ? "arch" && cpu.arch ? "name" && cpu.arch ? "year";
assert (
	board ? "name"
		&& board.name != null
	&& board ? "year"
	&& board ? "arch"
		&& board.arch ? "name"
		&& board.arch ? "year"
	&& board ? "driver-name"
);

let
	inherit (database) architecture;

	cpu_is_intel = cpu.manufacturer == architecture.cpu.manufacturer.intel;
	# cpu_is_amd = cpu.manufacturer == architecture.cpu.manufacturer.amd;

	ge-turing = board.year >= architecture.gpu.nvidia.turing.year;
	ge-coffee-lake = cpu_is_intel -> (cpu.arch.year >= architecture.cpu.intel.coffee-lake.year);

	# NOTE: the wiki says that offload is available only when
	# `ge-turing && ge-coffee-lake` but it's not true! as asus is completely
	# fine with it (apart from the fact that X doesn't start without...)
	offload_available = true;
in

{
	config =
	{
		system.nixos.tags = [ "nvidia" ];

		hardware.graphics.enable = true;
		services.xserver.videoDrivers = lib.optionals (desktop_environment_available)
		(
			[ "nvidia" ]
			++ lib.optional (cpu_is_intel && offload_enable && offload_available) "modesetting"
		);

		hardware.nvidia =
		{
			modesetting.enable = true;
			package = (
				# TODO: remove this terrific line once _stable_ 26.05 comes out
				let name = if board.driver-name == "legacy_580" then "stable" else board.driver-name; in
				config.boot.kernelPackages.nvidiaPackages.${name}
			);

			open = ge-turing;  # Use open source driver (Turing or newer)
			nvidiaSettings = false;     # Enable the Nvidia settings menu,

			powerManagement =
			{
				# EXPERIMENTAL: enable if issues with sleep/suspend
				enable = false;
				finegrained = false && ge-turing;  # gpu off when idle (Turing or newer)
			};

			# Hybrid setup (igpu && dgpu)
			# ---------------------------------------- #

			prime = lib.mkIf (offload_available)
			{
				sync.enable        = false && !offload_enable;  # cannot be enabled with offload
				reverseSync.enable = false && !offload_enable;  # EXPERIMENTAL

				offload = lib.mkIf (offload_enable)
				{
					enable = true;
					enableOffloadCmd = true;
				};

				nvidiaBusId = offload_nvidiaBusId;
				intelBusId  = offload_intelBusId;
			};

			# dynamicBoost.enable = true
			# 	&& ge-ampere
			# 	&& cpu_has_igpu
			# 	&& hardware_type == database.type.laptop
			# 	;
		};

		environment.systemPackages = with pkgs; [ nvitop nvtopPackages.nvidia ];
	};
}
