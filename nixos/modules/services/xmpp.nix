# Source: <https://www.youtube.com/watch?v=XwMWUZYUTvM>

{ config, lib, ... }:

let
	cfg = config.modules.services.xmpp;

	mucDomain = "conference.${cfg.domain}";
	uploadDomain = "upload.${cfg.domain}";
	certsGroup = "certs";
in

{

	config = lib.mkIf (cfg.enable)
	{
		# <https://prosody.im/doc/ports>
		networking.firewall.allowedTCPPorts = [
			80 443 # http / https
			5281   # prosody http upload port
			5222   # xmpp client connection
			5269   # xmpp server federation
		];

		users.groups.${certsGroup}.members = [ "prosody" "nginx" ];
		security.acme.certs.${cfg.domain} = {
			group = certsGroup;
			webroot = "/var/lib/acme/acme-challenge";
			postRun = "systemctl reload prosody.service";
			extraDomainNames = [ mucDomain uploadDomain ];
		};

		services.nginx =
		{
			enable = true;
			virtualHosts.${cfg.domain} =
			{
				locations."/.well-known/acme-challenge".root = "/var/lib/acme/acme-challenge";
				# locations."/".return = "404";
			};
		};

		services.prosody =
		let
			ssl = let path = "/var/lib/acme/${cfg.domain}"; in {
				cert = "${path}/fullchain.pem";
				key = "${path}/key.pem";
			};
		in
		{
			inherit ssl;

			enable = true;
			admins = [ "ryuji@${cfg.domain}" ];

			httpFileShare = {
				domain = uploadDomain;
				uploadFileSizeLimit = 100 * 1024 * 1024; # 100 MB
				expires_after = "1 week";
			};

			muc = [ {
				domain = mucDomain;
				name = "lounge";
				restrictRoomCreation = false;
			} ];

			virtualHosts.${cfg.domain} = {
				enabled = true;

				inherit ssl;
				inherit (cfg) domain;
			};

			modules =
			{
				groups = true;
				saslauth = true;
				http_files = true;
				ping = true;
				pep = true;
				register = false;
				roster = true;
			};

			extraConfig = ''
Component "proxy.${cfg.domain}" "proxy65"
	proxy65_address = "${cfg.domain}"
	modules_disabled = {
		"s2s";
	}
'';

			allowRegistration = false;
		};
	};

	# ------------------------------------------------------------ #

	options.modules.services.xmpp =
	let
		mkStrOption = (
			description:
			lib.mkOption {
				inherit description;
				type = lib.types.str;
			}
		);
	in
	{
		enable = lib.mkEnableOption "xmpp server";
		domain = mkStrOption "Domain server will be hosted on";
	};
}
