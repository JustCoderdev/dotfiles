{ config, lib, pkgs, ... }:

# [ DISABLED MODULE ]

let
	cfg = config.common.core.network.wakeOn;
in

{
	config =
	let
		create-oneshot-service = (
			name: { description, command, ... }:
			{
				inherit name;
				value = {
					inherit description;
					after = [ "network-online.target" ];
					wantedBy = [ "network-online.target" ];
					wants = [ "network-online.target" ];
					serviceConfig = {
						Type = "oneshot";
						ExecStart = command;
						StandardError = "journal";
						StandardOutput = "journal";
					};
				};
			}
		);
	in
	lib.mkIf (false)
	{
		systemd.services = {}
		//
		builtins.listToAttrs (
			lib.lists.forEach cfg.lan.enabledFor (
				interface:
				# `sudo ethtool -s enp4s0 wol g`
				# <https://blog.yucas.net/2018/02/03/add-systemd-service-to-start-wake-on-lan/>
				# Systemd service: <https://photostructure.com/coding/wake-on-lan/>
				create-oneshot-service "wakeonlan-${interface}" {
					description = "Enable WakeOnLan for interface ${interface}";
					command = "${pkgs.ethtool}/bin/ethtool -s ${interface} wol g";
				}
			)
		)
		//
		builtins.listToAttrs (
			lib.lists.forEach cfg.wlan.enabledFor (
				phy:
				# `sudo iw phy0 wowlan enable magic-packet disconnect`
				# <https://www.cyberciti.biz/faq/configure-wireless-wake-on-lan-for-linux-wifi-wowlan-card/>
				create-oneshot-service "wakeonwlan-${phy}" {
					description = "Enable WakeOnWLAN for interface ${phy}";
					command = "${pkgs.iw}/bin/iw ${phy} wowlan enable magic-packet disconnect";
				}
			)
		);

		# -------------------- #

		environment.systemPackages =
		let
			wake-device-pkgs = lib.attrsets.mapAttrsToList (
				host: mac:
				pkgs.writeShellScriptBin "wake-${host}" "wakeonlan ${mac}"
			) cfg.knownDevices;
		in
		[ ]
		++ lib.lists.optionals ((builtins.length wake-device-pkgs)    > 0) [ pkgs.wakeonlan ] ++ wake-device-pkgs
		# ++ lib.lists.optionals ((builtins.length cfg.lan.enabledFor)  > 0) [ pkgs.ethtool ]
		# ++ lib.lists.optionals ((builtins.length cfg.wlan.enabledFor) > 0) [ pkgs.iw ]
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
