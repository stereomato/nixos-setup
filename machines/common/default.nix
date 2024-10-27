{ pkgs, ... }:{
	imports = [
		./fonts.nix
		./hardware.nix
		./i18n.nix
		./networking.nix
		./nix.nix
		./nixpkgs.nix
		./performance.nix
		./security.nix
		./system-management.nix
		./system.nix
		./toolkits.nix
		./users.nix
		./virtualisation.nix
	];

	# In this place goes things that are too general or too small that putting them in their own files is just cluttering

	console = {
		font = "Lat2-Terminus16";
	};

	services = {
		xserver = {
			enable = true;
			# Use GDM globally
			#displayManager = {
			#	gdm.enable = true;
			#};
			# GNOME as DE
			#desktopManager.gnome = {
			#	enable = true;
			#};
		};

		#gnome = {
		#	core-developer-tools.enable = true;
		#	core-utilities.enable = true;
		#	core-shell.enable = true;
		#	core-os-services.enable = true;
		#	games.enable = true;
		#};
		power-profiles-daemon.enable = true;
	};
	# Remaining GNOME programs
	programs = {
		# TODO: ask why these 2 and gnome-power-manager aren't in any of the 3 gnome toggles.
		# calls.enable = true;
	};
	#environment.gnome.excludePackages = with pkgs; [
	#	gnome-builder
	#];
	environment.systemPackages = with pkgs; [
		# Miscellanous Gnome apps
		#gnome-icon-theme gnome.gnome-tweaks gnome-extension-manager
	];

	documentation = {
		man = {
			generateCaches = true;
			mandoc = {
				enable = false;
			};
			man-db = {
				enable = true;
			};
		};
		dev = {
			enable = true;
		};
	};
	
	environment = {
			localBinInPath = true;
			shells = with pkgs; [ fish ];
			etc."current-nixos".source = ./.;

			variables = {
			# MacOS-like font rendering
			# FREETYPE_PROPERTIES = "truetype:interpreter-version=35 cff:no-stem-darkening=0 type1:no-stem-darkening=0 t1cid:no-stem-darkening=0 autofitter:no-stem-darkening=0";
			EDITOR = "nano";
		};

		};

		# Firefox
		programs.firefox = {
			enable = true;
		};
		
		# GPS
		location.provider = "geoclue2";
		services.geoclue2.enable = true;

		services.colord.enable = true;
		# Thunderbolt
		services.hardware.bolt.enable = true;

		# Web sharing
		services.samba.enable = true;

		# wacom tablets
		services.xserver.wacom.enable = true;

}
