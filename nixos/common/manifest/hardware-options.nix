{ config, lib, nix-net-lib, ... }:

let
	# TODO: Understand WTF is wrong with jchw as specialArgs
	get-attrs =
	(
		list:
		builtins.listToAttrs (builtins.map (val: { name = val; value = val; }) list)
		// { all = list; }
	);

	jchw = {
		system = get-attrs [ "x86_64-linux" ];
		type   = get-attrs [ "desktop" "laptop" "virtual-machine" "raspi3" ];
	};
in

let
	mkSubmodOption = (
		description: submodule:
		lib.mkOption {
			inherit description;
			type = lib.types.attrsOf (lib.types.submodule (submodule));
			default = { };
		}
	);

	int-opt = (
		description:
			lib.mkOption {
			inherit description;
			type = lib.types.int;
		}
	);

	str-opt = (
		description:
			lib.mkOption {
			inherit description;
			type = lib.types.str;
		}
	);

	nullable-attrs-opt = (
		type:
		lib.mkOption {
			type = lib.types.nullOr (lib.types.attrsOf type);
			default = null;
		}
	);

	bool-opt = (
		description:
		lib.mkOption {
			description = "Whether ${description}";
			type = lib.types.bool;
			example = false;
		}
	);

	enum-opt = (
		description: list:
		lib.mkOption {
			description = "The kind of ${description}";
			type = lib.types.enum list;
			example = builtins.elemAt 0 list;
		}
	);

	nullable-str-opt = (
		description:
		lib.mkOption {
			inherit description;
			type = lib.types.nullOr lib.types.str;
			default = null;
		}
	);

	# Composite options
	# -------------------- #

	arch-opts =
	{
		name = str-opt "The name of the architecture";
		year = int-opt "The year the architecture was released";
	};
in

{
	options.hardware =
	{
		system = enum-opt "platform the host is running on"  jchw.system.all;
		type   = enum-opt "hardware is this host running on" jchw.type.all;

		audio.capable     = bool-opt "the hardware is audio capable";
		bluetooth.capable = bool-opt "the hardware is bluetooth capable";

		# -------------------- #

		cpu = nullable-attrs-opt
		{
			name     = str-opt "The name of the processor";
			cores    = int-opt "The core count of the processor";
			year     = int-opt "The year the processor was released";
			has-igpu = bool-opt "the processor has an integrated gpu";
			arch     = arch-opts;
		};

		# -------------------- #

		gpu = nullable-attrs-opt
		{
			name   = str-opt "The name of the board";
			year   = int-opt "The year the board was released";
			driver = str-opt "The name of the driver package for this board";
			arch   = arch-opts;
		};

		gpu_offload =
		{
			# add checks to see if it can offload at all
			enable      = lib.mkEnableOption "to enable gpu offload";
			intelBusId  = nullable-str-opt "Intel bus id";
			nvidiaBusId = nullable-str-opt "Nvidia bus id";
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

