{ pkgs, ... }:{
	environment = {
		localBinInPath = true;
		shells = with pkgs; [ fish ];
	};
	
	users = {
		users = {
			stereomato = {
				# name = "Luis";
				isNormalUser = true;
				createHome = true;
				extraGroups = [ "ydotool" "dialout" "wheel" "audio" "adbusers" "network" "libvirtd" "networkmanager" "doas" "scanners" "lp" ]; 
				shell = pkgs.fish;
			};
		};
	};

	programs.fish = {
			enable = true; 
			useBabelfish = true;
		};
}
