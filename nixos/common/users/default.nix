{ config, lib, ... }:

let
	cfg = config.common.users;
in

{
	imports =
	[
		./hass-agent.nix
		./neko-agent.nix
		./ryuji.nix
	];

	config =
	{
		users.groups = lib.mkIf
			(cfg.neko-agent.enable || cfg.hass-agent.enable)
			({ agent = {}; });
	};
}
