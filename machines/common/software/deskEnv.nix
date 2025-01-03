{inputs, config, lib, pkgs, ...}:{
  nixpkgs.overlays = [(
		self: super: {
			# Dynamic triple buffering patch
			mutter = super.mutter.overrideAttrs (old: {
  				src = inputs.mutter-triple-buffering-src;
  				preConfigure = ''
    				cp -a "${inputs.gvdb-src}" ./subprojects/gvdb
  				'';
			});
		}
	 )];

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

  services = {
    colord.enable = lib.mkIf (config.services.desktopManager.plasma6.enable) true;
		displayManager.sddm = {
			enable = config.services.desktopManager.plasma6.enable;
			wayland.enable = true;
		};

		xserver.desktopManager.gnome = {
			extraGSettingsOverridePackages = [ pkgs.mutter ];
			# There's a possible extra setting I could add here, but I don't know if it's necessary considering I modify font settings using fontconfing: https://www.reddit.com/r/gnome/comments/1grtn97/comment/lx9fiib/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
			# Removed 'xwayland-native-scaling' because it's annoying how it's implemented in Gnome, and I don't
			# give enough of a shit about blurry Xwayland apps honestly. Most end up working on wayland eventually
			extraGSettingsOverrides = ''
				[org.gnome.mutter]
				experimental-features=['scale-monitor-framebuffer']
			'';
		};
		# The Gnome Display Manager
		xserver.displayManager.gdm.enable = config.services.xserver.desktopManager.gnome.enable;

		# Extra gnome apps
		gnome = lib.mkIf (config.services.xserver.desktopManager.gnome.enable) {
			core-developer-tools.enable = true;
			# I don't need this, lmao
			games.enable = false;
		};
  };

  programs = if (config.services.xserver.desktopManager.gnome.enable) then {
		# TODO: ask why these 2 and gnome-power-manager aren't in any of the 3 gnome toggles.
		# TODO: https://github.com/NixOS/nixpkgs/pull/368610/commits/8c17fbe4656087e9a86a573b5a0d76e939225f21
		calls.enable = false;
	 
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
    gnome.excludePackages = with pkgs; lib.optionals (config.services.xserver.desktopManager.gnome.enable) [ 
			# I use the new app, Papers
			# TODO: Remove this once Papers is promoted to official and that is installed instead of Evince
			evince
		];

    systemPackages = with pkgs; [] ++ lib.optionals (config.services.xserver.desktopManager.gnome.enable) [
					# Default PDF viewer
					papers
					# Miscellanous Gnome apps
					gnome-icon-theme gnome-tweaks # gnome-extension-manager
					ptyxis
					gnome-boxes
					showtime
					morewaita-icon-theme
					mission-center
					resources
					gnome-power-manager
					# This is needed for file-roller to open .debs
					binutils
			] ++ lib.optionals (config.services.desktopManager.plasma6.enable) [
				#  Extra KDE stuff
				kdePackages.filelight
				kdePackages.qtsvg
				kdePackages.kleopatra
				bibata-cursors
			];
  };
}