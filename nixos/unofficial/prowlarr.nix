{ config, pkgs, lib, utils, ... }:

let
	cfg = config.unofficial.services.prowlarr;
in

{
	options.unofficial = {
		services.prowlarr = {
			enable = lib.mkEnableOption "Prowlarr";

			dataDir = lib.mkOption {
				type = lib.types.str;
				default = "/var/lib/prowlarr";
				description = "The directory where Prowlarr stores its data files.";
			};

			openFirewall = lib.mkOption {
				type = lib.types.bool;
				default = false;
				description = ''
					Open ports in the firewall for the Prowlarr web interface
				'';
			};

# 			reverseProxyURL = lib.mkOption {
# 				type = lib.types.nullOr lib.types.str;
# 				default = null;
# 				example = "/prowlarr";
# 				description = ''
# 					Set the base url for reverse proxy support, default is empty (proxy disabled)
# 				'';
# 			};

			user = lib.mkOption {
				type = lib.types.str;
				default = "prowlarr";
				description = "User account under which Prowlarr runs.";
			};

			group = lib.mkOption {
				type = lib.types.str;
				default = "prowlarr";
				description = "Group under which Prowlarr runs.";
			};

			package = lib.mkPackageOption pkgs "prowlarr" { };
		};
	};


	config = lib.mkIf cfg.enable {
		systemd.tmpfiles.settings.prowlarrDirs = {
			"${cfg.dataDir}"."d" = {
				mode = "700";
				inherit (cfg) user group;
			};
		};


		# system.activationScripts = lib.mkIf (cfg.reverseProxyURL != null) {
		# 		"prowlerr_set_proxy_url".text =
		# 		let
		# 		config-file = "${cfg.dataDir}/config.xml";
		# 		escaped-url = lib.strings.escape [ "/" ] cfg.reverseProxyURL;
		# 	in ''
# if [ -e '${config-file}' ]; then
	# old_proxy=$(${pkgs._9base}/bin/awk -F '[<>]' '/UrlBase/{print $3}' '${config-file}')

	# if [ "''${old_proxy}" != '${cfg.reverseProxyURL}' ]; then
		# echo "INFO: Updating prowlerr proxy url from \"''${old_proxy}\" to \"${cfg.reverseProxyURL}\""
		# ${pkgs.gnused}/bin/sed 's/<UrlBase>\(.*\)<\/UrlBase>/<UrlBase>${escaped-url}<\/UrlBase>/' '${config-file}'
	# fi
# else
	# echo "ERROR: Cannot update prowlerr proxy url since the file ${config-file} doesn't exist"
# fi
# '';
		# };

		systemd.services.prowlarr = {
			description = "Prowlarr";
			after = [ "network.target" ];
			wantedBy = [ "multi-user.target" ];

			serviceConfig = {
				Type = "simple";
				StateDirectory = "prowlarr";
				User = cfg.user;
				Group = cfg.group;
				ExecStart = utils.escapeSystemdExecArgs [
					(lib.getExe cfg.package)
					"-nobrowser"
					"-data=${cfg.dataDir}"
				];
				Restart = "on-failure";
			};
			environment.HOME = "/var/empty";
		};

		networking.firewall = lib.mkIf cfg.openFirewall {
			allowedTCPPorts = [ 9696 ];
		};

		users.users = lib.mkIf (cfg.user == "prowlarr") {
			prowlarr = {
				inherit (cfg) group;
				isSystemUser = true;
			};
		};

		users.groups = lib.mkIf (cfg.group == "prowlarr") {
			prowlarr = { };
		};
	};
}
