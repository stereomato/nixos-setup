{ config, inputs, lib, pkgs, ... }:{
	imports = [
		./overlays.nix
		./deskEnv.nix
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
		];
	};

	i18n = {
		defaultLocale = "es_PE.UTF-8";
		extraLocaleSettings = {
			LANG="en_US.UTF-8";
		};
		supportedLocales = [ "all" ];
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
		# efi.OVMF = pkgs.OVMFFull;
		libvirtd = {
			enable = true;
			qemu = {
				runAsRoot = false;
				swtpm.enable = true;
				ovmf.packages = [ pkgs.OVMFFull.fd ];
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

	# I am... here
	time = {
			timeZone = "America/Lima";
		};
}
