{ pkgs, ... }:{
  # Here goes things that are used for system management and or monitoring
	services = {
    smartd = {
			enable = true;
		};

    locate = {
			enable = true;
			package = pkgs.plocate;
			interval = "daily";
			localuser = null;
			prunePaths = [];
			pruneNames = [];
		};

    vnstat.enable = true;
    
		environment.systemPackages = with pkgs; [
			# Here go things that can't go in home.nix
			# System monitoring, managing & benchmarking tools
			kdiskmark
			
			# System management
			gparted
		];
	};
	programs = {
		mtr.enable = true;
		usbtop.enable = true;
		atop = {
			enable = true;
			setuidWrapper.enable = true;
			atopService.enable = true;
			atopacctService.enable = true;
			# Nah, only supports Nvidia. #intelFTW
			#atopgpu.enable = true;
			netatop.enable = false;
		};
  };

}