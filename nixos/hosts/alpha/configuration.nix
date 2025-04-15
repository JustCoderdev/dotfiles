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
		};
	};

	networking.hosts =
	{
		"10.0.0.1"   = [ "gateway.local" ];
		"10.0.0.2"   = [  "switch.local" ];

		# SERVERS
		# "10.0.0.3" = [     "alpha.host.local" ];
		"10.0.0.4" = [ "alpha-ilo.host.local" ];

		"${beta-ip}" = [     "beta.host.local" ];
		"10.0.0.6"   = [ "beta-ilo.host.local" ];

		"10.0.0.7" = [  "quiss.server.local" ];
		"10.0.0.8" = [ "jarvis.server.local" ];
	};
}
