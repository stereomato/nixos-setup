{config, lib, pkgs, ...}:{
	# The line between saving power and increasing performance in these settings is way too blurry

	imports = [
		./sysctl-tweaks.nix
	];
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

	# Disable Watchdog
	boot = {
		extraModprobeConfig = ''
			blacklist iTCO_wdt
			options cfg80211 ieee80211_regdom="PE"
		'';
		kernelParams = [
			"nowatchdog"
		];
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
}
