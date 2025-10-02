{ config, pkgs, settings, ... }:

{
	services.mysql = {
		enable = true;
		package = pkgs.mariadb;
	};

	# Mouse support
	services.ratbagd.enable = true;
	environment.systemPackages = with pkgs; [ piper ]
	++ [ ciscoPacketTracer8 dbeaver-bin ]; # more packages support

	networking.hosts = {
		"192.168.1.5"   = [  "msi.host.lan" ];
		"192.168.1.8"   = [ "asus.host.lan" ];
	};

	# DDNS

	services.cloudflare-dyndns =
	{
		enable = true;
		apiTokenFile = config.common.core.secrets.cloudflare.api-token.path;
		domains = [
			"msi.foxburrow.org"
		];
	};

	# Wireguard

	system.services.wireguard = {
		openFirewall = true;
		server =
		{
			enable = true;

			tunnel-network = "10.255.250.0/24";
			self-ip = "10.255.250.1/24";

			external-interface = "wlp3s0";
			internal-interface = "wg-server";

			peers =
			let
				add-peer = (
					publicKey: ip:
					{ inherit publicKey ip; }
				);
			in
			{
				        quiss = (add-peer "UQYuZhhWWm2kYNXeoIxb+50Dv/XYb9bQDFc8DTSFbT0=" "10.255.250.2");
				iphone-tp-2_0 = (add-peer "WUEqbbv7RGfw9EhKjPDeZqwkuKwsODsdTtvMv7Gt+Vk=" "10.255.250.3");
				         asus = (add-peer "2KrNqM7coD0YRs9ggk+s2PmEwrH/6tuS5BwP+GS4T2w=" "10.255.250.4");
			};
		};
	};

	# Nginx quiss proxy

	# Port 80 opened for acme
	networking.firewall.allowedTCPPorts = [ 443 80 9001 ]; # waylus port
	services.nginx =
	{
		enable = true;
		virtualHosts."msi.foxburrow.org" =
		{
			locations."/".proxyPass = "https://10.255.250.2";

			# addSSL = true;
			forceSSL = true;
			enableACME = true;
		};
	};

	security.acme = {
		acceptTerms = true;
		defaults.email = "107036402+JustCoderdev@users.noreply.github.com";
	};

	# Syncthing

	system.services.syncthing = 
	let
		uname = settings.username;
		user-cfg = config.users.users."${uname}";
	in
	{
		enable = true;
		openFirewall = true;

		inherit (user-cfg) group;
		inherit (settings) username;
		dataDir = "/home/${uname}/Documents/synced";

		devices =
		let
			add-device = (
				address: id:
				{ inherit address id; }
			);
		in
		{
			          msi = (add-device "10.255.250.1" "LGPPAMZ-TLOK2XH-JKCAXZQ-WLXTAAN-3SFRHCV-7AL7FBZ-B4EHV3E-MSRBHAI");
			        quiss = (add-device "10.255.250.2" "GBMMYZW-5BMWHRK-KWT57VY-HFT2OQZ-VEONSJ2-K7NLEXG-P4HU7CB-3DVFFAQ");
			iphone-tp-2_0 = (add-device "10.255.250.3" "3G4X4WY-UUCQG3V-3I6BXWC-BJ5I6OW-YHUJQ4K-77TJU5N-DL62ASO-4DDWRAG");
		};

		folders = [ "obsidian-db" ];
	};


	# Remote desktop / graphical tablet

	programs.weylus =
	{
		enable = true;
		openFirewall = true;
		users = [ settings.username ];
	};
}
