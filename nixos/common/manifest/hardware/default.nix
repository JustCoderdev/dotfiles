{ config, lib, jc-lib, settings, ... }:

let
	self-manifest = config.common.manifest.self;
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
		++ lib.lists.optionals (self-manifest.hardware.system == "x86_64-linux")
		[
			(add-assertion (self-manifest.hardware.cpu.intel.architecture != null) "You must set the architecture of the processor!")
		]
		++ lib.lists.optionals (self-manifest.hardware.graphics.desktop-environment.enable)
		[
			(add-assertion (self-manifest.hardware.graphics.capable) "You can't enable the desktop environment if the device is not capable of graphics!")
		];
	};
}

