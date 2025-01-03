{config, lib, pkgs, ...}:{
  # Sysctl tweaks
	# Mostly memory related
  imports = [
		./imports/sysctl-tweaks.nix
	];

  services = {
    # TODO: tabs break this, so don't add tabs, but spaces
		udev.extraRules = ''
			# This is to circumvent PPD setting epp to balance_power
			SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", RUN+="${pkgs.optimizeIntelCPUperformancePolicy}/bin/scriptOptimizeIntelCPUperformancePolicy --mode=charger"
			SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", RUN+="${pkgs.optimizeIntelCPUperformancePolicy}/bin/scriptOptimizeIntelCPUperformancePolicy --mode=charger"
		'';

    # Intel thermal management
		thermald.enable = true;

    # Profile sync daemon
		psd = {
			enable = true;
			resyncTimer = "30min";
		};
    # Firmware updates
		fwupd.enable = true;
  };

  # BTRFS autoscrubbing
		btrfs = {
			autoScrub = {
				enable = true;
				interval = "thursday";
				fileSystems = [
					"/"
				];
			};
		};

  # Power saving
	powerManagement = {
			enable = true;
			powertop.enable = true;
			scsiLinkPolicy = "med_power_with_dipm";
	};
  
  # Wifi power saving
	networking.networkmanager = {
		wifi = {
			powersave = true;
		};
	};

  	# Disk based swap
	# I am using this because I use Zswap now. Seems to be more efficient and faster, and can move stuff to the backing swap file as needed.
	swapDevices = [{
		device = "/swap/swapfile";
		# TODO: make this adaptive!
		size = 17365;
		discardPolicy = "both";
		randomEncryption = {
			enable = false; 
			allowDiscards = true;
			keySize = 256;
		};
		# This is in case of zram
		# Currently, the device doesn't exist.
		#device = "/dev/nvme0n1p3";
		#options = [ "noauto" ];
	}];

  # Zram: memory compression
	# Disabled: Using Zswap now.
	zramSwap = {
		enable = false;
		algorithm = "zstd";
		memoryPercent = 200;
		#writebackDevice = "/dev/nvme0n1p3";
	};

  systemd = {
		# Do suspend-then-hibernate
		services."systemd-suspend-then-hibernate".aliases = [ "systemd-suspend.service" ];
		# Out Of Memory daemon
		oomd = {
			#TODO: Keep an eye on https://github.com/NixOS/nixpkgs/pull/225747
			# Enabled by default
			# enable = true;
			# This is enabled by fedora
			enableSystemSlice = true;
			enableUserSlices = true;
			# This is not
			enableRootSlice = true;
			extraConfig = {
				# DefaultMemoryPressureLimit = "85%";
				SwapUsedLimit = "75%";
			};
		};
	};

  # Kernel Samepage Merging
	hardware = {
    ksm = {
			enable = true;
			sleep = 1000;
		};
	};
}