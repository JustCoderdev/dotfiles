{ config, lib, pkgs, settings, ... }:

let
	cfg = config.common.core.network;
in

{
	config =
	{
		# `sudo ethtool -s enp4s0 wol g`
		# <https://blog.yucas.net/2018/02/03/add-systemd-service-to-start-wake-on-lan/>
		systemd.services = builtins.listToAttrs (
			lib.lists.forEach cfg.wakeOnLan.enableFor (
				interface:
				{
					name = "wakeonlan-${interface}";
					value = {
						description = "Enable WakeOnLan for interface ${interface}";
						wantedBy = [ "basic.target" ];
						serviceConfig = {
							Type = "oneshot";
							RemainAfterExit = "yes";
							ExecStart = "${pkgs.ethtool}/bin/ethtool -s ${interface} wol g";
							ExecStop  = "${pkgs.ethtool}/bin/ethtool -s ${interface} wol d";
						};
					};
				}
			)
		);

		environment.systemPackages =
		let
			wake-device-pkgs = lib.attrsets.mapAttrsToList (
				host: mac:
				pkgs.writeShellScriptBin "${host}-wake" "wakeonlan ${mac}"
			) cfg.wakeOnLan.knownDevices;
		in
		lib.mkIf ((builtins.length wake-device-pkgs) > 0)
		(	
			[ pkgs.wakeonlan ] ++ wake-device-pkgs
		);
	};

	# ------------------------------------------------------------ #

	options.common.core.network =
	{
		wakeOnLan =
		{
			enableFor = lib.mkOption {
				type = lib.types.listOf lib.types.str;
				description = "Interfaces that should wake the computer up";
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
