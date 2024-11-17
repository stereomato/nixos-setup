{ lib, ... }:
{
  # Sysctl tweaks
  # Mostly memory related
	imports = [
		./imports/sysctl-tweaks.nix
	];

		# These used to go on udev.extraRules, I don't use them due to them causing lag in the GNOME UI
		#SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", RUN+="${pkgs.optimizeIntelCPUperformancePolicy}/bin/scriptOptimizeIntelCPUperformancePolicy --mode=charger"
		#SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", RUN+="${pkgs.optimizeIntelCPUperformancePolicy}/bin/scriptOptimizeIntelCPUperformancePolicy --mode=charger"

	services = {
		# Automatic nice daemon
		# disabled because it disables cgroupsv2 that are needed for systemd-oomd
		ananicy = {
			enable = false;
			# Needs the community rules package to work well, in the meantime, use the original ananicy
			# package = pkgs.ananicy-cpp;
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

		# Not needed for BTRFS anymore
		#fstrim.enable = false;

		# Intel thermal management
		thermald.enable = true;

		# Profile sync daemon
		psd = {
			enable = true;
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

  # Kernel Samepage Merging
  hardware = {
    ksm = {
			enable = true;
			sleep = 1000;
		};
  };

	systemd = {
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