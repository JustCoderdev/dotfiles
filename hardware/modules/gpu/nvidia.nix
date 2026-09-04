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

	offload_available = ge-turing && ge-coffee-lake;

	mkDriver = (args:
		let generic = import (builtins.fetchurl "https://github.com/NixOS/nixpkgs/raw/2b921c4a8074949ff0669ab5e85a6c1c77eda170/pkgs/os-specific/linux/nvidia-x11/generic.nix") args; in
		pkgs.callPackage generic { lib32 = (pkgs.pkgsi686Linux.callPackage generic { libsOnly = true; }).out; }
	);

	legacy_580 = mkDriver {
		version = "580.178.04";
		sha256_64bit = "sha256-WXWobuRb/8tib1GuM9EWmxCBhqLqR61lHnLxP6S21vk=";
		sha256_aarch64 = "sha256-71nsXSSFDhLW91UOwffPhNtTqEzpxj6zulXvXtDE8Ek=";
		openSha256 = "sha256-7eXEROG2rQK9+Ag26nG4jFPrnKeveVUQ0ugIAshJZPQ=";
		settingsSha256 = "sha256-KcrGHoR+ZMdsFyI4myU8/eVls2f8GkNSX/j2JnZndyM=";
		persistencedSha256 = "sha256-3Omj160wtWdKAZDzWt/m/cbUTQ9DMJ1rSxMrnIrKXiw=";
	};
in

{
	config =
	{
		system.nixos.tags = [ "nvidia" ];

		hardware.graphics.enable = true;
		services.xserver.videoDrivers = lib.optionals (desktop_environment_available)
		(
			[ "nvidia" ]
			++ lib.optional (cpu_is_intel && offload_enable && offload_available) "modesettings"
		);

		hardware.nvidia =
		{
			modesetting.enable = true;
			package = (
				if board.driver-name == "legacy_580" then legacy_580
				else config.boot.kernelPackages.nvidiaPackages.${board.driver-name}
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
