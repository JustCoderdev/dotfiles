{ config, lib, jc-lib, settings, ... }:

let
	self-manifest = config.common.manifest.self;

	self-hw = self-manifest.hardware;
	self-bluetooth = self-hw.bluetooth;
	self-audio = self-hw.audio;
	self-graphics = self-hw.graphics;
in

{
	imports =
	[
		./gpu/nvidia.nix
		./gpu/radeon.nix
	]
	++ lib.lists.optionals (settings.hardware-type == "raspi3") [ ./special-hardware-type/raspi3.nix ];

	config =
	{
		# Bluetooth
		# -------------------- #

		common.core.bluetooth.enable = lib.mkDefault self-bluetooth.capable;


		# Audio
		# -------------------- #

		common.core.audio.pulseaudio.enable = lib.mkDefault self-audio.capable;


		# Graphics
		# -------------------- #

		jcconfs.has_de = lib.mkDefault self-graphics.desktop-environment.enable;
		system.desktop = {
			i3.enable = lib.mkDefault self-graphics.desktop-environment.enable;
			thunar.enable = lib.mkDefault self-graphics.desktop-environment.enable;
		};

		hardware.graphics = {
			enable = lib.mkDefault self-graphics.capable;
			enable32Bit = lib.mkDefault self-graphics.capable && self-hw.system == "x86_64-linux";
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
		++ lib.lists.optionals (self-graphics.desktop-environment.enable)
		[
			(add-assertion (self-graphics.capable) "You can't enable the desktop environment if the device is not capable of graphics!")
		];
	};
}

