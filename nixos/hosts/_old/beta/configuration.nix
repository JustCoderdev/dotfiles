{ ... }:

let
	# PtP 10.255.255.252/30
	alpha-ip = "10.255.255.253";
	 beta-ip = "10.255.255.254";
	beta-port-to-alpha = "eno2";
in

{
	systemd.network = {
		enable = true;
		networks."${beta-port-to-alpha}" = {
			matchConfig.Name = beta-port-to-alpha;
			address = [ "${beta-ip}/30" ];
			linkConfig.RequiredForOnline = "no";
		};
	};


	networking.hosts =
	{
		# "10.0.0.1"   = [ "gateway.lan" ];
		# "10.0.0.2"   = [  "switch.lan" ];

		# SERVERS
		"${alpha-ip}" = [     "alpha.host.lan" ];
		# "10.0.0.4"    = [ "alpha-ilo.host.lan" ];

		# "10.0.0.5" = [     "beta.host.lan" ];
		# "10.0.0.6" = [ "beta-ilo.host.lan" ];

		# "10.0.0.7" = [  "quiss.server.lan" ];
		# "10.0.0.8" = [ "jarvis.server.lan" ];
	};
}
