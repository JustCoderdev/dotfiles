# FFX: http://127.0.0.1:8080/stat
# VLC: rtmp://127.0.0.1/gopro

{ config, lib, pkgs, ... }:

let
	cfg = config.system.services.rtmp;
	rtmp_port = 1935;
in

{
	config =
	{
		networking.firewall.allowedTCPPorts = (lib.mkIf cfg.openFirewall) [ rtmp_port ];

		systemd.tmpfiles.rules =
		let
			nginx = config.users.users.nginx;
		in
		[
#			Type Path       Mode User          Group          Age Argument
			"d   /srv/nginx 0711 ${nginx.name} ${nginx.group}"
		];

		services.nginx = (lib.mkIf cfg.proxy.enable)
		{
			enable = true;
			additionalModules = [ pkgs.nginxModules.rtmp ];
			logError = "stderr debug";

			# Sources:
			# - RTMP Directives <https://github.com/arut/nginx-rtmp-module/wiki/Directives>
			# - Snippets by videosdk <https://www.videosdk.live/developer-hub/rtmp/rtmp-server-nginx>
			appendConfig = ''
rtmp {
	server {
		listen ${toString rtmp_port};
		chunk_size 4096;

		application gopro {
			live on;

			# Record
			record off;

			# Allow only localhost
			allow publish 127.0.0.1;
			deny publish all;

			# # HLS 
			# hls on;
			# hls_path /srv/nginx/hls/;

			# # DASH
			# dash on;
			# dash_path /srv/nginx/dash/;

			# Command to stream gopro HERO3 stream
			# Source <https://gist.github.com/laurieainley/7663756>
			exec_pull ${pkgs.ffmpeg}/bin/ffmpeg
				-loglevel verbose
				-re -i http://10.5.5.9:8080/live/amba.m3u8
				-c copy -c:a aac
				-strict experimental
				-b:a 96k -ac 2
				-ar 44100 -f flv
				"rtmp:127.0.0.1/gopro live=1";
		}
	}
}
'';
			appendHttpConfig =
			let
				rtmp = pkgs.fetchFromGitHub {
					owner = "arut";
					repo = "nginx-rtmp-module";
					rev = "61cb33491701632f36faaa331915b857bfc295b2";
					sha256 = "sha256-rK4RY9kxzaXQtzp1vvJ3rEHtt+fcYI5sNMZoYxfZI00=";
				};
			in
''
	server {
		listen 127.0.0.1:8080;

		# --- Stat page --- #

		location /stat {
			rtmp_stat all;
			rtmp_stat_stylesheet stat.xsl;
			add_header Refresh "3; $request_uri";
		}

		location /stat.xsl {
			root ${rtmp.outPath};
		}
	}
'';
		};
	};

	# ------------------------------------------------------------ #

	options.system.services.rtmp =
	{
		enable = lib.mkEnableOption "Enable rtmp support";
		openFirewall = lib.mkEnableOption "Open firewall for all services";

		proxy = {
			enable = lib.mkEnableOption "Add nginx locations for each active services";
			# host = lib.mkOption {
			# 	type = lib.types.str;
			# 	description = "The virtualHost";
			# };
		};
	};
}
