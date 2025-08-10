{ settings, pkgs, ... }:

let
	username = settings.username;
	system = settings.system;
	has_de = settings.has_de;

#	addons = inputs.firefox-addons.packages."${system}";
in

# https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265

{
	# ~/.mozilla about:config
	programs.firefox =
	{
		enable = true && has_de;
		package = pkgs.firefox-esr;

		profiles.${username} =
		{
			settings =
			{
				"browser.bookmarks.showMobileBookmarks" = false;

				"browser.newtabpage.activity-stream.feeds.topsites" = false;
				"browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
				"browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

				"browser.toolbars.bookmarks.visibility" = "always";

				"browser.uiCustomization.state" = "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"ublock0_raymondhill_net-browser-action\",\"sponsorblocker_ajay_app-browser-action\",\"_3c6bf0cc-3ae2-42fb-9993-0d33104fdcaf_-browser-action\",\"addon_darkreader_org-browser-action\",\"gdpr_cavi_au_dk-browser-action\",\"_50864413-c4c8-43b0-80b8-982c4a368ac9_-browser-action\",\"myallychou_gmail_com-browser-action\",\"_0d7cafdd-501c-49ca-8ebb-e3341caaa55e_-browser-action\",\"_5327e982-d0be-4b85-b661-dba2ef210ab8_-browser-action\",\"_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action\",\"_57015cac-9cb6-43b3-975a-b305fd4012c9_-browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"customizableui-special-spring1\",\"vertical-spacer\",\"urlbar-container\",\"customizableui-special-spring2\",\"downloads-button\",\"fxa-toolbar-menu-button\",\"unified-extensions-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\"],\"vertical-tabs\":[],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"save-to-pocket-button\",\"developer-button\",\"addon_darkreader_org-browser-action\",\"gdpr_cavi_au_dk-browser-action\",\"_50864413-c4c8-43b0-80b8-982c4a368ac9_-browser-action\",\"myallychou_gmail_com-browser-action\",\"sponsorblocker_ajay_app-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"_0d7cafdd-501c-49ca-8ebb-e3341caaa55e_-browser-action\",\"_5327e982-d0be-4b85-b661-dba2ef210ab8_-browser-action\",\"_3c6bf0cc-3ae2-42fb-9993-0d33104fdcaf_-browser-action\",\"screenshot-button\",\"_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action\",\"_57015cac-9cb6-43b3-975a-b305fd4012c9_-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"vertical-tabs\",\"PersonalToolbar\",\"toolbar-menubar\",\"TabsToolbar\",\"unified-extensions-area\",\"widget-overflow-fixed-list\"],\"currentVersion\":22,\"newElementCount\":7}";

				"browser.urlbar.shortcuts.actions" = false;
				"browser.urlbar.shortcuts.tabs" = false;
				"browser.urlbar.showSearchSuggestionsFirst" = false;
				"browser.urlbar.suggest.engines" = false;
				"browser.urlbar.suggest.openpage" = false;

				"devtools.toolbox.host" = "window";

				"doh-rollout.doneFirstRun" = true;
				"doh-rollout.home-region" = "IT";

				"dom.security.https_only_mode" = false;
				"extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
				"security.tls.version.enable-deprecated" = true; # Needed for ilo
				"sidebar.visibility" = "hide-sidebar";
				"ui.key.menuAccessKeyFocuses" = false; # Disable `esc` key for menu
			};

			# nix flake show "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons"
#			extensions = with addons; [
#				improved-tube
#				keepa
#				remove-youtube-s-suggestions
#				sponsorblock
#				ublock-origin
#				user-agent-string-switcher
#				youtube-nonstop
#			];
		};

		# <https://mozilla.github.io/policy-templates/>
		policies =
		{
			AutofillCreditCardEnabled = false;
			DefaultDownloadDirectory = "/home/${username}/Downloads";

			DisableFeedbackCommands = true;
			DisableFirefoxScreenshots = true;
			DisableFirefoxStudies = true;
			DisablePocket = true;
			DisableSetDesktopBackground = true;
			DisableTelemetry = true;

			DisplayBookmarksToolbar = "always";
			DisplayMenuBar = "never";

			DontCheckDefaultBrowser = true;
			
			EnableTrackingProtection = {
				Value = true;
				Cryptomining = true;
				Fingerprinting = true;
				EmailTracking = true;
				Locked = true;
			};

			ExtensionSettings =
			let
				gen-extension-data = (
					addon-name: 
					{
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/${addon-name}/latest.xpi";
						installation_mode = "force_installed";
					}
				);
			in
			{
				"*" = {
					default_area = "menupanel";
					installation_mode = "allow";
					private_browsing = true;
				};
				"addon@darkreader.org" = gen-extension-data "darkreader";
				"{5327e982-d0be-4b85-b661-dba2ef210ab8}" = gen-extension-data "link-redirect-trace-addon";
				"sponsorBlocker@ajay.app" = gen-extension-data "sponsorblock";
				"uBlock0@raymondhill.net" = gen-extension-data "ublock-origin";
				"myallychou@gmail.com" = gen-extension-data "youtube-recommended-videos";
				"{0d7cafdd-501c-49ca-8ebb-e3341caaa55e}" = gen-extension-data "youtube-nonstop";
				"default-compact-dark-theme@glitchii.github.io" = gen-extension-data "default-compact-dark-theme";
				# "{57015cac-9cb6-43b3-975a-b305fd4012c9}" = gen-extension-data "two-finger-history-jump";
				# "{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}" = gen-extension-data "user-agent-string-switcher";
			};

			FirefoxHome = {
				Search = true;
				TopSites = false;
				SponsoredTopSites = false;
				Highlights = false;
				Pocket = false;
				SponsoredPocket = false;
				Snippets = false;
				Locked = true;
			};

			FirefoxSuggest = {
				WebSuggestions = true;
				SponsoredSuggestions = false;
				ImproveSuggest = false;
				Locked = true;
			};

			HardwareAcceleration = true;

			Homepage = {
				URL = "about:home";
				# Additional = [ "about:newtab" ];
				StartPage = "previous-session";
				Locked = true;
			};

			NoDefaultBookmarks = true;
			OfferToSaveLogins = true;

			OverrideFirstRunPage = "";
			OverridePostUpdatePage = "";

			PasswordManagerEnabled = true;
			PictureInPicture.Enabled = true;
			PromptForDownloadLocation = true;

			SearchBar = "unified";
			SearchEngines = {
				Default = "DuckDuckGo";
				Remove = [ "Bing" "Ecosia" "Qwant" "Wikipedia" ];
				# Add = [ {
				# 	Name = "DuckDuckGo*";
				# 	URLTemplate = "https://duckduckgo.com/{searchTerms}&kah=uk-en&k1=-1&k5=2&kak=-1&kao=-1&kap=-1&kaq=-1&kau=-1&kax=-1&kbe=0&kbg=-1&kl=wt-wt&kp=-2&kpsb=-1&kz=-1&kaj=m";
				# 	Method = "GET";
				# 	IconURL = "https://duckduckgo.com/favicon.ico";
				# 	Alias = "@ddg";
				# } ];
			};
			SearchSuggestEnabled = true;

			ShowHomeButton = false;
			StartDownloadsInTempDirectory = true;

			UserMessaging = {
				ExtensionRecommendations = false;
				FeatureRecommendations = false;
				UrlbarInterventions = false;
				SkipOnboarding = false;
				MoreFromMozilla = false;
				FirefoxLabs = false;
				Locked = true;
			};
		};
	};

}
