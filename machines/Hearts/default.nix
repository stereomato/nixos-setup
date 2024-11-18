{ pkgs, ... }:{
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