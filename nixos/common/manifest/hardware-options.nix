{ config, lib, nix-net-lib, ... }:

let
	hardware-types = [ "desktop" "laptop" "virtual-machine" "raspi3" ];

	mkReadOnly = (
		default:
		{ inherit default; readOnly = true; }
	);

	mkSubmodOption = (
		description: submodule:
		lib.mkOption {
			inherit description;
			type = lib.types.attrsOf (lib.types.submodule (submodule));
			default = { };
		}
	);

	get-attr-names = (attr: lib.attrsets.mapAttrsToList (name: _: name) attr);
	add-yearRO-opt = (
		year:
		(lib.mkOption {
			description = "The year the architecture was released";
			type = lib.types.int;
		}) // (mkReadOnly year)
	);
in

{
	options.hardware =
	{
		system = lib.mkOption {
			description = "The platform the host is running on";
			type = lib.types.str;
			example = "x86_64-linux";
		};

		type = lib.mkOption {
			description = "What kind of hardware is this host running on";
			type = lib.types.enum hardware-types;
		};

		audio.capable = lib.mkEnableOption "software support for audio";
		bluetooth.capable = lib.mkEnableOption "software support for bluetooth";

		# -------------------- #

		cpu =
		let
			has-iGPU = lib.mkEnableOption "Has integrated gpu (for laptops)";
		in
		{
			# amd = {
			# 	inherit has-iGPU;
			# 	architecture = mkNullOrEnumOption "Amd cpu architecture" (get-attr-names arch-data.cpu.amd);
			# };

			intel =
			let
				self-arch = config.hardware.cpu.intel.architecture;

				intel-data = import ./architectures-list/cpu-intel.nix;
				self-data = intel-data.${self-arch};
			in
			{
				inherit has-iGPU;
				architecture = lib.mkOption {
					description = "Intel cpu architecture";
					type = lib.types.nullOr (lib.types.enum (get-attr-names intel-data));
					default = null;
				};

				# -------------------- #

				year = (add-yearRO-opt self-data.year);

				ge-coffee-lake = lib.mkOption {
					description = "Whether the cpu has the architecture greater coffee lake";
					type = lib.types.bool;
				} // (mkReadOnly (intel-data.coffee-lake.year <= self-data.year));
			};
		};

		# -------------------- #

		gpu =
		{
			# intel = {};
			radeon =
			let
				self-arch = config.hardware.gpu.radeon.architecture;

				radeon-data = import ./architectures-list/gpu-radeon.nix;
				self-data = radeon-data.${self-arch};
			in
			{
				year = (add-yearRO-opt self-data.year);
				architecture = lib.mkOption {
					description = "Amd gpu architecture";
					type = lib.types.nullOr (lib.types.enum (get-attr-names radeon-data));
					default = null;
				};
			};

			nvidia =
			let
				self-arch = config.hardware.gpu.nvidia.architecture;

				nvidia-data = import ./architectures-list/gpu-nvidia.nix;
				self-data = nvidia-data.${self-arch};
			in
			{
				architecture = lib.mkOption {
					description = "Nvidia gpu architecture";
					type = lib.types.nullOr (lib.types.enum (get-attr-names nvidia-data));
					default = null;
				};

				offload = {
					enable = lib.mkOption {
						description = "Whether to enable gpu offload";
						type = lib.types.bool;
						default = config.hardware.cpu.intel.has-iGPU;
					};
					intelBusId = lib.mkOption {
						description = "Intel bus id";
						type = lib.types.nullOr lib.types.str;
						default = null;
					};
					nvidiaBusId = lib.mkOption {
						description = "Nvidia bus id";
						type = lib.types.nullOr lib.types.str;
						default = null;
					};
				};

				# -------------------- #

				year = (add-yearRO-opt self-data.year);

				gt-turing = lib.mkOption {
					description = "Whether the gpu has the architecture greater turing";
					type = lib.types.bool;
				} // (mkReadOnly (self-data.year > nvidia-data.turing.year));

				ge-turing = lib.mkOption {
					description = "Whether the gpu has the architecture greater or equal to turing";
					type = lib.types.bool;
				} // (mkReadOnly (self-data.year >= nvidia-data.turing.year));

				ge-ampere = lib.mkOption {
					description = "Whether the gpu has the architecture greater or equal to ampere";
					type = lib.types.bool;
				} // (mkReadOnly (self-data.year >= nvidia-data.ampere.year));

				driver-name = lib.mkOption {
					description = "The name of the driver package for this gpu";
					type = lib.types.nullOr lib.types.str;
				} // (mkReadOnly self-data.driver-name);
			};
		};

		# -------------------- #

		graphics =
		{
			capable = lib.mkEnableOption "graphics for this host";

			desktop-environment.enable = lib.mkEnableOption "desktop environmnet software suite";
			displays = mkSubmodOption "All displays connected to device" (
				{
					options =
					{
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
			);
		};

		# -------------------- #

		interfaces =
		{
			wireless = mkSubmodOption "Host wireless interfaces"
			(
				{ name, ... }:
				let
					iface-name = name;
					mac-regex = "^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$";
				in
				{
					options =
					{
						mac-addr = lib.mkOption {
							description = "The mac address of the interface";
							type = lib.types.strMatching mac-regex;
						};

						wakeOnWlan.enabled = lib.mkEnableOption "wake on wlan";
						dhcp.enabled = lib.mkEnableOption "dhcp on this interface";

						network =
						{
							# TODO: Use lib.types.oneof
							name = lib.mkOption {
								description = "The name of the network connected to this interface";
								type = lib.types.nullOr lib.types.str;
								default = null;
							};

							# TODO: Use network id to control validity
							ipv4 = lib.mkOption {
								description = "The ip of the interface";
								type = lib.types.nullOr nix-net-lib.lib.types.ip4NoMask;
								default = null;
							};
						};
					};
				}
			);

			wired = mkSubmodOption "Host wired interfaces"
			(
				{ name, ... }:
				let
					iface-name = name;
					mac-regex = "^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$";
				in
				{
					options =
					{
						mac-addr = lib.mkOption {
							description = "The mac address of the interface";
							type = lib.types.strMatching mac-regex;
						};

						wakeOnLan.enabled = lib.mkEnableOption "wake on wlan";
						dhcp.enabled = lib.mkEnableOption "dhcp on this interface";

						network =
						{
							# TODO: Use lib.types.oneof
							name = lib.mkOption {
								description = "The name of the network connected to this interface";
								type = lib.types.nullOr lib.types.str;
								default = null;
							};

							# TODO: Use network id to control validity
							ipv4 = lib.mkOption {
								description = "The ip of the interface";
								type = lib.types.nullOr nix-net-lib.lib.types.ip4NoMask;
								default = null;
							};
						};
					};
				}
			);

			virtual =
			{
				wireguard = mkSubmodOption "Wireguard virtual interfaces"
				(
					{ name, ... }:
					{
						# TODO: Use lib.types.oneof
						name = lib.mkOption {
							description = "The name of the network connected to this interface";
							type = lib.types.nullOr lib.types.str;
							default = null;
						};
						publicKey = lib.mkOption {
							description = "The public key of the host";
							type = lib.types.str;
						};
						ipv4 = lib.mkOption {
							description = "The ip of the interface";
							type = nix-net-lib.lib.types.ip4NoMask;
						};
					}
				);
			};
		};
	};
}

