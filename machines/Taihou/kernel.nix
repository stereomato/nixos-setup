{ lib, pkgs, ... }:{
	
	boot = {
		kernelModules = [ "kvm-intel" ];
		extraModulePackages = [ ];
		kernelPackages = pkgs.linux-stereomato;
	};
}
