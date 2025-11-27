{ config, lib, pkgs, ... }:

let
	inherit (config.jcconfs) has-de is-laptop;

	available-in-profile = "i3-desktop";

	profile-enabled = lib.lists.any
		(profile: profile == available-in-profile)
		config.jcconfs.profiles;
in

{
	services.fusuma = lib.mkIf (profile-enabled)
	{
		enable = true && has-de && is-laptop;
		extraPackages = with pkgs; [ coreutils-full i3 xdotool ];
		settings = 
		{
			# i3 base settings from
			# <https://github.com/iberianpig/fusuma/wiki/i3>
			swipe =
			{
				"3" =
				{
					 # left.command = "exec i3 focus right";
					# right.command = "exec i3 focus left";
					 #   up.command = "exec i3 focus down";
					 # down.command = "exec i3 focus up";

					# MacOS drag style
					begin.command = "xdotool mousedown 1";
					update = {
						command = "xdotool mousemove_relative -- $move_x, $move_y";
						interval = 0.01;
						accel = 2;
					};
					end.command = "xdotool mouseup 1";
				};

				"4" =
				{
					 left.command = "exec i3 workspace next";
					right.command = "exec i3 workspace prev";
					   up.command = "exec i3 fullscreen toggle";
					 down.command = "exec i3 floating toggle";
				};
			};

			pinch =
			{
				"in".command = "xdotool key ctrl+plus";
				 out.command = "xdotool key ctrl+minus";
			};

			threshold = { swipe = 0.4; pinch = 0.4; };
			interval =  { swipe = 0.8; pinch = 0.1; };
		};
	};
}
