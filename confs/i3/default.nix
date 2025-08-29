{ settings, ... }:

{
	home.file = {
		".config/i3/config".source = ./config;
		".config/i3/i3status.conf".source = ./i3status.conf;
		# "/var/lib/AccountService/icons/${settings.username}.JPEG"
		# 	.source = "${settings.confs_path}/users/${settings.username}.JPEG";
	};
}
