{ config, lib, ... }:

let
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
		./gpu/nvidia.nix
		./gpu/radeon.nix
	];

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

		system.desktop = lib.mkIf (has-de)
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
}

