{ ... }:

{
	# imports = [
	# 	../desktop/fonts.nix
	# ];

	# Configure console keymap
	console = {
		enable = true;

		# Font too big
		# font = "Roboto Mono";
		# font = "${pkgs.roboto-mono}/share/fonts/truetype/RobotoMono-Medium.ttf";

		# keyMap = "it2";
		useXkbConfig = true;
	};
}
