{ config, lib, ... }:

let
	inherit (config.jcconfs.host) has-de;

	cfg = config.jcconfs.module.mangohud;
in

{
	config = lib.mkIf (cfg.enable && has-de)
	{
		programs.mangohud =
		{
			enable = true;
			enableSessionWide = true;

			settings =
			{
				legacy_layout = false;

				round_corners = false;
				background_alpha = 0.6;
				background_color = "000000";

				font_size = 24;
				text_color = "FFFFFF";
				position = "top-left";

				pci_dev = "0:01:00.0";
				table_columns = "3";

				vsync = 0;
				gl_vsync = -1;


				# GPU
				# -------------------- #

				gpu_text = "GPU";
				gpu_stats = true;
				gpu_load_change = true;
				gpu_load_value = [ 50 90 ];
				gpu_load_color = [ "FFFFFF" "FFFFFF" "CC0000" ];
				gpu_temp = true;
				gpu_color = "2E9762";
				cpu_text = "CPU";


				# CPU
				# -------------------- #

				cpu_stats = true;
				core_bars = true;
				cpu_load_change = true;
				cpu_load_value = [ 50 90 ];
				cpu_load_color = [ "FFFFFF" "FFFFFF" "CC0000" ];
				cpu_temp = true;
				cpu_color = "2E97CB";


				# FPS
				# -------------------- #

				fps = true;
				fps_limit_method = "early";
				toggle_fps_limit = "Shift_L+F4";
				fps_limit = 60;
				refresh_rate = true;
				fps_color_change = true;
				fps_color = [ "B22222" "FDFD09" "FFFFFF" ];
				fps_value = [ 30 60 ];
			};
		};
	};

	# ------------------------------------------------------------ #

	options.jcconfs.module.mangohud =
	{
		enable = lib.mkEnableOption "mangohud process hardware utilisation custom configuration";
	};
}
