{ ... }:

let
	# PtP 10.255.255.252/30
	alpha-ip = "10.255.255.253";
	 beta-ip = "10.255.255.254";
	alpha-port-to-beta = "enp3s4f1";
in

{
	systemd.network = {
		enable = true;
		networks."${alpha-port-to-beta}" = {
			matchConfig.Name = alpha-port-to-beta;
			address = [ "${alpha-ip}/30" ];
			linkConfig.RequiredForOnline = "no";
		};
	};

	networking.hosts =
	{
		# "10.0.0.1"   = [ "gateway.lan" ];
		# "10.0.0.2"   = [  "switch.lan" ];

		# SERVERS
		# "10.0.0.3" = [     "alpha.host.lan" ];
		# "10.0.0.4" = [ "alpha-ilo.host.lan" ];

		"${beta-ip}" = [     "beta.host.lan" ];
		# "10.0.0.6"   = [ "beta-ilo.host.lan" ];

		# "10.0.0.7" = [  "quiss.server.lan" ];
		# "10.0.0.8" = [ "jarvis.server.lan" ];
	};
}
