{ pkgs, settings, inputs, ... }:

let
	username = settings.username;
	system = settings.system;
#	addons = inputs.firefox-addons.packages."${system}";
in

# https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265

{
	# TODO: Finish configuring firefox policies, check also LibreWolf
	# ~/.mozilla		about:config
	programs.firefox = {
		enable = true;
		package = pkgs.firefox-esr;

		profiles."${username}" = {
			settings = {
				"dom.security.https_only_mode" = true;
			};

			# nix flake show "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons"
#			extensions = with addons; [
#				#bitwarden
#				gesturefy
#				gruvbox-dark-theme
#				improved-tube
#				#iCloud
#				keepa
#				#mullvad
#				proton-vpn
#				remove-youtube-s-suggestions
#				return-youtube-dislikes
#				sponsorblock
#				ublock-origin
#				user-agent-string-switcher
#				vim-vixen
#				youtube-nonstop
#				youtube-shorts-block
#			];
		};

		# policies = {
		# 	Preferences = { };
		# };
	};

}
