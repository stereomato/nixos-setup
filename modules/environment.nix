{ pkgs, ... }:
{
	environment = { 
		systemPackages = with pkgs; [
			# Here go things that can't go in home.nix
			# System monitoring, managing & benchmarking tools
			kdiskmark
			
			# System management
			gparted
		];
		variables = {
			# Font emboldering
			FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 type1:no-stem-darkening=0 t1cid:no-stem-darkening=0 autofitter:no-stem-darkening=0";
			EDITOR = "nano";
		};
		localBinInPath = true;
		shells = with pkgs; [ fish ];
		etc."current-nixos".source = ./.;
	};
}