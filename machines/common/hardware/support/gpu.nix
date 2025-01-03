{config, lib, pkgs, ... }: {
	# GPU support
	hardware.graphics = {
		enable = true;
		enable32Bit = true;

		extraPackages = with pkgs; [ 
			# HW media acceleration
			intel-media-sdk
			intel-media-driver

			# Compute aka openCL
			intel-compute-runtime

			# Mangohud layers
			mangohud
		];
		extraPackages32 = with pkgs; [
			# Mangohud layers
			pkgsi686Linux.mangohud
		];
	};
}