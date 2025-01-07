{config, lib, pkgs, ...}:{
	# The line between saving power and increasing performance in these settings is way too blurry
	
	imports = [
		./sysctl-tweaks.nix
	];

	nixpkgs.overlays = [(
		self: super: {
			# Make ppd only use balance-performance
			# TODO: https://gitlab.freedesktop.org/upower/power-profiles-daemon/-/issues/151
			power-profiles-daemon = super.power-profiles-daemon.overrideAttrs (old: {
				patches = super.power-profiles-daemon.patches ++ [ ../patches/ppd-intel-balance-performance.patch ];
			});
		}
	)];

	nix = {
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
	};
	services = {
		# SMART daemon
		smartd = {
			enable = true;
		};
		# TODO: tabs break this, so don't add tabs, but spaces
		udev.extraRules = ''
			# Gotten from https://github.com/pop-os/default-settings/pull/149/commits/efceae50ff5f99d6f621098369116c0015d0f0aa
			# SD card correction from https://github.com/pop-os/default-settings/pull/149#issuecomment-2330321040
			# BFQ is recommended for slow storage such as rotational block devices and SD cards.
			ACTION=="add|change", SUBSYSTEM=="block", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
			ACTION=="add|change", SUBSYSTEM=="block", KERNEL=="mmcblk?", ATTR{removable}=="1", ATTR{queue/scheduler}="bfq"

			# Kyber is recommended for faster storage such as NVME, SATA SSDs and eMMC
			ACTION=="add|change", SUBSYSTEM=="block", ATTR{queue/rotational}=="0", KERNEL=="nvme?n?", ATTR{queue/scheduler}="kyber"
			ACTION=="add|change", SUBSYSTEM=="block", ATTR{queue/rotational}=="0", KERNEL=="sd?", ATTR{queue/scheduler}="kyber"
			ACTION=="add", SUBSYSTEM=="block", KERNEL=="mmcblk?",  ATTR{removable}=="0",           ATTR{queue/scheduler}="kyber"
		'';
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
		services = {
		"systemd-suspend-then-hibernate".aliases = [ "systemd-suspend.service" ];
		};
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