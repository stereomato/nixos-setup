{ config, inputs, lib, pkgs, ... }:{
	 nixpkgs.overlays = [(
		self: super: {
			# Gotten from https://aur.archlinux.org/cgit/aur.git/tree/force_qttextrendering.patch?h=qqc2-desktop-style-fractional
			# https://invent.kde.org/frameworks/qqc2-desktop-style/-/merge_requests/429
			# https://bugs.kde.org/show_bug.cgi?id=479891#c70
			#kdePackages = super.kdePackages // {
			#	qqc2-desktop-style = super.kdePackages.qqc2-desktop-style.override (old: {
			#		mkKdeDerivation = args: super.kdePackages.mkKdeDerivation ( args // {
			#			patches = [
			#			./patches/force_qttextrendering.patch
			#			# ./patches/force_nativetextrendering.patch
			#			];
			#		});
			#	});
			#};
			
			# Until next qqc2-desktop-style release
			# I'll probably know.
			#kdePackages = super.kdePackages.overrideScope(kdeSelf: kdeSuper: {
			# 	qqc2-desktop-style = super.kdePackages.qqc2-desktop-style.overrideAttrs (old: {
			# 		patches = [
			# 			./patches/e82957f5e6fc72e446239e2ee5139b93d3ceac85.patch
			# 		];
			# 	});
			#});
			
			# kdePackages = super.kdePackages // {
			# 	qqc2-desktop-style = super.kdePackages.qqc2-desktop-style.overrideAttrs (old: {
			# 		patches = [
			# 			./patches/e82957f5e6fc72e446239e2ee5139b93d3ceac85.patch
			# 		];
			# 	});
			# };
			
			# Dynamic triple buffering patch
			# Kinda buggy
			mutter = super.mutter.overrideAttrs (old: {
  				src = inputs.mutter-triple-buffering-src;
  				preConfigure = ''
    				cp -a "${inputs.gvdb-src}" ./subprojects/gvdb
  				'';
			});

			#	mutter = super.mutter.overrideAttrs (old: {
			#		src = pkgs.fetchFromGitLab  {
			#			domain = "gitlab.gnome.org";
			#			owner = "vanvugt";
			#			repo = "mutter";
			#			rev = "triple-buffering-v4-47";
			#			hash = "sha256-JaqJvbuIAFDKJ3y/8j/7hZ+/Eqru+Mm1d3EvjfmCcug=";
			#		};
			#	});
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
			games.enable = true;
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
		systemPackages = with pkgs; if (config.services.xserver.desktopManager.gnome.enable) then [
			# Miscellanous Gnome apps
			gnome-icon-theme gnome-tweaks gnome-extension-manager
			ptyxis
			gnome-boxes
			showtime
			morewaita-icon-theme

			# This is needed for file-roller to open .debs
			binutils
		] else [
			#  Extra KDE stuff
			kdePackages.filelight
			kdePackages.qtsvg
			kdePackages.kleopatra
		];
	};
}
