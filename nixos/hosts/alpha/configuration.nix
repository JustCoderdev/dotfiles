{ ... }:

let
	# PtP 10.255.255.252/30
	alpha-ip = "10.255.255.253";
	alpha-port-to-beta = "enp3s4f1";
in

{
	networking = {
		interfaces = {
			"${alpha-port-to-beta}" = {
				ipv4.addresses = [
					{
						address = alpha-ip;
						prefixLength = 30;
					}
				];
			};
		};
	};

}
