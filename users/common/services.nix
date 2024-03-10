{ pkgs, ... }:
{

	services = {
		# nice daemon, important for desktop responsiveness
		# disabled because it disables cgroupsv2 that are needed for systemd-oomd
		ananicy = {
			enable = false;
			# Needs the community rules package to work well, in the meantime, use the original ananicy
			# package = pkgs.ananicy-cpp;
		};
		
		btrfs = {
			autoScrub = {
				enable = true;
				interval = "thursday";
				fileSystems = [
					"/"
				];
			};
		};
		locate = {
			enable = true;
			package = pkgs.plocate;
			interval = "daily";
			localuser = null;
			prunePaths = [];
			pruneNames = [];
		};
		vnstat.enable = true;
		smartd = {
			enable = true;
		};
		fwupd.enable = true;
		thermald.enable = true;
		# Not needed for BTRFS anymore
		#fstrim.enable = false;
		# These used to go on udev.extraRules, not needed anymore
		#SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", RUN+="${pkgs.optimizeIntelCPUperformancePolicy}/bin/scriptOptimizeIntelCPUperformancePolicy --mode=charger"
		#SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", RUN+="${pkgs.optimizeIntelCPUperformancePolicy}/bin/scriptOptimizeIntelCPUperformancePolicy --mode=charger"

		udev.extraRules = ''
			KERNEL=="cpu_dma_latency", GROUP="audio"
			KERNEL=="rtc0", GROUP="audio"
			KERNEL=="hpet", GROUP="audio"
		'';
		# Enable printing
		printing = {
			enable = true;
			cups-pdf = {
				enable = true;
			};
		};
		psd = {
			enable = true;
		};
		pipewire = {
			enable = true;
			audio.enable = true;
			alsa = {
				enable = true;
				support32Bit = true;
			};
			pulse.enable = true;
			jack.enable = true;
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
		# UI+UX settings
		xserver = {
			enable = true;
			xkb.layout = "latam";
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
		# Antivirus
		clamav = {
			# Disabled as it's quite annoying to use 1GB of ram always on a system with less than 32GB of ram (my current laptop lmao)
			# Both sets have their settings values.
			daemon = {
				enable = false;
				settings = {
				};
			};
			updater = {
				enable = false;
				# By default the updater runs @ every hour, and does 12 database checks per day.
			};
		};
	};
}
