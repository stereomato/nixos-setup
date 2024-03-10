{ lib, ... }:
{
  # Sysctl tweaks
  # Mostly memory related
	import = [
		./imports/sysctl-tweaks.nix
	];

  # Power saving
  powerManagement = {
			enable = true;
			cpuFreqGovernor = lib.mkDefault "powersave";
			powertop.enable = true;
			scsiLinkPolicy = "med_power_with_dipm";
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