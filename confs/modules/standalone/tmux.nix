{ config, lib, ... }:

let
	cfg = config.jcconfs.module.tmux;
in

{
	config = lib.mkIf (cfg.enable)
	{
		programs.tmux.enable = true;
	};

	# ------------------------------------------------------------ #

	options.jcconfs.module.tmux =
	{
		enable = lib.mkEnableOption "tmux";
	};
}
