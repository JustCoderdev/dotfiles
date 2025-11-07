{
	wireguard =
	let
		add-peer = (address: publicKey: { inherit address publicKey; });
	in
	{
		"wg-server" =
		{
			enable = true;

			server-hostname = "msi";
			endpoint.url = "foxburrow.org";

			network = { id = "10.255.250.0"; mask = 24; };
			extraPeers.iphone-tp-2_0 = (add-peer "10.255.250.3" "WUEqbbv7RGfw9EhKjPDeZqwkuKwsODsdTtvMv7Gt+Vk=");
		};

		"wg-giugio" =
		{
			enable = true;

			server-hostname = "msi";
			endpoint = { url = "foxburrow.org"; port = 51821; };

			network = { id = "10.255.249.0"; mask = 24; };
			extraPeers =
			{
				telefono-giugio = (add-peer "10.255.249.2" "4rwmZnvgDpErgGh846y74GJ3EyWo+H/EqP8C4GULJGA=");
				        pc-casa = (add-peer "10.255.249.3" "1LuDZtSSOh7YMlt3yq6pLZyOiLPisxbmn29RWvx2phY=");
				      pc-giugio = (add-peer "10.255.249.4" "ASVxaCdn8K/5scQOv+oWuJ9VWzQf/1mXxZi5tfwhblk=");
			};
		};
	};
}
