{
	wireguard =
	let
		add-peer = (address: publicKey: { inherit address publicKey; });
	in
	{
		"wg-server" =
		{
			enable = true;

			server-hostname = "wise";
			endpoint.url = "foxburrow.org";

			network = { id = "10.255.250.0"; mask = 24; };
			extraPeers.iphone-tp-2_0 = (add-peer "10.255.250.3" "WUEqbbv7RGfw9EhKjPDeZqwkuKwsODsdTtvMv7Gt+Vk=");
		};
	};

	syncthing.extraPeers =
	let
		add-device = (identification: { inherit identification; });
	in
	{
		iphone-tp-3_0 = (add-device "MBQSGMY-3EBNA67-XQLOXDU-UT3QL7Y-4MQO633-YOOEA5U-LT5RFVC-JYGAXQH");
		  ipad-tp-2_0 = (add-device "WNA7TTR-2GZ7QRH-4HXPAJT-QAI7VVM-MCX3ZFC-WPXG3UB-CGMPF4C-YKTCSA7");
	};
}
