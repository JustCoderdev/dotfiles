{ config, lib, ... }:

let
	inherit (config.jcconfs.user) profiles;

	profile =
	{
		desktop = {
			i3       = "i3-desktop";       # i3, i3status, fusuma
			hyprland = "hyprland-desktop"; # hyprland, waybar
		};

		environment = {
			develop = "develop-environment"; # alacritty, emacs, git, neovim, zsh, ssh
			game    = "game-environment";    # mangohud
			vr      = "vr-environment";      # vr
		};

		user.ryuji = "ryuji-user"; # firefox
	};

	contains = (
		list: item:
		(lib.lists.any (elem: elem == item) list)
	);
in

{
	imports =
	[
		./emacs
		./neovim
		./waybar

		./standalone/alacritty.nix
		./standalone/firefox.nix
		./standalone/fusuma.nix
		./standalone/git.nix
		./standalone/hyprland.nix
		./standalone/i3.nix
		./standalone/i3status.nix
		./standalone/mangohud.nix
		./standalone/ssh.nix
		./standalone/tmux.nix
		./standalone/vr.nix
		./standalone/zsh.nix
	];

	config =
	{
		# DO NOT TOUCH
		home.stateVersion = "23.11";
		programs.home-manager.enable = true;
		# DO NOT TOUCH


		# enable when 23.05 => 23.11
		manual.html.enable = false;
		manual.manpages.enable = false;


		jcconfs.module =
		{
			fusuma.enable    = (lib.mkDefault (contains profiles profile.desktop.i3));
			i3.enable        = (lib.mkDefault (contains profiles profile.desktop.i3));
			i3status.enable  = (lib.mkDefault (contains profiles profile.desktop.i3));

			hyprland.enable  = (lib.mkDefault (contains profiles profile.desktop.hyprland));
			waybar.enable    = (lib.mkDefault (contains profiles profile.desktop.hyprland));

			alacritty.enable = (lib.mkDefault (contains profiles profile.environment.develop));
			emacs.enable     = (lib.mkDefault (contains profiles profile.environment.develop));
			git.enable       = (lib.mkDefault (contains profiles profile.environment.develop));
			neovim.enable    = (lib.mkDefault (contains profiles profile.environment.develop));
			ssh.enable       = (lib.mkDefault (contains profiles profile.environment.develop));
			zsh.enable       = (lib.mkDefault (contains profiles profile.environment.develop));
			tmux.enable      = (lib.mkDefault (contains profiles profile.environment.develop));

			mangohud.enable  = (lib.mkDefault (contains profiles profile.environment.game));

			vr.enable        = (lib.mkDefault (contains profiles profile.environment.vr));

			firefox.enable   = (lib.mkDefault (contains profiles profile.user.ryuji));
		};
	};
}

