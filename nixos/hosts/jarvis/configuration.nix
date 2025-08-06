{ ... }:

{
	# ------------------------------------------------------------ #

	# TUNNEL

	# Configure DNS on cloudflare interface
	# <https://blog.cloudflare.com/argo-tunnels-that-live-forever/>
	# <https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/routing-to-tunnel/dns/>
	unofficial.services.cloudflared =
	{
		enable = true;
		certificateFile = secrets.cloudflare.origin-cert.path;

		tunnels."jarvis-hass" =
		{
			credentialsFile = secrets.cloudflare.tunnel-creds."jarvis-hass".path;
			default = "http_status:404";

			originRequest.noTLSVerify = true;

			ingress =
			let
				create-rule = (
					subdomain: proto: port: path:
					{
						"${subdomain}.foxburrow.org" =
						{
							inherit path;
							service = "${proto}://127.0.0.1:${toString port}";
						};
					}
				);
			in
			{ }
			// (create-rule "hass"  "http" 8123 "/hass.*")
			// {};
		};
	};

	# ------------------------------------------------------------ #


}

