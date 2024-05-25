{ ... }:

{
	imports = [
		../desktop/fonts.nix
	];

	# Configure console keymap
	console = {
		enable = true;
		font = "Roboto Mono";

		# keyMap = "it2";
		useXkbConfig = true;
	};
}
