{ ... }:

let
	# PtP 10.255.255.252/30
	beta-ip  = "10.255.255.254";
	beta-port-to-alpha = "eno2";
in

{
	networking = {
		interfaces = {
			"${beta-port-to-alpha}" = {
				ipv4.addresses = [
					{
						address = beta-ip;
						prefixLength = 30;
					}
				];
			};
		};
	};

}
