# REMINDER: I NEED TO PACKAGE MENULIBRE
{ modulesPath, ... }:

{
	imports =
		[ 
			./boot.nix
			./console.nix
			./documentation.nix
			./environment.nix
			./filesystems.nix
			./fonts.nix
			./hardware.nix
			./i18n.nix
			./networking.nix
			./nix.nix
			./nixpkgs.nix
			./powerManagement.nix
			./programs.nix
			./qt.nix
			./security.nix
			./services.nix
			./swapDevices.nix
			./system.nix
			./systemd.nix
			./time.nix
			./users.nix
			./virtualisation.nix
			./zramSwap.nix
			# from hardware-configuration.nix
			(modulesPath + "/installer/scan/not-detected.nix")
		];
}
