{ config, lib, pkgs, ... }:

# `sudo ethtool -s enp4s0 wol g`
# <https://blog.yucas.net/2018/02/03/add-systemd-service-to-start-wake-on-lan/>

# `sudo iw phy0 wowlan enable magic-packet disconnect`
# <https://www.cyberciti.biz/faq/configure-wireless-wake-on-lan-for-linux-wifi-wowlan-card/>

let
	cfg = config.common.core.network.wakeOn;

	has-enabled-ifaces = (builtins.length cfg.lan.enabledFor) > 0;
	has-enabled-phys = (builtins.length cfg.wlan.enabledFor) > 0;
in
{
	config =
	{
		services.cron = lib.mkIf (has-enabled-ifaces || has-enabled-phys)
		{
			enable = true;
			systemCronJobs = builtins.map (command: "@reboot root ${command}")
			(
				(
					builtins.map (interface: "${pkgs.ethtool}/bin/ethtool -s ${interface} wol g")
						cfg.lan.enabledFor
				)
				++
				(
					builtins.map (phy: "${pkgs.iw}/bin/iw ${phy} wowlan enable magic-packet disconnect")
						cfg.wlan.enabledFor
				)
			);
		};

		# -------------------- #

		environment.systemPackages =
		let
			wake-device-pkgs = lib.attrsets.mapAttrsToList (
				host: mac:
				pkgs.writeShellScriptBin "wake-${host}" "wakeonlan ${mac}"
			) cfg.knownDevices;
		in
		[ ]
		++ lib.lists.optionals ((builtins.length wake-device-pkgs) > 0) [ pkgs.wakeonlan ] ++ wake-device-pkgs
		++ lib.lists.optionals (has-enabled-ifaces) [ pkgs.ethtool ]
		++ lib.lists.optionals (has-enabled-phys)   [ pkgs.iw ]
		;
	};

	# ------------------------------------------------------------ #

	options.common.core.network =
	let
		regex = {  address.mac = "^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$"; };
	in
	{
		wakeOn =
		{
			lan.enabledFor  = lib.mkOption {
				type = lib.types.listOf lib.types.str;
				description = "Interfaces that should wake the computer up";
				default = [ ];
			};

			wlan.enabledFor = lib.mkOption {
				type = lib.types.listOf lib.types.str;
				description = "Phys that should wake the computer up";
				default = [ ];
			};

			knownDevices = lib.mkOption {
				type = lib.types.attrsOf (lib.types.strMatching regex.address.mac);
				description = "Devices that have WoL enabled";
				default = { };
			};
		};
	};
}
