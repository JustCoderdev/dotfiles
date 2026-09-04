{ config, lib, ... }:

let
	cfg = config.common.manifest;
	hostname = config.networking.hostName;

	self-manifest = config.common.manifest.self;

	self-hw        = self-manifest.hardware;
	self-bluetooth = self-hw.bluetooth;
	self-audio     = self-hw.audio;
	self-graphics  = self-hw.graphics;

	has-de = self-graphics.desktop-environment.enable;
in

{
	imports =
	[
		./software/list-options.nix

		./software/default.nix
		./networks/default.nix
	];

	# ------------------------------------------------------------ #

	config =
	{
		# Bluetooth
		# -------------------- #

		common.core.bluetooth.enable = lib.mkDefault self-bluetooth.capable;


		# Audio
		# -------------------- #

		common.core.audio.enable = lib.mkDefault self-audio.capable;


		# Graphics
		# -------------------- #

		jcconfs.host.has-de    = lib.mkDefault has-de;
		jcconfs.host.is-laptop = self-hw.type == "laptop";

		common.core.plymouth.enable = lib.mkDefault has-de;
		common.core.fonts.enable    = lib.mkDefault has-de;

		modules.desktop = lib.mkIf (has-de)
		{
			xserver.enable = lib.mkDefault true;
			thunar.enable  = lib.mkDefault true;
		};

		hardware.graphics = lib.mkIf (self-graphics.capable)
		{
			enable      = lib.mkDefault true;
			enable32Bit = lib.mkDefault (self-hw.system == "x86_64-linux");
		};


		# Cpu intel
		# -------------------- #

		boot.initrd.kernelModules = []
			++ lib.optionals (self-hw.cpu.intel.architecture != null) [ "i915" ];


		# Assertions
		# -------------------- #

		assertions =
		let
			add-assertion = (
				assertion: message:
				{ inherit assertion message; }
			);
		in
		[ ]
		++ lib.lists.optionals (self-hw.system == "x86_64-linux")
		[
			(add-assertion (self-hw.cpu.intel.architecture != null) "You must set the architecture of the processor!")
		]
		++ lib.lists.optionals (has-de)
		[
			(add-assertion (self-graphics.capable) "You can't enable the desktop environment if the device is not capable of graphics!")
		];
	};

	# ------------------------------------------------------------ #

	options.common.manifest =
	let
		mkSubmodOption = (
			description: submodule:
			lib.mkOption {
				inherit description;
				type = lib.types.attrsOf (lib.types.submodule (submodule));
				default = { };
			}
		);
	in
	{
		networks = mkSubmodOption "The map of all available networks"
		(
			{ name, config, ... }:
			{
				options = (import ./networks/options.nix { inherit name lib config; });
			}
		);

		hosts = mkSubmodOption "The set with the manifest for registered hosts"
		(
			{ name, ... }:
			{
				imports =
				[
					./hardware-options.nix
					./software-options.nix
				];

				options =
				{
					hostname = lib.mkOption {
						description = "The name of the host of this manifest";
						default = name;
						type = lib.types.str;
						readOnly = true;
					};

					users = lib.mkOption {
						description = "User preferences";
						type = lib.types.listOf lib.types.str;
						default = [ "ryuji" ];
					};
				};
			}
		);

		self = lib.mkOption {
			description = "The manifest for this host";
			type = lib.types.attrs; # type = lib.types.submodule host-options;
			default = cfg.hosts.${hostname};
			readOnly = true;
		};
	};
}
