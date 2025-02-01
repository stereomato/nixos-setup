{config, lib, pkgs, ...}:{
    users = {
		users = {
			testuser = {
				isNormalUser = true;
				createHome = true;
				extraGroups = [ "ydotool" "dialout" "wheel" "audio" "adbusers" "network" "libvirtd" "networkmanager" "doas" "scanners" "lp" ];
				shell = pkgs.fish;
			};
		};
	};

}
