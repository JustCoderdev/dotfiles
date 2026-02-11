{ ... }:

{
	config =
	{
		nix =
		{
			optimise.automatic = true;
			gc = {
				automatic = true;
				options = "--delete-older-than 15d";
			};

			# Options can be found at
			# <https://nix.dev/manual/nix/2.24/command-ref/conf-file>
			settings =
			{
				# allowed-users = [ "@users" ];                        # These users are allowed to connect to the Nix daemon

				auto-optimise-store = true;                          # Nix automatically detects files in the store that have identical contents, and replaces them with hard links to a single copy
				builders-use-substitutes = true;                     # Nix will instruct remote build machines to use their own substituters if available
				connect-timeout = 2;                                 # The timeout (in seconds) for establishing connections in the binary cache substituter

				download-attempts = 2;                               # How often Nix will attempt to download a file before giving up
				download-buffer-size = 1073741824;  # 1GiB           # The size of Nix's internal download buffer (Bytes)

				experimental-features = [ "nix-command" "flakes" ];  # Experimental features that are enabled

				fallback = true;                                     # Nix will fall back to building from source if a binary substitute fails
				keep-going = true;                                   # Whether to keep building derivations when another build fails

				# narinfo-cache-negative-ttl = 2;                      # If a store path is queried from a substituter but was not found, there will be a negative lookup cached in the local disk cache database for the specified duration
				# narinfo-cache-positive-ttl = 0;                      # If a store path is queried from a substituter, the result of the query will be cached in the local disk cache database including some of the NAR metadata

				# TODO: Update keys for nixserve
				# trusted-public-keys = [
					# "msi.host.local:jbqDHg/Ky3EjKvI0Wtf2LZyiuxcbuJarlxA26WAAeT4="
					# "quiss.server.local:58w8SsV1RIHjX+PvvOoWZ6QkGhSUcLjRkfeX/gihOoA="
				# ];

				warn-dirty = false;                                  # Whether to warn about dirty Git/Mercurial tree
			};
		};
	};
}
