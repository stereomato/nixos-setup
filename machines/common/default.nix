{ config, lib, pkgs, ... }:{
	imports = [
		./fonts.nix
		./hardware
		./software
	];

	system.replaceDependencies.replacements = [
				# Disable stem darkening on QT
				{
					oldDependency = pkgs.kdePackages.qtbase;
					newDependency = pkgs.kdePackages.qtbase.overrideAttrs(old: {
						patches = pkgs.kdePackages.qtbase.patches ++ [
							./patches/disable-stem-darkening.patch
						];
					});
				}
				{
					oldDependency = pkgs.libsForQt5.qt5.qtbase;
					newDependency = pkgs.libsForQt5.qt5.qtbase.overrideAttrs(old: {
						patches = pkgs.libsForQt5.qt5.qtbase.patches ++ [
							./patches/disable-stem-darkening-qt5.patch
						];
					});
				}
	];


	# In this place goes things that are too general or too small that putting them in their own files is just cluttering

	#TODO: consider putting high level toggles here?
	# Like, stuff like the toggle for enabling kde or gnome, so that I can put better shaped conditionals on desktop-environment.nix
	console = {
		font = "Lat2-Terminus16";
	};

	programs.fish = {
		enable = true; 
		useBabelfish = true;
	};

	environment = {
		# Create a folder in /etc that has a link to the current NixOS configuration
		# Very good in case of... an accident
		etc."current-nixos".source = ./.;
		localBinInPath = true;
		shells = with pkgs; [ fish ];
		sessionVariables = {
			# QT apps look better this way
			# QT_SCALE_FACTOR_ROUNDING_POLICY = "Round";
		};
	};

	system = {
		# Determines the NixOS version whose format for stateful data will be used.
		# Upgrading this number isn't really neccessary, but possible. Read the NixOS changelogs if so.
		stateVersion = "24.11";
		# Copy the running system's configuration.nix to /run/current-system/configuration.nix
		#copySystemConfiguration = true;
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
