{config, lib, pkgs, ... }: {
	nixpkgs.overlays = [( self: super: {
		mesa-wuwa = super.mesa.overrideAttrs (old: {
			patches = super.mesa.patches ++ [
				# https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/32967
				../patches/32967.patch
			];
		});
		mesa-wuwa32 = super.pkgsi686Linux.mesa.overrideAttrs (old: {
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