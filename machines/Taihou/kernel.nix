{ lib, pkgs, ... }:{
	nixpkgs.overlays = [(
		self: super: {
			# TODO: Find where this comes from, and how it works? But, https://github.com/shiryel/nixos-dotfiles/blob/master/overlays/overrides/linux/default.nix# helped a lot!
			
		}
	)];
	
	boot = {
		kernelModules = [ "kvm-intel" ];
		extraModulePackages = [ ];
		kernelPackages = pkgs.linux-stereomato;
		
		#kernelPatches = [
			# Might work in kernel 6.7
		#	{
		#		name = "FBC patch";
		#		patch = ./patches/drm-i915-fbc-Allow-FBC-with-CCS-modifiers-on-SKL.patch;
		#	}
		#];
	};
}
