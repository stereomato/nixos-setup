{ config, inputs, lib, pkgs, ... }:{
	 nixpkgs.overlays = [(
		self: super: {
			# Dynamic triple buffering patch
			# Kinda buggy
			mutter = super.mutter.overrideAttrs (old: {
  				src = inputs.mutter-triple-buffering-src;
  				preConfigure = ''
    				cp -a "${inputs.gvdb-src}" ./subprojects/gvdb
  				'';
			});
		}
	 )];
	
	# I will remember to remove this, right?
	# RIGHT?
	system.replaceDependencies.replacements = [ {
	 	oldDependency = pkgs.kdePackages.qqc2-desktop-style;
	 	newDependency = pkgs.kdePackages.qqc2-desktop-style.overrideAttrs(old: {
	 				patches = [
	 		 			./patches/e82957f5e6fc72e446239e2ee5139b93d3ceac85.patch
	 		 		];
	 		 	});
	 	}
	 ];
	services = {
		# Everything else falls apart without this.
		xserver.enable = true;

		# KDE Master toggle
		# To enable KDE, set services.desktopManager.plasma6.enable to true
		# desktopManager.plasma6.enable = false;
		displayManager.sddm = lib.mkIf (config.services.desktopManager.plasma6.enable) {
			enable = true;
			wayland.enable = true;
		};
		colord.enable = lib.mkIf(config.services.desktopManager.plasma6.enable) true;

		xserver.desktopManager.gnome = {
			# Gnome Master toggle
			# To enable GNOME, set services.xserver.desktopManager.gnome.enable to true
			# enable = true;
			extraGSettingsOverridePackages = lib.mkIf (config.services.xserver.desktopManager.gnome.enable) [ pkgs.mutter ];
			# There's a possible extra setting I could add here, but I don't know if it's necessary considering I modify font settings using fontconfing: https://www.reddit.com/r/gnome/comments/1grtn97/comment/lx9fiib/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
			# Removed 'xwayland-native-scaling' because it's annoying how it's implemented in Gnome, and I don't
			# give enough of a shit about blurry Xwayland apps honestly. Most end up working on wayland eventually
			extraGSettingsOverrides = lib.mkIf (config.services.xserver.desktopManager.gnome.enable) ''
				[org.gnome.mutter]
				experimental-features=['scale-monitor-framebuffer']
			'';
		};
		xserver.displayManager.gdm.enable = config.services.xserver.desktopManager.gnome.enable;

		gnome = lib.mkIf (config.services.xserver.desktopManager.gnome.enable) {
			core-developer-tools.enable = true;
			# I don't need this, lmao
			games.enable = false;
		};
	};

	programs = if (config.services.xserver.desktopManager.gnome.enable) then {
		# TODO: ask why these 2 and gnome-power-manager aren't in any of the 3 gnome toggles.
		calls.enable = true;
	 
		# There's no "Open in Ptyxis" element in the right click menu of Files so... add it
		# Ptyxis has to be installed.
		nautilus-open-any-terminal = {
			enable = true;
			terminal = "ptyxis";
		};
	} else {
			kdeconnect.enable = true;
			partition-manager.enable = true;
			kde-pim = {
			merkuro = true;
			kontact = true;
			kmail = true;
			};
			# https://github.com/NixOS/nixpkgs/issues/348919
			# k3b.enable = true;
	};

	environment = {
		gnome.excludePackages = with pkgs; [ 
			# I use the new app, Papers
			# TODO: Remove this once Papers is promoted to official and that is installed instead of Evince
			evince
			# I use the new app, Showtime
			totem
		];
		systemPackages = with pkgs; if (config.services.xserver.desktopManager.gnome.enable) then [
			# Default PDF viewer
			papers
			# Miscellanous Gnome apps
			gnome-icon-theme gnome-tweaks gnome-extension-manager
			ptyxis
			gnome-boxes
			showtime
			morewaita-icon-theme
			mission-center
			resources

			# This is needed for file-roller to open .debs
			binutils
		] else [
			#  Extra KDE stuff
			kdePackages.filelight
			kdePackages.qtsvg
			kdePackages.kleopatra
			bibata-cursors
		];
	};
}
