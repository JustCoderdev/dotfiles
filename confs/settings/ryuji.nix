{
	profiles = [ "i3-desktop" "develop-environment" "game-environment" "ryuji-user" ];
	special-pkgs = {
		insecure = [ "electron-24.8.6" "python-2.7.18.6"  ];
		unfree = [
			"nvidia-x11"
			"nvidia-settings"
			"cuda-merged"
			"cuda_cuobjdump"
			"cuda_gdb"
			"cuda_nvcc"
			"cuda_nvdisasm"
			"cuda_nvprune"
			"cuda_cccl"
			"cuda_cudart"
			"cuda_cupti"
			"cuda_cuxxfilt"
			"cuda_nvml_dev"
			"cuda_nvrtc"
			"cuda_nvtx"
			"cuda_profiler_api"
			"cuda_sanitizer_api"
			"libcublas"
			"libcufft"
			"libcurand"
			"libcusolver"
			"libnvjitlink"
			"libcusparse"
			"libnpp"

			"helvetica-neue-lt-std"
			"cloudflare-warp"
			"apple-fonts"

			"steam"
			"steam-unwrapped"
			"steam-original"
			"steam-run"
			"steamcmd"

			"clion"
			"vscode"
			"idea-ultimate"
			"idea"

			"davinci-resolve"
			"minecraft-server"
			"discord"

			"libsciter"

			"obsidian"

			"google-chrome"
			"ciscoPacketTracer8"
		];
	};
}

