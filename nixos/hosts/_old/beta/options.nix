{ ... }:

{
	jcbin.rebuild-system.enable = true;

	system.services = {
		nixbuilder.server = {
			enable = true;
			maxJobs = 6;
			features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
			systems = [ "x86_64-linux" "aarch64-linux" "i686-linux" "armv7l-linux" "armv6l-linux" ];
		};
	};
}
