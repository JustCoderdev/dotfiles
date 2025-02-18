{ ... }:

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

	data-raid-partition = {
		size = "100%";
		content = {
			name = "md0data";
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
				mdadm = data-raid-partition;
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
				mdadm = data-raid-partition;
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
					mountpoint = "/data";
				};
			};
		};
	};

	hook_path = "/etc/mdadmhook.url";
in

{
	system.nixos.tags = [ "disko" ];

	# TODO: Read secreted email
	# TODO: Setup w discord webhooks

	# Mdadm configuration
	# <https://discourse.nixos.org/t/i-want-to-create-a-raid0-for-var-but-im-unable-to-figure-how-to-load-mdamd-on-boot/30381/5>
	boot.swraid = {
		enable = true;
		mdadmConf = ''
			PROGRAM curl -s -X POST -H 'content-type: application/json' -d "{ \"content\": \"$(date) ERROR $${1}: $${2}\" }" "$(cat ${hook_path})"
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
