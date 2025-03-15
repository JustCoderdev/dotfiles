{ pkgs-unstable, pkgs, settings, inputs, ... }:

let
	inherit (settings) dotfiles_path;
	mdadmhook-url-path = dotfiles_path + "/nixos/secrets/mdadmhook.url";
	duckdns-token-path = dotfiles_path + "/nixos/secrets/duckdns.token";
	cftunnel-cred-path = dotfiles_path + "/nixos/secrets/cloudflare.cred";

	raid-mount = "/mnt/md0";

	config-dir = raid-mount + "/.config";
	log-dir = raid-mount + "/.logs";

	data-dir = raid-mount + "/data";
	game-dir = data-dir + "/game";

	serv-group = "maid";
	openFirewall = true;
in

{
	imports = [
		inputs.nix-minecraft.nixosModules.minecraft-servers
		../../unofficial/prowlarr.nix
	# 	../../unofficial/duckdns.nix
	];

	# nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];


	# Create service group
	users.groups."${serv-group}" = { };


	# MDADM RAID

	system.nixos.tags = [ "mdadm" ];

	# Mdadm configuration
	# <https://discourse.nixos.org/t/i-want-to-create-a-raid0-for-var-but-im-unable-to-figure-how-to-load-mdamd-on-boot/30381/5>
	boot.swraid = {
		enable = true;
		mdadmConf = ''
ARRAY /dev/md0 metadata=1.2 UUID=2789150c:8e613590:21576ee7:a7060788
PROGRAM "curl -s -X POST -H 'content-type: application/json' -d \"{ \\\"content\\\": \\\"$(date) ERROR ''${1}: ''${2}\\\" }\" \"$(cat ${mdadmhook-url-path})\""
'';
	};

	fileSystems."${raid-mount}" = {
		device = "/dev/disk/by-uuid/3e1b8cbb-9c23-4d61-a423-65245733be57";
		fsType = "ext4";
		options = [ "nofail" ];
	};

	systemd.tmpfiles.rules = [
#		Type Path                       Mode User Group          Age Argument
		"d   ${config-dir}              0775 root ${serv-group}"
		"d   ${log-dir}                 0775 root ${serv-group}"

		"d   ${data-dir}                0775 root ${serv-group}"
		"d   ${game-dir}                0775 root ${serv-group}"
		"d   ${data-dir}/documents      0775 root ${serv-group}"

		"d   ${data-dir}/downloads      0775 root ${serv-group}"

		"d   ${data-dir}/media/movie    0775 root ${serv-group}"
		"d   ${data-dir}/media/serie    0775 root ${serv-group}"
		"d   ${data-dir}/music          0775 root ${serv-group}"
	];

	# WAKE ON LAN

	# environment.systemPackages = with pkgs; [ ethtool ];
	# networking.interfaces = {
	# 	"eno1".wakeOnLan.enable = true;
	# };

	# MINECRAFT SERVERS

	services.minecraft-servers = {
		enable = false;
		eula = true;

		dataDir = "${game-dir}/minecraft/";

		servers =
		let
			# <https://minecraft.fandom.com/wiki/Server.properties#Java_Edition_3>
			default-properties = {
				allow-flight = true;
				difficulty = 3; # peaceful, easy, normal, hard
				enforce-whitelist = false;
				force-gamemode = false;
				gamemode = 0; # survival, creative, adventure, spectator
				online-mode = true;
				player-idle-timeout = 0;
				snooper-enabled = false;
			};

				# <https://mcuuid.net/> <https://namemc.com>
			default-whitelist = {
				ryuji_terix = "e2458645-fb10-4065-ac0c-f689aa30adff";
			};
		in
		{
			test-1-12 = {
				enable = true;
				package = pkgs.vanillaServers.vanilla-1_12_2;
				openFirewall = true;

				jvmOpts = "-Xms4092M -Xmx6144M";

				serverProperties = default-properties // {
					level-name = "world";
					max-players = 5;
					motd = "Test vanilla 1.12.2";

					server-port = 25565;
					white-list = false;
				};

				whitelist = default-whitelist // { };
			};

			# test-forge-1-12 = {
			# 	enable = true;
			# 	package = pkgs.vanillaServers.forge-1_12_2;
			# 	openFirewall = true;

			# 	jvmOpts = "-Xms4092M -Xmx6144M";

			# 	serverProperties = default-properties // {
			# 		level-name = "world";
			# 		max-players = 5;
			# 		motd = "Test forge 1.12.2";

			# 		server-port = 25566;
			# 		white-list = false;
			# 	};

			# 	whitelist = default-whitelist // { };
			# };

		};
	};

	# TUNNEL

	# services.cloudflared = {
	# 	enable = true;
	# 	tunnels."local" = {
	# 		credentialsFile = "${cftunnel-cred-path}";
	# 		default = "http_status:404";
	# 		# ingress = {
	# 		# 	"*.domain1.com" = {
	# 		# 		service = "http://localhost:80";
	# 		# 	};
	# 		# };
	# 	};
	# };

	# DNS

	# services.duckdns = {
	# 	enable = true;
	# 	domains = [ "thefoxburrow" ];
	# 	tokenFile = duckdns-token-path;
	# };

	# HOST PROXY

	networking.firewall.allowedTCPPorts = [ 80 443 ];
	services.nginx = {
		enable = true;

		# src <https://nixos.org/manual/nixos/stable/#module-security-acme-nginx>
		virtualHosts."quiss.host.local" = {
			# addSSL = true;
			# enableACME = true;
			root = "/var/www/quiss";

			locations = {
				# "/prowlerr/".proxyPass = "http://127.0.0.1:9696";

				# "^~ /jellyfin/" = {
				# 	proxyPass = "http://127.0.0.1:8096/";

				# 	# <https://forum.jellyfin.org/t-nginx-proxy-manager-config?pid=42446#pid42446>
				# 	extraConfig = ""
				# 		+ "proxy_set_header Host $host;\n"
				# 		+ "proxy_set_header X-Real-IP $remote_addr;\n"
				# 		+ "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n"
				# 		+ "proxy_set_header X-Forwarded-Proto $scheme;\n"
				# 		+ "proxy_set_header X-Forwarded-Host $http_host;\n"
				# 		+ "proxy_buffering off;\n"

				# 		+ "sub_filter '/web/' '/jellyfin/web/';\n"
				# 		+ "sub_filter '/socket' '/jellyfin/socket';\n"
				# 		+ "sub_filter '/api/' '/jellyfin/api/';\n"
				# 		+ "sub_filter '/touchicon' '/jellyfin/web/touchicon'; # Redireccionar iconos\n"
				# 		+ "sub_filter_once off;\n"

				# 		+ "rewrite /jellyfin/(.*) /$1 break;\n"
				# 		+ "";
				# };
			};

			# extraConfig = ""
			# 	+ "client_max_body_size 20M;\n"
			# 	+ "add_header X-Content-Type-Options \"nosniff\";\n"
			# 	+ "";
		};
	};

	# security.acme = {
	# 	acceptTerms = true;
	# 	defaults.email = "107036402+JustCoderdev@users.noreply.github.com";
	# };

	# TORRENT TRACKER

	# services.jackett = {
	# 	package = pkgs-unstable.jackett;
	# 	inherit openFirewall;
	# 	enable = true;

	# 	dataDir = config-dir + "/jackett";

	# 	group = serv-group;
	# };

	# TORRENT TRACKER AND INDEXER

	# unofficial.services.prowlarr = {
	# 	inherit openFirewall;
	# 	enable = true;

	# 	reverseProxyURL = "/prowlarr";

	# 	dataDir = config-dir + "/prowlarr";

	# 	group = serv-group;
	# };

	# MOVIE DOWNLOADER

	# services.radarr = {
	# 	package = pkgs-unstable.radarr;
	# 	inherit openFirewall;
	# 	enable = true;

	# 	dataDir = config-dir + "/radarr";

	# 	group = serv-group;
	# };

	# SERIE DOWNLOADER

	# services.sonarr = {
	# 	inherit openFirewall;
	# 	enable = true;

	# 	dataDir = config-dir + "/sonarr";

	# 	group = serv-group;
	# };

	# MEDIA PLAYER

	# services.jellyfin = {
	# 	inherit openFirewall;
	# 	enable = true;

	# 	dataDir = data-dir + "/jellyfin";
	# 	configDir = config-dir + "/jellyfin";
	# 	logDir = log-dir + "/jellyfin";

	# 	group = serv-group;
	# };

	# Network

	# Fix hangup
	# systemd.network.wait-online.enable = false;
	# boot.initrd.systemd.network.wait-online.enable = false;

	networking = {
		useDHCP = false;

		nftables.enable = false;
		networkmanager.unmanaged = [ "interface-name:enp8s2" ];
		firewall.trustedInterfaces = [ "enp8s2" ];

		interfaces = {
			# br0.useDHCP = true;      # eno1   -> gateway
########################################################
			br0 = {
				useDHCP = false;
				ipv4.addresses = [{
					address = "192.168.7.69";
					prefixLength = 24;
				}];
			};
########################################################
			br1 = {
				useDHCP = false;
				ipv4.addresses = [{  # enp8s2 -> display
					address = "192.168.1.25";
					prefixLength = 24;
				}];
			};
		};

		bridges = {
			br0.interfaces = [ "eno1" ];
			br1.interfaces = [ "enp8s2" ];
		};
	};

	# WIRESHARK

	programs.wireshark.enable = true;
	environment.systemPackages = with pkgs; [ wireshark qemu ];
	users.users.${settings.username}.extraGroups = [ "wireshark" "libvirtd" ];
	# users.groups.wireshark = { };

	# KVM

	#environment.systemPackages = with pkgs; [ qemu ];
	programs.virt-manager.enable = true;

	# users.users.${settings.username}.extraGroups = [ "libvirtd" ];
	virtualisation.libvirtd = {
		enable = true;
		allowedBridges = [ "br0" "br1" ];

		qemu = {
			package = pkgs.qemu_kvm;
			runAsRoot = true;

			swtpm.enable = true;
			ovmf = {
				enable = true;
				packages = with pkgs; [
					(OVMF.override { secureBoot = true; tpmSupport = true; }).fd
				];
			};
		};
	};
}
