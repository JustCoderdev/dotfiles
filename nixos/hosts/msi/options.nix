{ ... }:

{
	jcbin = {
		boomer.enable = true;
		rebuild-system.enable = true;
	};

	jcconfs.has_de = true;

	common = {
		core = {
			bluetooth.enable = true;
			nvidia.enable = true;

			audio.pulseaudio.enable = true;
			plymouth.enable = true;
		};

		users.ryuji = {
			image-editing = true;
			game-developing = true;
		};
	};

	system = {
		desktop = {
			i3.enable = true;
			thunar.enable = true;
		};

		dev = {
			android.enable = true;
			arduino.enable = true;
			c.enable = true;
			net.enable = true;
		};

		gaming.enable = true;

		services = {
			docker.enable = true;
			samba = {
				enable = true;
				shares.user.enable = true;
			};
			webserver.enable = true;
			nixbuilder = {
				server = {
					enable = true;
					maxJobs = 6;
					features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
					systems = [ "x86_64-linux" "aarch64-linux" "i686-linux" "armv7l-linux" "armv6l-linux" ];
				};
				client.builders =
				let
					gen-builder = (
						hostName: maxJobs:
						{
							inherit hostName maxJobs;
							features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
							systems = [ "x86_64-linux" "aarch64-linux" "i686-linux" "armv7l-linux" "armv6l-linux" ];
						}
					);
				in
				[
					(gen-builder "alpha.server.local" 8)
					(gen-builder  "beta.server.local" 6)
				];
			};
		};
	};
}
