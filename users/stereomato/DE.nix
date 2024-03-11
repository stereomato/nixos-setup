{ pkgs, ... }:{
  services = {
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
		# UI+UX settings
		xserver = {
			enable = true;
			displayManager = {
				gdm.enable = true;
				autoLogin = {
					enable = true;
					user = "stereomato";
				};
			};
			desktopManager.gnome = {
				enable = true;
				extraGSettingsOverridePackages = [ pkgs.gnome.mutter ];
				extraGSettingsOverrides = ''
					[org.gnome.mutter]
					# Disabled 'rt-scheduler' due to https://gitlab.gnome.org/GNOME/mutter/-/issues/3037
					experimental-features=['scale-monitor-framebuffer']
				'';
			};
		};
  };

  programs = {
    # Gnome area
		# TODO: ask why these 2 and gnome-power-manager aren't in any of the 3 gnome toggles.
		gnome-terminal.enable = true;
		calls.enable = true;
  };
}