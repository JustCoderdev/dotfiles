{ config, lib, ... }:

let
	inherit (config.jcconfs) has-de;

	cfg = config.jcconfs.module.i3status;

	col = with config.stylix.base16Scheme;
	{
		error   = base08;
		warning = base0A;
		good    = base0B;
	};
in

{
	config = lib.mkIf (cfg.enable && has-de)
	{
		# i3status configuration file.
		# see "man i3status" for documentation.

		xdg.configFile."i3status/config".enable = false;

		programs.i3status =
		{
			enable = true;
			enableDefault = false;
			package = null;

			general =
			{
				colors = true;
				color_good =     "${col.good}";    # 3DFF33
				color_degraded = "${col.warning}"; # FFC533
				color_bad =      "${col.error}";   # FF3333
				interval = 5;
			};

			modules =
			let
				get-conf = (position: settings: { inherit position settings; });

				mod-wireless = {
					format_up = "%essid%quality (%ip)"; # "%essid%quality (%ip) [%bitrate]"
					format_down = ""; # "Wifi down"
				};

				mod-ethernet = {
					format_up = "eth (%ip) [%speed]"; # "E (%ip) [%speed]"
					format_down = ""; # "Ethernet down"
				};

				mod-vpn = {
					format_up = "wg (%ip)"; # "E (%ip) [%speed]"
					format_down = ""; # "Ethernet down"
				};

				mod-volume = {
					format = "%devicename %volume";
					format_muted = "[%devicename]";
					device = "default";
					mixer = "Master";
				};

				mod-backlight = {
					format = "{%content";
					format_bad = "";
					path = "/sys/class/backlight/intel_backlight/brightness";

					separator = false;
					separator_block_width = 0;
					color_good = "#ffffff";

				};

				mod-backlight-max = {
					format = "/%content}";
					format_bad = "";
					path = "/sys/class/backlight/intel_backlight/max_brightness";

					color_good = "#ffffff";
				};

				mod-battery = {
					format = "%status %percentage"; # (%remainingm)" # %emptytime
					format_down = "No battery";
					status_chr  = "ADP";
					status_bat  = "BAT";
					status_unk  = "UNK";
					status_full = "FULL";
					last_full_capacity = true;
					integer_battery_capacity = true;
					hide_seconds = true;
					threshold_type = "percentage";
					low_threshold = 30;
				};

				mod-cpu-usage = {
					format = "CPU (%usage)"; #(%cpu0 %cpu1)
					max_threshold = 75;

					separator = false;
					separator_block_width = 7;
				};

				mod-cpu-temp = {
					format = "%degrees-C";
					max_threshold = 50;
				};

				mod-tzone.format = "%Y-%m-%d %H:%M:%S ";
			in
			{
				"wireless _first_"        = (get-conf  1 mod-wireless);
				"ethernet _first_"        = (get-conf  2 mod-ethernet);
				"ethernet wg-server"      = (get-conf  3 mod-vpn);
				"volume master"           = (get-conf  4 mod-volume);
				"read_file backlight"     = (get-conf  5 mod-backlight);
				"read_file backlight_max" = (get-conf  6 mod-backlight-max);
				"battery all"             = (get-conf  7 mod-battery);
				"cpu_usage"               = (get-conf  8 mod-cpu-usage);
				"cpu_temperature all"     = (get-conf  9 mod-cpu-temp);
				"tztime local"            = (get-conf 10 mod-tzone);
			};
		};
	};

	# ------------------------------------------------------------ #

	options.jcconfs.module.i3status =
	{
		enable = lib.mkEnableOption "i3status i3 navbar custom configuration";
	};
}

