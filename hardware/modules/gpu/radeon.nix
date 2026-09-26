database:

{
	board # { name, year, arch = { name, year } }
}:

# TODO: Assert types

assert (
	board ? "name"
		&& board.name != null
	&& board ? "year"
	&& board ? "arch"
		&& board.arch ? "name"
		&& board.arch ? "year"
);

{ pkgs, ... }:

let
	inherit (database.architecture.gpu.radeon) gcn-1 gcn-2;

	gt-gcn-2 = board.year > gcn-2.year;
	is-gcn-1 = board == gcn-1;
in

{
	config =
	{
		system.nixos.tags = [ "radeon" ];

		hardware =
		{
			graphics =
			{
				enable = true;
				extraPackages = with pkgs; [
					(if is-gcn-1
						then mesa.opencl
						else rocmPackages.clr.icd)
				];
			};

			amdgpu = {
				legacySupport.enable = !gt-gcn-2;
				opencl.enable = true;
				initrd.enable = true; # boot.initrd.kernelModules = ["amdgpu"];
			};
		};

		nixpkgs.config.rocmSupport = true;
		systemd.tmpfiles.rules =
		let
			rocmEnv = pkgs.symlinkJoin {
				name = "rocm-combined";
				paths = with pkgs.rocmPackages; [ rocblas hipblas clr ];
			};
		in [
#			Type Path                               Mode User Group Age Argument
			"L+ /opt/rocm                           -    -    -     -   ${rocmEnv}"
			"L+ /opt/amdgpu/share/libdrm/amdgpu.ids -    -    -     -   ${pkgs.libdrm}/share/libdrm/amdgpu.ids"
		];

		environment.systemPackages = with pkgs; [ radeontop clinfo ];
	};
}
