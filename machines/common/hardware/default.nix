{ lib, pkgs, ... }:
{
	# Notes
	# This manages hardware support and performance
	# PPD is enabled automatically by both GNOME and KDE
	# Wifi powersaving is enable

	imports = [
		./performance
		./overlays
		./support
	];
}
