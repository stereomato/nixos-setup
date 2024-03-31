{ pkgs, ... }:{
  # Here goes things that are used for system management and or monitoring
	environment.systemPackages = with pkgs; [
		# System monitoring, managing & benchmarking tools
		intel-gpu-tools libva-utils mesa-demos vulkan-tools lm_sensors htop gtop clinfo s-tui neofetch compsize smartmontools nvme-cli btop pciutils usbutils gnome.gnome-power-manager powertop btrfs-progs nvtopPackages.intel powerstat iotop smem nix-info kdiskmark file stress-ng

		# System management
		gparted
	];
	
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