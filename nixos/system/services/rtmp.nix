# RTMP Configuration snippets by videosdk
# Source <https://www.videosdk.live/developer-hub/rtmp/rtmp-server-nginx>

# Command to stream gopro HERO3 stream
# Source <https://gist.github.com/laurieainley/7663756>
# `ffmpeg -re \
#		-i http://10.5.5.9:8080/live/amba.m3u8 \
#		-c copy -c:a aac -strict experimental -b:a 96k -ac 2 -ar 44100 \
#		-f flv "rtmp:127.0.0.1/live live=1"`

# PyHero to command the gopro remotely
# Source <https://github.com/Splinter0/PyHero>

# FFX: http://127.0.0.1:8080/stat/gopro
# VLC: rtmp://127.0.0.1/gopro
# CMD: ffmpeg -re \
#			-i http://10.5.5.9:8080/live/amba.m3u8 \
#			-c copy -c:a aac -strict experimental -b:a 96k -ac 2 -ar 44100 \
#			-f flv "rtmp:127.0.0.1/gopro live=1"

{ config, lib, pkgs, ... }:

let
	cfg = config.system.services.rtmp;
	rtmp_port = 1935;
in

{
	config =
	{
		networking.firewall.allowedTCPPorts = (lib.mkIf cfg.openFirewall) [ rtmp_port ];
		environment.systemPackages =  [ pkgs.ffmpeg ];

		services.nginx = (lib.mkIf cfg.proxy.enable)
		{
			enable = true;
			additionalModules = [ pkgs.nginxModules.rtmp ];

			appendConfig = ''
error_log logs/error.log warn;

rtmp {
	server {
		listen 1935;
		chunk_size 4096;

		application gopro {
			live on;

			# Record
			record all;
			record_path /tmp/av;
			record_max_size 1K;
			record_unique on;

			# Allow only localhost
			allow publish 127.0.0.1;
			deny publish all;

			exec_static ${pkgs.ffmpeg}
				-loglevel verbose
				-re -i http://10.5.5.9:8080/live/amba.m3u8
				-c copy -c:a aac
				-strict experimental
				-b:a 96k -ac 2
				-ar 44100 -f flv
				"rtmp:127.0.0.1/gopro/live live=1";
		}


		application relay {
			live on;


			# --- Recording --- #

			record off;
			# record all;
			# record_path /var/recordings;


			# --- HTTP Live Streaming --- #
			# hls on;
			# hls_path /tmp/hls;
			# hls_fragment 3;

			# dash on;
			# dash_path /tmp/dash;


			# --- Block / Allow Policy --- #
			allow publish 127.0.0.1;
			# allow publish 10.5.5.9;
			deny publish all;
			allow play all;
		}
	}
}
'';
			appendHttpConfig = ''
	server {
		listen 8080;


		# --- Live stream page --- #

		location /live {
			root /tmp;
		}


		# --- Stat page --- #

		location /stat {
			rtmp_stat all;
			rtmp_stat_stylesheet stat.xsl;
			allow all;
			add_header Refresh "3; $request_uri";
		}

		location /stat.xsl {
			root /tmp/nginx;
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
