{config, lib, pkgs, ... }: {
	nixpkgs.overlays = [( self: super: {
	})];
	
	# GPU support
	hardware.graphics = {
		enable = true;
		# Remember to comment this out once not needed.
		# package = pkgs.mesa-wuwa.drivers;
		# package32 = pkgs.mesa-wuwa32.drivers;
		enable32Bit = true;

		extraPackages = with pkgs; [ 
			# HW media acceleration
			vpl-gpu-rt
			libvpl
			intel-media-sdk
			intel-media-driver

			# Compute
			level-zero
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
