{ config, lib, ... }:

let
	cfg = config.jcconfs.module.git;
in

{
	config = lib.mkIf (cfg.enable)
	{
		programs.git =
		{
			enable = true;
			lfs.enable = true;

			ignores = [ "*~" ".*.swp" ".old_session.vim" ".emacs.elc" ".DS_Store" ];

			# TODO: rename settings when new version comes out
			iniContent =
			{
				init.defaultBranch = "main";
				http.postBuffer = 157286400;

				# TODO: Extract user data
				user = {
					name = "JustCoderdev";
					email = "107036402+JustCoderdev@users.noreply.github.com";
				};

				pull.rebase = true;
				core.autocrlf = "input";
			};
		};
	};

	# ------------------------------------------------------------ #

	options.jcconfs.module.git =
	{
		enable = lib.mkEnableOption "git versioning system custom configuration";
	};
}
