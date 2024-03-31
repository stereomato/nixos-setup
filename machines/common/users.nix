{ pkgs, ... }:{
	# Here go things related to users
	
	users = {
		users = {
			stereomato = {
				name = "Luis";
				isNormalUser = true;
				createHome = true;
				extraGroups = [ "wheel" "audio" "adbusers" "network" "libvirtd" "networkmanager" "doas" "scanners" "lp" ]; 
				shell = pkgs.fish;
			};
		};
	};

	programs.fish = {
			enable = true; 
			useBabelfish = true;
		};
}