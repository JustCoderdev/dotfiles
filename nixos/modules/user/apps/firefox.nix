{ pkgs, ... }:

{
	# ~/.mozilla		about:config
	programs.firefox = {
		enable = true;
		package = pkgs.firefox-esr;

		policies = {
			Preferences = {

# "browser.uiCustomization.state" = "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"_3c6bf0cc-3ae2-42fb-9993-0d33104fdcaf_-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"sponsorblocker_ajay_app-browser-action\",\"_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action\",\"firefoxdav_icloud_com-browser-action\",\"_50864413-c4c8-43b0-80b8-982c4a368ac9_-browser-action\",\"_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action\",\"_0d7cafdd-501c-49ca-8ebb-e3341caaa55e_-browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"customizableui-special-spring1\",\"urlbar-container\",\"customizableui-special-spring2\",\"downloads-button\",\"fxa-toolbar-menu-button\",\"unified-extensions-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"firefox-view-button\",\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"save-to-pocket-button\",\"developer-button\",\"_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action\",\"firefoxdav_icloud_com-browser-action\",\"_50864413-c4c8-43b0-80b8-982c4a368ac9_-browser-action\",\"_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action\",\"sponsorblocker_ajay_app-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"_0d7cafdd-501c-49ca-8ebb-e3341caaa55e_-browser-action\",\"_3c6bf0cc-3ae2-42fb-9993-0d33104fdcaf_-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"PersonalToolbar\",\"toolbar-menubar\",\"TabsToolbar\",\"unified-extensions-area\"],\"currentVersion\":20,\"newElementCount\":3}";
			};
		};
	};

}
