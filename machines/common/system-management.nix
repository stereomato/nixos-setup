{ config, lib, pkgs, ... }:{

	system = {
		# Determines the NixOS version whose format for stateful data will be used.
		# Upgrading this number isn't really neccessary, but possible. Read the NixOS changelogs if so.
		stateVersion = "24.11";
		# Copy the running system's configuration.nix to /run/current-system/configuration.nix
		#copySystemConfiguration = true;
		autoUpgrade = {
			# Can also use the flags knob for adding flags like --upgrade-all. --upgrade is already set, duh.
			# Disable because of the input fonts messing with the execution.
			enable = false;
			dates = "sunday";
			persistent = true;
			operation = "boot";
		};
	};
	
  # Here goes things that are used for system management and or monitoring
	environment.systemPackages = with pkgs; [
		# System monitoring, managing & benchmarking tools
		intel-gpu-tools libva-utils mesa-demos vulkan-tools lm_sensors htop gtop clinfo s-tui neofetch compsize smartmontools nvme-cli btop pciutils usbutils powertop btrfs-progs nvtopPackages.intel powerstat iotop smem nix-info kdiskmark file stress-ng btop fastfetch

		# System management
		gparted
	] ++ lib.optionals config.services.xserver.desktopManager.gnome.enable [ gnome-power-manager ] ;
	
	services = {
		smartd = {
			enable = true;
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
