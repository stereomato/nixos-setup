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
			displayManager = {
				gdm.enable = true;
			};
			# GNOME as DE
			desktopManager.gnome = {
				enable = true;
			};
		};

		gnome = {
			# Adds some developer tools for gnome and enables sysprof.
			core-developer-tools.enable = true;
			# This enables evince, file-roller, geary, gnome-disks, seahorse, sushi.
			# Also enables bash and zsh integration for vte.
			# Also configures the files app to find extensions and overrides its default mimeapps
			core-utilities.enable = true;
			# This enables colord, glib-networking, gnome-browser-connector, gnome-initial-setup, gnome-remote-desktop, gnome-settings-daemon, gnome-user-share, rygel, avahi, geoclue2 
			# Also enables printing (system-config-printer) and gvfs
			core-shell.enable = true;
			# This toggle enables bluetooth, dconf, polkit, accounts-daemon, dleyna-renderer and -server, power-profiles-daemon, at-spi2-core, evolution-data-server, gnome-keyring, gnome-online-accounts, gnome-online-miners, tracker-miners, tracker, bolt, udisks2, upower, libinput, networkmanager, updateDbusEnvironment
			# Also obvious stuff like xdg mime, icons, portals.
			# Also sets qt settings, to look like adwaita.
			core-os-services.enable = true;
			games.enable = true;
		};
		power-profiles-daemon.enable = true;
	};
	# Remaining GNOME programs
	programs = {
		# TODO: ask why these 2 and gnome-power-manager aren't in any of the 3 gnome toggles.
		gnome-terminal.enable = true;
		calls.enable = true;
	};
	environment.systemPackages = with pkgs; [
		# Miscellanous Gnome apps
		gnome-icon-theme gnome.gnome-tweaks gnome-extension-manager metadata-cleaner warp wike gnome-solanum newsflash
	];


	documentation = {
		man = {
			generateCaches = true;
			mandoc = {
				enable = true;
			};
			man-db = {
				enable = false;
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
			# Font emboldering
			# and
			# fuzziness a la macOS/W95
			FREETYPE_PROPERTIES = "truetype:interpreter-version=35 cff:no-stem-darkening=0 type1:no-stem-darkening=0 t1cid:no-stem-darkening=0 autofitter:no-stem-darkening=0";
			EDITOR = "nano";
		};

		};
}