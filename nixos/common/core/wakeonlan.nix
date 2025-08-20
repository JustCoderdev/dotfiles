{ config, lib, pkgs, settings, ... }:

let
	cfg = config.common.core.network;
in

{
	config =
	let
		# Create systemd service
		# Source <https://wiki.archlinux.org/title/Wake-on-LAN#systemd_service>
		create-oneshot-service = (
			name: { description, command, ... }:
			{
				inherit name;
				value = {
					inherit description;
					wantedBy = [ "multi-user.target" ];
					requires = [ "network.target" ];
					after = [ "network.target" ];
					serviceConfig = {
						Type = "oneshot";
						RemainAfterExit = "yes";
						Group = "root";
						User = "root";
						ExecStart = command;
					};
				};
			}
		);
	in
	{
		systemd.services = {}
		//
		builtins.listToAttrs (
			lib.lists.forEach cfg.wakeOn.lan.enabledFor (
				interface:
				# `sudo ethtool -s enp4s0 wol g`
				# <https://blog.yucas.net/2018/02/03/add-systemd-service-to-start-wake-on-lan/>
				create-oneshot-service "wakeonlan-${interface}" {
					description = "Enable WakeOnLan for interface ${interface}";
					command = "${pkgs.ethtool}/bin/ethtool -s ${interface} wol g";
				}
			)
		)
		//
		builtins.listToAttrs (
			lib.lists.forEach cfg.wakeOn.wlan.enabledFor (
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
			) cfg.wakeOn.knownDevices;
		in
		lib.mkIf ((builtins.length wake-device-pkgs) > 0)
		(	
			[ pkgs.wakeonlan ] ++ wake-device-pkgs
		);
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
