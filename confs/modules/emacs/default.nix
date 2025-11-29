{ config, lib, ... }:

let
	cfg = config.jcconfs.module.emacs;
in

{
	config = lib.mkIf (cfg.enable)
	{
		programs.emacs.enable = true;

		home.file =
		{
			".emacs".source = ./.emacs;
			".emacs.custom.el".source = ./.emacs.custom.el;
			".emacs.extra" = {
				source = ./.emacs.extra;
				recursive = true;
			};
		};
	};

	# ------------------------------------------------------------ #

	options.jcconfs.module.emacs =
	{
		enable = lib.mkEnableOption "emacs operating system custom configuration";
	};
}
