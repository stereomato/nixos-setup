{ config, pkgs, ... }:{
	boot.kernelParams = config.boot.kernelParams ++ [ 
		# Enable HuC
		"i915.enable_guc=2"
		# Powersaving
		"iwlwifi.power_save=1"
		"iwlwifi.power_level=3"
	];
  boot.initrd.luks.devices."HeartDisk" = {
		device = "";
		allowDiscards = true;
		bypassWorkqueues = true;
	};
	
	networking.hostName = "Hearts";

  users = {
		users = {
			diana = {
				isNormalUser = true;
				createHome = true;
				extraGroups = [ "wheel" "audio" "adbusers" "network" "libvirtd" "networkmanager" "doas" "scanners" "lp" ]; 
				shell = pkgs.fish;
			};
		};
	};
}