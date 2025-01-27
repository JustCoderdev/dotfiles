{ settings, ... }:

# Examples used
# <https://github.com/nix-community/disko/blob/master/example/boot-raid1.nix>
# <https://github.com/nix-community/disko/blob/master/example/mdadm-raid0.nix>

# lsblk
# sudo fdisk -l

let

	# Disk partitions

	boot-partition = {
		type = "EF02"; # for grub MBR
		size = "1M";
		priority = 1;
	};

	esp-partition = {
		name = "ESP";

		type = "EF00";
		size = "500M";

		content = {
			type = "filesystem";
			format = "vfat";
			mountpoint = "/boot";
			mountOptions = [ "umask=0077" ];
		};
	};

	root-partition = {
		end = "-8G";
		content = {
			type = "filesystem";
			format = "ext4";
			mountpoint = "/";
		};
	};

	swap-partition = {
		name = "swap";
		size = "8G";
		content = {
			type = "swap";
		};
	};

	mdadm-partition = {
		size = "100%";
		content = {
			name = "raid1";
			type = "mdraid";
		};
	};

	# Disk configuration

	# 931,51 GiB - 28A68E71-8241-4554-8EDE-4396593D1548
	WDC-WD10EVVS-63M-sda-config = {
		device = "/dev/sda";
		type = "disk";

		content = {
			type = "gpt";
			partitions = {
				mdadm = mdadm-partition;
			};
		};
	};


	# 465,76 GiB - 0x7ad78943
	WDC-WD5000BPKT-2-sdb-config = {
		device = "/dev/sdb";
		type = "disk";

		content = {
			type = "gpt";
			partitions = {
				boot = boot-partition;
				esp  = esp-partition;
				root = root-partition;
				swap = swap-partition;
			};
		};
	};


	# 931,51 GiB - C350FD01-AAA3-474B-96F6-4AE30A61FA4F
	WDC-WD10EVVS-63M-sdc-config = {
		device = "/dev/sdc";
		type = "disk";

		content = {
			type = "gpt";
			partitions = {
				mdadm = mdadm-partition;
			};
		};
	};

	# mdadm raid configurations

	storageconfig = {
		type = "mdadm";
		level = 1;
		content = {
			type = "gpt";
			partitions.primary = {
				size = "100%";
				content = {
					type = "filesystem";
					format = "ext4";
					mountpoint = "/storage";
				};
			};
		};
	};

#	filepath = settings.dotfiles_abspath + "/nixos/secrets/user.mail";
#	usermail = builtins.readFile "${filepath}";
in

{
	system.nixos.tags = [ "disko" ];

	# TODO: Read secreted email

	boot.swraid = {
		enable = true;
		mdadmConf = ''
			MAILADDR 107036402+JustCoderdev@users.noreply.github.com
			MAILFROM mdadm.107036402+JustCoderdev@users.noreply.github.com
		'';
	};

	disko.devices = {
		disk = {
			root = WDC-WD5000BPKT-2-sdb-config;

			leafA = WDC-WD10EVVS-63M-sda-config;
			leafC = WDC-WD10EVVS-63M-sdc-config;
		};

		mdadm = {
			raid1 = storageconfig;
		};
	};
}
