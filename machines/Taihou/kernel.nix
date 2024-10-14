{ pkgs, ... }:{
	boot = {
		kernelModules = [ "kvm-intel" ];
		extraModulePackages = [ ];
		# kernelPackages = pkgs.linux-stereomato;
		
		#kernelPatches = [
			# Might work in kernel 6.7
		#	{
		#		name = "FBC patch";
		#		patch = ./patches/drm-i915-fbc-Allow-FBC-with-CCS-modifiers-on-SKL.patch;
		#	}
		#];
	};
}
