{ pkgs, ... }:

{
	# TODO: Finish configuring firefox policies, check also LibreWolf
	# ~/.mozilla		about:config
	programs.firefox = {
		enable = true;
		package = pkgs.firefox-esr;

		# policies = {
		# 	Preferences = { };
		# };
	};

}
