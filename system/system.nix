{ lib, pkgs, ... }:{
	system = {
		# Determines the NixOS version whose format for stateful data will be used.
		# Upgrading this number isn't really neccessary, but possible. Read the NixOS changelogs if so.
		stateVersion = "22.11";
		# Copy the running system's configuration.nix to /run/current-system/configuration.nix
		copySystemConfiguration = true;
		autoUpgrade = {
			# Can also use the flags knob for adding flags like --upgrade-all. --upgrade is already set, duh.
			# Disable because of the input fonts messing with the execution.
			enable = false;
			dates = "sunday";
			persistent = true;
			operation = "boot";
		};
	};
}