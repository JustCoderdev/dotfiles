{ pkgs, ... }:

{
	security.sudo = {
		enable = true;
		extraConfig = with pkgs; ''
Defaults:picloud secure_path="${lib.makeBinPath [
systemd
]}:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
'';
	};
}
