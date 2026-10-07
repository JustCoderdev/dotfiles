{ config, lib, pkgs, settings, pkgs-unstable, ... }:

let
	inherit (settings) username;

	cfg = config.common.users.ryuji;
	self-manifest = config.common.manifest.self;

	uhome = "/home/${username}";
in

{
	config = lib.mkIf (cfg.enable)
	{
		system.nixos.tags = [ "${username}" ];
		jcconfs.users = [ "${username}"  ];

		nix.settings.trusted-users = [ "${username}" ];

		users.users.${username} =
		let
			titleCase = text: lib.concatStrings [
				(lib.toUpper (builtins.substring 0 1 text))
				(builtins.substring 1 (builtins.stringLength text) text)
			];
		in
		{
			description = (titleCase username);
			isNormalUser = true;

			#                root    serial
			extraGroups = [ "wheel" "dialout" ];
			initialPassword = "${username}";

			openssh.authorizedKeys.keys =
			let
				inherit (config.common.manifest) hosts;
				get-pubkey-or-null = (
					keyname: hostname:
					let
						inherit (hosts.${hostname}.software.ssh) pubkey;
						has-pubkey = builtins.hasAttr keyname pubkey;
					in
					if has-pubkey
						then pubkey.${keyname} + " ${keyname}@${hostname}"
						else null
				);
			in
			[ ]
			++
			builtins.filter (key: key != null)
			(
				builtins.map
					(hostname: get-pubkey-or-null "ryuji" hostname)
					(builtins.attrNames hosts)
			)
			;

			packages = [ ]
			++ lib.lists.optionals
				(self-manifest.hardware.graphics.desktop-environment.enable)
				(with pkgs-unstable; [ obsidian ])
			++
			(
				with pkgs;
				[
					nix-tree btop unixtools.netstat
					appimage-run imagemagick # dust
					# profanity
				]
				++ lib.lists.optionals (self-manifest.hardware.graphics.desktop-environment.enable)
				(
					[
						firefox google-chrome
						vlc audacity emulsion
						gnome-disk-utility gpick
						qemu baobab # rustdesk gajim
						thunderbird
					]
					++ lib.lists.optionals (cfg.media-manipulation-suite.documents.enable) [ libreoffice ]
					++ lib.lists.optionals (cfg.media-manipulation-suite.images.enable)    [ gimp krita ]
					++ lib.lists.optionals (cfg.media-manipulation-suite.videos.enable)    [ shotcut obs-studio ] # davinci-resolve
				)
			);
		};

		programs.bash =
		{
			enable = true;
			completion.enable = true;

			shellAliases =
			let
				dotfiles_path = "/home/\${USER}/.config/dotfiles";
			in
			rec {
				rm  = "rm -vI";
				mkd = "mkdir -p";

				ls   = "ls --color -F";
				sls  = ls;
				l    = ls;
				sl   = ls;
				la   = "ls -Fa";
				ll   = "ls -Flah";
				cls  = "clear && ls";
				cl   = cls;
				scls = cls;

				".."    = "cd ..";
				"..."   = "cd ../..";
				"...."  = "cd ../../..";
				"....." = "cd ../../../..";

				# Save Directory
				sd  = "echo $(pwd) > \"/home/$USER/.sd\" && cat \"/home/$USER/.sd\"";
				sdl = "cd $(cat \"/home/$USER/.sd\")";

				# Debug
				fgdeb = "echo -e \" \\033[30m[0:BLK] \\033[31m[1:RED] \\033[32m[2:GRN] \\033[33m[3:YLW] \\033[34m[4:BLU] \\033[35m[5:MAG] \\033[36m[6:CYN] \\033[37m[7:WHT]\"";
				bgdeb = "echo -e \" \\033[90m[0:GRY] \\033[91m[1:RED] \\033[92m[2:GRN] \\033[93m[3:YLW] \\033[94m[4:BLU] \\033[95m[5:MAG] \\033[96m[6:CYN] \\033[97m[7:WHT]\"";

				## git
				gs  = "git status";
				gl  = "git log --all --color --decorate --oneline --graph";
				gd  = "git diff";
				gdc = "git diff --cached";
				ga  = "git add";
				gc  = "git commit";

				# neovim
				nold = "nvim -S .old_session.vim";
				nivm = "nvim";

				# shortcuts
				dotfiles = '' if [ -t 1 ]; then cd "${dotfiles_path}/$1"; else echo "${dotfiles_path}/$1"; fi '';
			};

			promptInit = ''
function set-prompt() {
	local name='\u'
	local host='\h'
	local path='\w'
	local symb='\$'

	local clr=$'\[\e[0m\]'
	local gry=$'\[\e[90m\]'
	local red=$'\[\e[31m\]'
	local mag=$'\[\e[35m\]'
	local cyn=$'\[\e[36m\]'

	local c1=$mag # nested shell color
	local c2=$gry

	PS1='''

	# TODO: why is tty not found?
	# Check if we're in an ssh tty
	if [[ $SSH_TTY == "$(tty)" ]];
	then
		# check if outside of nested shell
		if [[ $SHLVL == 1 ]]; then c1=$red; fi

		PS1+=$c1$name
		PS1+=$c2'@'
		PS1+=$c1$host
	fi

	# check if outside of nested shell
	if [[ $SHLVL == 1 ]]; then c1=$cyn; fi

	PS1+=$c2' '$path' '
	PS1+=$c1$symb
	if [[ $SHLVL > 1 ]]; then PS1+=$SHLVL; fi

	PS1+=$clr' '
}
set-prompt
'';

		};

		system.userActivationScripts =
		{
			correct-ssh-dir-perms.text = ''
# Permission table found here
# <https://superuser.com/a/215506>

echo "correcting permissions for '${uhome}/.ssh'"

chown -R ${username}:users ${uhome}/.ssh
chmod 700 ${uhome}/.ssh           # Folder
chmod 600 ${uhome}/.ssh/id_*      # All keys
chmod 644 ${uhome}/.ssh/id_*.pub  # Pub keys
'';
		};

		programs.ssh.extraConfig = ''
Host dip.rxserver.net
	HostName dip.rxserver.net
	IdentitiesOnly yes # Force to use only this identity file
	IdentityFile "${uhome}/.ssh/id_github_justcode"
'';

		# -------------------- #

		assertions = [ {
			assertion = username == "ryuji";
			message = "The username must be 'ryuji'!";
		} ];
	};

	# ------------------------------------------------------------ #

	options.common.users.ryuji =
	{
		enable = lib.mkEnableOption "ryuji personal user" // { default = true; };
		media-manipulation-suite =
		{
			documents.enable = lib.mkEnableOption "document manipulation suite";
			images.enable = lib.mkEnableOption "image manipulation suite";
			videos.enable = lib.mkEnableOption "video manipulation suite";
		};
	};
}
