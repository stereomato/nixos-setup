{ ... }:{
	imports = [
		./console.nix
		./documentation.nix
		./environment.nix
		./envvars.nix
		./fonts.nix
		./hardware.nix
		./i18n.nix
		./monitoring.nix
		./networking.nix
		./nix.nix
		./nixpkgs.nix
		./performance.nix
		./pkgs.nix
		./system.nix
		./toolkits.nix
		./virtualisation.nix
	];

	services = {
		xserver = {
			enable = true;
			# Use GDM globally
			displayManager = {
				gdm.enable = true;
			};
		};
		# GNOME as DE
		desktopManager.gnome = {
			enable = true;
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
}