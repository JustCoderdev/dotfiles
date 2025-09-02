{ config, lib, settings, ... }:

let
	cfg = config.common.core.secrets;

	mkAttrListOption = (
		description: mkOption:
		lib.mkOption {
			inherit description;
			type = lib.types.attrsOf (
				lib.types.submodule (
					{ name, ... }:
					{ options = (mkOption name); }
				)
			);
		}
	);

	mkSecretOptions = (
		filename: self-cfg:
		{
			installed = lib.mkEnableOption "Whether secret is installed on the system";
			path = lib.mkOption {
				type = lib.types.nullOr lib.types.str;
				description = "Path to secret ${filename}";
				default = if self-cfg.installed then "${cfg.defaultPath}/${filename}" else null;
			};
		}
	);
in

{
	config = { };

	# ------------------------------------------------------------ #

	options.common.core.secrets =
	{
		defaultPath = lib.mkOption {
			type = lib.types.str;
			description = "Path to secrets directory";
			default = "${settings.dotfiles_abs_path}/secrets";
		};

		# -------------------- #

		cloudflare = {
			origin-cert = mkSecretOptions "cloudflare/cert.pem" cfg.cloudflare.origin-cert;
			api-token = mkSecretOptions "cloudflare/api.token" cfg.cloudflare.api-token;
			tunnel-creds = mkAttrListOption "Credentials for each tunnel" (
				name: mkSecretOptions "cloudflare/tunnel-${name}.json" cfg.cloudflare.tunnel-creds."${name}"
			);
		};

		discord-hook = mkSecretOptions "discordhook.url" cfg.discord-hook;

		duckdns = {
			token = mkSecretOptions "duckdns.token" cfg.duckdns.token;
		};

		nginx = {
			vhosts = mkAttrListOption "Nginx virtual host keys and certificates" (
				name:
				let
					flat-name = builtins.replaceStrings [ "." "/" ] [ "_" "_"] name;
				in
				{
					cert = mkSecretOptions "nginx/${flat-name}-cert.crt" cfg.nginx.vhosts."${name}".cert;
					key  = mkSecretOptions "nginx/${flat-name}-cert.key" cfg.nginx.vhosts."${name}".key;
				}
			);
		};

		nix-serve = {
			priv-key = mkSecretOptions "nixserve/cache-priv-key.pem" cfg.nix-serve.priv-key;
		};

		wireless = mkSecretOptions "wireless.conf" cfg.wireless;
	};
}
