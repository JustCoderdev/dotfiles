{ config, lib, pkgs, settings, ... }:

let
	cfg = config.common.core.network.wakeOn;
	has-items = list: (builtins.length list) > 0;
in

{
	config =
	let
		create-oneshot-service = (
			name: { description, command, ... }:
			{
				# `sudo ethtool -s enp4s0 wol g`
				# <https://blog.yucas.net/2018/02/03/add-systemd-service-to-start-wake-on-lan/>
				# Systemd service: <https://photostructure.com/coding/wake-on-lan/>
				inherit name;
				value = {
					inherit description;
					after = [ "network-online.target" ];
					wantedBy = [ "network-online.target" ];
					wants = [ "network-online.target" ];
					serviceConfig = {
						Type = "oneshot";
						# RemainAfterExit = "yes";
						# Group = "root";
						# User = "root";
						ExecStart = command;
						StandardError = "journal";
						StandardOutput = "journal";
					};
				};
			}
		);
	in
	{
		systemd.services = {}
		//
		builtins.listToAttrs (
			lib.lists.forEach cfg.lan.enabledFor (
				interface:
				# `sudo ethtool -s enp4s0 wol g`
				# <https://blog.yucas.net/2018/02/03/add-systemd-service-to-start-wake-on-lan/>
				let
					name = "enable-wakeonlan-${interface}";
					description = "Enable WakeOnLan for interface ${interface}";
					command-bin = pkgs.writeShellScriptBin name ''
echo "Enabling wakeonlan for interface ${interface}"

check_if_set() {
	${pkgs.ethtool}/bin/ethtool ${interface} | ${pkgs.gnugrep}/bin/grep 'Wake-on: g'
	is_set=$?
}

check_if_set;

while [[ $is_set -eq 1 ]]
do
	${pkgs.ethtool}/bin/ethtool -s ${interface} wol g

	check_if_set;
	if [[ $is_set -eq 1 ]];
	then
		echo -e "\t- Attempt failed"
		sleep 0.2
	else
		echo -e "Successfully enabled wake on lan for interface ${interface}"
		exit 0
	fi
done

echo "Wake on lan was already enabled"
'';
				in
				create-oneshot-service name {
					inherit description;
					command = "${command-bin}/bin/${name}";
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
		++ lib.lists.optionals (has-items wake-device-pkgs) [ pkgs.wakeonlan ] ++ wake-device-pkgs
		++ lib.lists.optionals (has-items cfg.lan.enabledFor) [ pkgs.ethtool ]
		++ lib.lists.optionals (has-items cfg.wlan.enabledFor) [ pkgs.iw ];
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
