# setting up japanese support
# <https://functor.tokyo/blog/2018-10-01-japanese-on-nixos>

{ config, lib, pkgs, ... }:

let
	cfg = config.common.core.fonts;
in

{
	config = lib.mkIf (cfg.enable)
	{
		# see all installed font families
		# `fc-list : family | sort`
		fonts =
		{
			enableDefaultPackages = false;
			packages = with pkgs;
			[
				ttf_bitstream_vera
				roboto-mono         # Monospace

				noto-fonts-cjk-sans # Chinese, Japanese, and Korean support
				twitter-color-emoji # Emoji support
			];

			###########################################################
			# /!\ REMEMBER TO ALSO UPDATE `confs/stylix/default.nix` /!\ #
			###########################################################

			fontconfig.defaultFonts =
			{
				sansSerif = [ "Bitstream Vera Sans"  "Noto Sans CJK JP"  ];
				serif     = [ "Bitstream Vera Serif" "Noto Serif CJK JP" ];
				monospace = [ "Roboto Mono"          "Noto Mono CJK JP"  ];
				emoji     = [ "Twitter Color Emoji" ];
				# ⚫ 🔴 🔵
			};
		};
	};

	# ------------------------------------------------------------ #

	options.common.core.fonts =
	{
		enable = lib.mkEnableOption "preferred fonts" // { default = true; };
	};
}
