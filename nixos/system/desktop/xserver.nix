{ inputs, config, lib, pkgs, pkgs-unstable, jc-lib, settings, ... }:

let
	inherit (settings) username hardware-type system dotfiles_store_path;

	cfg = config.system.desktop.xserver;
in

{
	config = lib.mkIf (cfg.enable)
	(
		lib.mkMerge
		[
			(
				{
					# Provides org.gnome.keyring.SystemPrompter
					environment.systemPackages = [ pkgs.gcr ];

					systemd.tmpfiles.rules =
					let
						ldm-grp = config.users.users.lightdm.group;
						
						icon-filename = "${username}.JPEG";
						icon-filepath = "${dotfiles_store_path}/confs/users-icon/${icon-filename}";
					in
					[
						# Fix icon without exposing home folder
						# Source <https://discourse.nixos.org/t/setting-the-user-profile-image-under-gnome/36233/10>

					#  Type Path                                            Mode User Group      Age Argument
						"L+ /var/lib/AccountsService/icons/${icon-filename} 0640 root ${ldm-grp} -   ${icon-filepath}"
						"f+ /var/lib/AccountsService/users/${username}      0640 root ${ldm-grp} -   [User]\\nIcon=/var/lib/AccountsService/icons/${icon-filename}\\n"
					];

					services.xserver =
					{
						enable = true;
						videoDrivers = lib.mkIf (hardware-type == "virtual-machine") [ "wmware" ];

						displayManager.lightdm.greeters.gtk = {
							extraConfig = ''user-background = false'';
							indicators = [ "~clock" "~power" ];
						};
					};

					# fusuma
					users.users.${username}.extraGroups = lib.mkIf (hardware-type == "laptop") [ "input" ];
					users.groups = lib.mkIf (hardware-type == "laptop") { input = { }; };

					# Remember windows size stuff
					programs.dconf.enable = true;

					services.gnome.gnome-keyring.enable = true;
					security.pam =
					{
						mount.logoutTerm = true;  # Send SIGTERM # Graceful shutdown
						mount.logoutKill = true;  # Send SIGKILL # Forceful shutdown

						# Enable lightdm to use Gnome Keyring
						services.login.enableGnomeKeyring = true;
						services.display-manager.enableGnomeKeyring = true;
					};

					# -------------------- #

					assertions = [ {
						assertion = !config.system.desktop.wayland.enable;
						message = "Cannot enable wayland if xserver is enabled";
					} ];
				}
			)

			(
				lib.mkIf (cfg.frontend == cfg.available-frontends.xfce)
				{
					system.nixos.tags = [ "xfce" ];

					services = {
						xserver.desktopManager.xfce.enable = true;
						displayManager.defaultSession = "xfce";
					};
				}
			)

			(
				lib.mkIf (cfg.frontend == cfg.available-frontends.i3)
				{
					system.nixos.tags = [ "i3" ];
					services.displayManager.defaultSession = "none+i3";
					services.xserver.windowManager.i3 =
					{
						enable = true;
						extraPackages = [ inputs.jcbin.packages."${system}".boomer ]
						++ (
							with pkgs;
							[
								dmenu i3status playerctl lightdm # dm-tool lock
								shotgun xclip # Screenshot utilities
								(
									callPackage "${dotfiles_store_path}/nixos/unofficial/pkgs/hacksaw.nix" {
										inherit (pkgs) python3; # pkg-config
										inherit (pkgs.xorg) libX11 libXrandr;
										inherit (pkgs-unstable) libxcb;
									}
								)
							]
						);
					};
				}
			)
		]
	);

	# ------------------------------------------------------------ #

	options.system.desktop.xserver =
	{
		enable = lib.mkEnableOption "xserver support";
		frontend = lib.mkOption {
			description = "What underlying frontend is used for audio support";
			type = lib.types.enum cfg.available-frontends-list;
			default = cfg.available-frontends.i3;
		};

		# -------------------- #

		available-frontends =
		let
			add-frontend = (
				name:
				lib.mkOption {
					description = "Fixed name for ${name} frontend";
					type = lib.types.str;
					readOnly = true;
					default = name;
				}
			);
		in
		{
			i3 = (add-frontend "i3");
			xfce = (add-frontend "xfce");
		};

		available-frontends-list = lib.mkOption {
			description = "All available xserver frontends";
			type = lib.types.listOf lib.types.str;
			readOnly = true;
			default = with cfg.available-frontends; [ i3 xfce ];
		};
	};
}
