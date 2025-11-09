{ settings, pkgs, ... }:

let
	inherit (settings) has-de is-laptop;
in

{
	services.fusuma =
	{
		enable = has-de && is-laptop;
		extraPackages = with pkgs; [ i3 xdotool ];
		settings = 
		{
			# i3 base settings from
			# <https://github.com/iberianpig/fusuma/wiki/i3>
			swipe =
			{
				"3" =
				{
					 left.command = "exec i3 focus right";
					right.command = "exec i3 focus left";
					   up.command = "exec i3 focus down";
					 down.command = "exec i3 focus up";
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

			# threshold = { swipe = 0.4; pinch = 0.4; };
			# interval =  { swipe = 0.8; pinch = 0.1; };
		};
	};
}
