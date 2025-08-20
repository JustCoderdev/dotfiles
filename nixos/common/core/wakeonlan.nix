{ config, lib, pkgs, settings, ... }:

let
	cfg = config.common.core.network.wakeOn;
	has-items = list: (builtins.length list) > 0;
in

{
	config =
	let
		# Create dispatcher script
		# Source <https://discourse.nixos.org/t/run-script-on-network-interface-down/9167/2>
		create-dispatcher-script = (
			name: interface: command:
			{
				source = pkgs.writeText "enable-${name}-${interface}" ''
#!/usr/bin/env ${pkgs.bash}/bin/bash

if [[ "$1" == "${interface}" && "$2" == "up" ]]; then
	logger "Interface ${interface} has been detected as up, enabling ${name}"
	${command}
fi
'';
				type = "basic";
			}
		);
	in
	{
		networking.networkmanager.dispatcherScripts = [ ]
		++
		lib.lists.forEach cfg.lan.enabledFor (
			interface:
			# `sudo ethtool -s enp4s0 wol g`
			# <https://blog.yucas.net/2018/02/03/add-systemd-service-to-start-wake-on-lan/>
			create-dispatcher-script "wakeonlan" interface "${pkgs.ethtool}/bin/ethtool -s ${interface} wol g"
		)
		# ++
		# lib.lists.forEach cfg.wlan.enabledFor (
		# 	phy:
		# 	# `sudo iw phy0 wowlan enable magic-packet disconnect`
		# 	# <https://www.cyberciti.biz/faq/configure-wireless-wake-on-lan-for-linux-wifi-wowlan-card/>
		# 	create-dispatcher-script "wakeonwlan" phy "${pkgs.ethtool}/bin/ethtool -s ${interface} wol g"
		# )
		;

		# -------------------- #

		environment.systemPackages =
		let
			wake-device-pkgs = lib.attrsets.mapAttrsToList (
				host: mac:
				pkgs.writeShellScriptBin "wake-${host}" "wakeonlan ${mac}"
			) cfg.knownDevices;
		in
		[ ]
		++ lib.lists.optionals (has-items wake-device-pkgs) [ pkgs.wakeonlan ] ++ wake-device-pkgs
		++ lib.lists.optionals (has-items cfg.lan.enabledFor || has-items cfg.wlan.enabledFor) [ pkgs.ethtool ];
	};

	# ------------------------------------------------------------ #

	options.common.core.network =
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
				type = lib.types.attrsOf lib.types.str;
				description = "Devices that have WoL enabled";
				default = { };
			};
		};
	};
}
