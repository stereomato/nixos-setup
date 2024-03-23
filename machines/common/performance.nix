{ lib, ... }:
{
  # Sysctl tweaks
  # Mostly memory related
	imports = [
		./imports/sysctl-tweaks.nix
	];

  # Power saving
  powerManagement = {
			enable = true;
			cpuFreqGovernor = lib.mkDefault "powersave";
			powertop.enable = true;
			scsiLinkPolicy = "med_power_with_dipm";
	};

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

	
	# Wifi power saving
	networking.networkmanager = {
		# This is already enabled because of gnome related toggles.
		wifi = {
			powersave = true;
		};
	};

  # Disk based swap
  # Unused
  #swapDevices = [{
		#device = "/swap/Taihou-SWAP";
		#size = 17365;
		#discardPolicy = "both";
		#randomEncryption = {
		#	enable = true; 
		#	allowDiscards = true;
		#};
		# This is in case of zram
		# Currently, the device doesn't exist.
		#device = "/dev/nvme0n1p3";
		#options = [ "noauto" ];
	#}];

  # Zram: memory compression
  zramSwap = {
		enable = true;
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
		tmpfiles = {
			# Enable HWP dynamic boosting
			rules = [ 
				"w /sys/devices/system/cpu/intel_pstate/hwp_dynamic_boost - - - - 1"
			];
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