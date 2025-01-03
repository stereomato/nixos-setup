{ config, inputs, lib, pkgs, ... }:{
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
	
	imports = [
		./imports/overlays.nix
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

	nix = {
		settings = {
			auto-optimise-store = true;
			experimental-features = [ 
				"nix-command"
				"flakes"
			];
			trusted-substituters = [
			# nixified-ai
			"https://ai.cachix.org"
			];
			trusted-public-keys = [
			# nixified-ai
			"ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
			];
		};
		gc = {
			persistent = true;
			automatic = true;
			dates = "sunday";
			options = "--delete-older-than 7d";
		};
		optimise = {
			# This running at the same time as the garbage collector might cause issues.
			dates = [ "saturday" ];
			automatic = true;
		};
		daemonIOSchedClass = "idle";
		daemonCPUSchedPolicy = "idle";
		# Set this thanks to:
		# https://dataswamp.org/~solene/2022-07-20-nixos-flakes-command-sync-with-system.html
		registry.nixpkgs.flake = inputs.nixpkgs;
		nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
	};
	
	nixpkgs = {
		config = {
			allowUnfree = true;
			joypixels.acceptLicense = true;
			input-fonts.acceptLicense = true;
			permittedInsecurePackages = [
					# FIXME: https://github.com/NixOS/nixpkgs/issues/269713
					"openssl-1.1.1w"
					# FIXME: https://github.com/NixOS/nixpkgs/pull/280835
					"freeimage-unstable-2021-11-01"
			];
		};
	};

	services = {
		# SMART daemon
		smartd = {
			enable = true;
		};

		vnstat.enable = true;
		# Needed for anything GUI
		xserver.enable = true;
		# Web sharing
		samba.enable = false;

		# GPS
		geoclue2 = {
			enable = true;
			# Because MLS is ded, BeaconDB can now be used.
			# TODO: See how can I help with BeaconDB.
			# Maybe api.beacondb.net shouldn't be used here, but instead just beacondb.net?
			# Also see https://github.com/NixOS/nixpkgs/issues/321121
			# https://github.com/NixOS/nixpkgs/pull/325430
			geoProviderUrl = "https://beacondb.net/v1/geolocate";
			submissionUrl = "https://beacondb.net/v2/geosubmit";
			submissionNick = "stereomato";
			submitData = true;
		};
	 #lib.mkIf (config.services.desktopManager.plasma6.enable) 
	
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

	programs = {
		firefox.enable = true;
		mtr.enable = true;
		usbtop.enable = true;
		atop = {
			enable = true;
			setuidWrapper.enable = true;
			atopService.enable = true;
			atopacctService.enable = true;
			# Nah, only supports Nvidia. #intelFTW
			#atopgpu.enable = true;
			netatop.enable = false;
		};
	} // lib.optionalAttrs (config.services.xserver.desktopManager.gnome.enable) {
		# TODO: ask why these 2 and gnome-power-manager aren't in any of the 3 gnome toggles.
		# TODO: https://github.com/NixOS/nixpkgs/pull/368610/commits/8c17fbe4656087e9a86a573b5a0d76e939225f21
		calls.enable = false;
	 
		# There's no "Open in Ptyxis" element in the right click menu of Files so... add it
		# Ptyxis has to be installed.
		nautilus-open-any-terminal = {
			enable = true;
			terminal = "ptyxis";
		};
	} // lib.optionalAttrs (config.services.desktopManager.plasma6.enable) {
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
		variables = {
			EDITOR = "nano";
		};
		systemPackages = with pkgs; [
			# System monitoring, managing & benchmarking tools
			intel-gpu-tools libva-utils mesa-demos vulkan-tools lm_sensors htop gtop clinfo s-tui neofetch compsize smartmontools nvme-cli btop pciutils usbutils powertop btrfs-progs nvtopPackages.intel powerstat iotop smem nix-info kdiskmark file stress-ng btop fastfetch
			# System management
			gparted
		] ++ lib.optionals (config.services.desktopManager.plasma6.enable) [
				#  Extra KDE stuff
				kdePackages.filelight
				kdePackages.qtsvg
				kdePackages.kleopatra
				bibata-cursors
			];
	} // lib.optionalAttrs (config.services.xserver.desktopManager.gnome.enable) {
		gnome.excludePackages = with pkgs; [ 
			# I use the new app, Papers
			# TODO: Remove this once Papers is promoted to official and that is installed instead of Evince
			evince
		];
		systemPackages = with pkgs; [
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
		];
	};

	i18n = {
		defaultLocale = "es_PE.UTF-8";
		extraLocaleSettings = {
			LANG="en_US.UTF-8";
		};
		supportedLocales = [ "all" ];
		
		# KDE issue with uh... QT_IM_MODULE and GTK_IM_MODULE
		#inputMethod = {
		#	enabled = "ibus";
		#	ibus = {
		#		engines = with pkgs.ibus-engines; [
		#			typing-booster
		#			# https://github.com/NixOS/nixpkgs/pull/282148
		#			# mozc
		#			uniemoji
		#		];
		#	};
		#};
	};

	networking = {
		networkmanager.enable = true;
		nat = {
			enable = true;
		};
		firewall = {
			enable = true;
			allowedUDPPorts = [
				# Syncthing
				22000
				21027
			];
			allowedTCPPorts = [
				# Syncthing
				22000
				# Fragments
				59432
			];
		};
	};

	virtualisation = {
		spiceUSBRedirection.enable = true;
		libvirtd = {
			enable = true;
			qemu = {
				runAsRoot = false;
				swtpm.enable = true;
			};
		};
		podman = {
			enable = true;
		};
		waydroid = {
			enable = true;
		};
	};

	# GPS
	location.provider = "geoclue2";

	security = {
		protectKernelImage = false;
		sudo = {
			enable = true;
		};
		polkit.enable = true;
	};

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

	# Historical really
  # No need to use it for now
  # This is system-wide
  gtk = {};
  qt = {};
}
