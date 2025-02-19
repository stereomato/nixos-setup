{pkgs, ...}:{
  # This is where I put NixOS *user* config
  # hm configs go on the hm folder xDDDDD
  imports = [
    ./pkgs
  ];
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
}