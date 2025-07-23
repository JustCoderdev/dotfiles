# Nixos wiki page
# <https://nixos.wiki/wiki/Printing>

{ ... }:

{
	# Enter CUPS configuration here <http://localhost:631>

	# Enable CUPS to print documents.
	services.printing.enable = true;
}
