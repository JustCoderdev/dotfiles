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

	networking.hosts."${beta-ip}" = [ "beta.server.local" ];
}
