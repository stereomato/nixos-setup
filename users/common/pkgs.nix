{ pkgs, ... }:{
	environment.systemPackages = with pkgs; [
			# Here go things that can't go in home.nix
			# System monitoring, managing & benchmarking tools
			kdiskmark
			
			# System management
			gparted
		];
}