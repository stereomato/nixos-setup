{config, lib, pkgs, ... }: {
	nixpkgs.overlays = [( self: super: {
		mesa-wuwa = super.mesa.overrideAttrs (old: {
			patches = super.mesa.patches ++ [
				# https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/32967
				../patches/32967.patch
			];
		});
	})];
	
	# GPU support
	hardware.graphics = {
		enable = true;
		# Remember to comment this out once not needed.
		package = pkgs.mesa-wuwa;
		package32 = pkgs.mesa-wuwa32;
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