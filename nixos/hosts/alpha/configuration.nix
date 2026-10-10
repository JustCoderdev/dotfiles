{ ... }:

# TODO: Package hpasm
# - [package](https://support.hpe.com/connect/s/softwaredetails?language=en_US&softwareId=MTX_cc8c40268b5540778b86b957f2&tab=Installation+Instructions)
# - <https://github.com/NixOS/nixpkgs/blob/2a2a9392b5b9214fac8286428a637ccbb136f3d7/pkgs/applications/networking/instant-messengers/skypeforlinux/default.nix>
# - <https://github.com/spencerjanssen/dotfiles/blob/ae0ca95c6046b6b899c763fba1a74c943327d7f7/nixos/netextender/netextender.nix>
# - <https://discourse.nixos.org/t/app-to-install-not-listed-in-nixos-packages/77171/3>
# - <https://lists.debian.org/debian-isp/2004/08/msg00178.html?pow_referer=https%3A%2F%2Fnoai.duckduckgo.com%2F>
# - <http://wikistatic.jasonantman.com/index.php/Hpasm/>

let
	raid-mount = "/mnt/array-aad";
	config-dir = raid-mount + "/.config";
	data-dir   = raid-mount + "/data";

	enable-services-touching-raid = false;

	openFirewall = true;
	forwardedServicesFirewall = false && openFirewall;
	serv-group = "maid";

	proxy = {
		enable = true;
		host = "alpha.home.lan";
		aliases = [ "192.168.7.3" "10.255.250.8" "alpha.garden.lan" ];
	};
in

{
	systemd.network =
	let
		# PtP 10.255.255.252/30
		alpha-ip = "10.255.255.253";
		 beta-ip = "10.255.255.254";
		alpha-port-to-beta = "enp3s4f1";
	in
	{
		enable = true;
		networks."${alpha-port-to-beta}" = {
			matchConfig.Name = alpha-port-to-beta;
			address = [ "${alpha-ip}/30" ];
			linkConfig.RequiredForOnline = "no";
		};
	};

	# ------------------------------------------------------------ #

	# Create service group
	users.groups."${serv-group}" = { };
	modules.services.samba.shares."data" = raid-mount;

	systemd.tmpfiles.rules = [
#		Type Path                    Mode User Group
		"d   ${config-dir}           0775 root ${serv-group}"
		"d   ${data-dir}             0775 root ${serv-group}"

		"d   ${data-dir}/documents   0775 root ${serv-group}"
		"d   ${data-dir}/games       0775 root minecraft"

		# App dirs
		"d   ${data-dir}/downloads   0775 root ${serv-group}"
		"d   ${data-dir}/media/movie 0775 root ${serv-group}"
		"d   ${data-dir}/media/serie 0775 root ${serv-group}"
		"d   ${data-dir}/music       0775 root ${serv-group}"
		"d   ${data-dir}/books       0775 root ${serv-group}"
	];

	# ------------------------------------------------------------ #
}
