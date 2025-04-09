{ ... }:

let
	# PtP 10.255.255.252/30
	beta-ip  = "10.255.255.254";
	beta-port-to-alpha = "eno2";
in

{
	systemd.network = {
		enable = true;
		networks."${beta-port-to-alpha}" = {
			matchConfig.Name = beta-port-to-alpha;
			address = [ "${beta-ip}/30" ];
		};
	};

}
