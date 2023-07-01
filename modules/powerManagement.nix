{ lib, pkgs, ... }:{
	powerManagement = {
			enable = true;
			cpuFreqGovernor = lib.mkDefault "powersave";
			powertop.enable = true;
			scsiLinkPolicy = "med_power_with_dipm";
	};
}