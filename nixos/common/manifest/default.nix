{ config, lib, jc-lib, settings, ... }:

let
	cfg = config.common.manifest;
	self-manifest = cfg.self;

	hosts-dir = "${settings.dotfiles_store_path}/nixos/hosts";
	# hosts-name = (
	# 	lib.attrsets.mapAttrsToList (name: _: name) (
	# 		lib.attrsets.filterAttrs
	# 		(
	# 			name: value:
	# 			!(lib.strings.hasPrefix "." name) && (value == "directory")
	# 		)
	# 		(builtins.readDir hosts-dir)
	# 	)
	# );

	hosts-name = [ "msi" "asus" ];
in

{
	imports =
	[
		./gpu/nvidia.nix
		./gpu/radeon.nix
	]
	++ lib.lists.optionals (settings.hardware-type == "raspi3") [ ./other/raspi3.nix ];

	config =
	{
		
		# Bluetooth
		# -------------------- #

		common.core.bluetooth.enable = self-manifest.hardware.bluetooth.capable;


		# Audio
		# -------------------- #

		common.core.audio.pulseaudio.enable = self-manifest.hardware.audio.capable;


		# Graphics
		# -------------------- #

		jcconfs.has_de = self-manifest.hardware.graphics.desktop-environment.enable;
		hardware.graphics = {
			enable = self-manifest.hardware.graphics.capable;
			enable32Bit = self-manifest.hardware.graphics.capable && self-manifest.hardware.system == "x86_64-linux";
		};


		# Cpu intel
		# -------------------- #

		boot.initrd.kernelModules = []
			++ lib.optionals (self-manifest.hardware.cpu.intel.architecture != null) [ "i915" ];


		# All manifests
		# -------------------- #
		
		common.manifest.hosts = (
			builtins.listToAttrs (
				builtins.map (
					host-name:
					{
						name = host-name;
						value = import "${hosts-dir}/${host-name}/manifest.nix";
					}
				) (hosts-name)
			)
		);


		# Assertions
		# -------------------- #

		assertions =
		let
			add-assertion = (
				assertion: message:
				{ inherit assertion message; }
			);
		in
		[
			# (add-assertion (config.hardware.cpu.amd.architecture != null || config.hardware.cpu.intel.architecture != null) "Neither amd nor intel cpu architecture has been set")
			(add-assertion (self-manifest.hardware.cpu.intel.architecture != null) "You must set the architecture of the processor!")
			(add-assertion (self-manifest.hardware.graphics.desktop-environment.enable && self-manifest.hardware.graphics.capable) "You can't enable the desktop environment if the device is not capable of graphics!")
		];
	};

	# ------------------------------------------------------------ #

	options.common.manifest =
	let
		get-attr-names = (
			attr:
			lib.attrsets.mapAttrsToList (name: _: name) attr
		);
		hardware-types =
		[
			"desktop"
			"laptop"
			"virtual-machine"
			"raspi3"
		];
		host-options = (
			{ hostname, config, ... }:
			{
				options =
				{
					hardware =
					{
						system = jc-lib.mkStrOptionWexample "The platform the host is running on" "x86_64-linux";
						type = jc-lib.mkEnumOption "What kind of hardware is this host running on" hardware-types;

						audio.capable = jc-lib.mkBoolOption "Whether the host is capable of using audio peripherals";
						bluetooth.capable = jc-lib.mkBoolOption "Whether the host is capable of bluetooth communication";

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
							radeon = {
								architecture = jc-lib.mkNullOrEnumOption "Amd gpu architecture" (get-attr-names cfg.architectures.gpu.radeon);
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

						# network =
						# {
						# 	interfaces =
						# 	{
						# 	};
						# };

						# interfaces =
						# {
						# 	"eno1" =
						# 	{
						# 		mac = "ff:ff:ff:ff:ff:ff";
						# 		type = "ethernet";
						# 		dhcp = true;
						# 	};

						# 	"wlp3s0" =
						# 	{
						# 		mac = "ff:ff:ff:ff:ff:ff";
						# 		type = "wifi";
						# 		dhcp = true;
						# 		ip = "";
						# 	}
						# };

						# pubkeys
						#	ryuji
						#		ssh
						#		wireguard
						#		nixcache

						# running services
						#	nix builder
						#	nix cache

						# network
						#	networks
						#	interfaces
						#		mac address
						#		ip addresses
						#		wol enabled
					};

					# -------------------- #

					software =
					{

					};
				};
			}
		);
	in
	{
		hosts = jc-lib.mkSubmodOption "The manifest for all known nixos devices" (host-options);
		self = lib.mkOption {
			description = "The manifest for all known nixos devices";
			type = lib.types.submodule host-options;
			default = cfg.hosts.${settings.hostname};
		};

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
				radeon = jc-lib.mkSubmodOptionRO "Amd gpu architecures" (
					{ name, ... }:
					{
						options =
						{
							year = (add-year-opt arch-data.gpu.radeon.${name}.year);
						};
					}
				) (add-empty-submod (get-attr-names arch-data.gpu.radeon));

				nvidia = jc-lib.mkSubmodOptionRO "Nvidia gpu architecures" (
					{ name, ... }:
					let
						nvidia-archs = arch-data.gpu.nvidia;
						driver-name = nvidia-archs.${name}.driver-name;
					in
					{
						options =
						{
							year = (add-year-opt arch-data.gpu.nvidia.${name}.year);

							gt-turing = lib.mkOption {
								description = "Whether the gpu has the architecture greater turing";
								type = lib.types.bool;
								default = nvidia-archs.turing.year > nvidia-archs.${name}.year;
								readOnly = true;
							};

							ge-turing = lib.mkOption {
								description = "Whether the gpu has the architecture greater or equal to turing";
								type = lib.types.bool;
								default = nvidia-archs.turing.year >= nvidia-archs.${name}.year;
								readOnly = true;
							};

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
