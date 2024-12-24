{ pkgs, ... }:
{
	# Sysctl tweaks
  # Mostly memory related
	imports = [
		./imports/sysctl-tweaks.nix
	];

	nixpkgs.overlays = [(
		self: super: {
			optimizeIntelCPUperformancePolicy = super.writers.writeFishBin "scriptOptimizeIntelCPUperformancePolicy" ''
				set -l options 'mode=?'
				argparse $options -- $argv
				set bootComplete (systemctl is-active graphical.target)
				while test $bootComplete != "active"
					sleep 1
					set bootComplete (systemctl is-active graphical.target)
				end

				if test -n "$_flag_mode"
					if test "$_flag_mode" = "battery" -o "$_flag_mode" = "charger" -o "$_flag_mode" = "testing"
						switch $_flag_mode
							case battery
								set preference balance_power
							case charger
								set preference balance_performance
							case testing
								# https://github.com/torvalds/linux/blob/bcde95ce32b666478d6737219caa4f8005a8f201/drivers/cpufreq/intel_pstate.c#L3655
								# 102 (balance_performance) + 192 (balance_power) / 2 = 147
								set preference 147
						end
						echo $preference | tee /sys/devices/system/cpu/cpufreq/policy?/energy_performance_preference
					else
						echo "You need to provide a proper mode for this script to actually do something, either --mode=charger or --mode=battery."
						return 1
					end
				else
					echo "You need to provide a mode for this script to actually do something, either --mode=charger or --mode=battery."
					return 1
				end
			'';
		}
	)];
		
		# These used to go on services.udev.extraRules, I don't use them due to them causing lag in the GNOME UI
		services.udev.extraRules = ''
			# Testing balance_performance at all times, given that setting epp to 147 yielded... less battery usage
			SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", RUN+="${pkgs.optimizeIntelCPUperformancePolicy}/bin/scriptOptimizeIntelCPUperformancePolicy --mode=charger"
			SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", RUN+="${pkgs.optimizeIntelCPUperformancePolicy}/bin/scriptOptimizeIntelCPUperformancePolicy --mode=charger"
		'';
	services = {
		# Automatic nice daemon
		# disabled because it disables cgroupsv2 that are needed for systemd-oomd
		ananicy = {
			enable = false;
			# Needs the community rules package to work well, in the meantime, use the original ananicy
			# package = pkgs.ananicy-cpp;
		};
		# BTRFS autoscrubbing
		#btrfs = {
		#	autoScrub = {
		#		enable = true;
		#		interval = "thursday";
		#		fileSystems = [
		#			"/"
		#		];
		#	};
		#};

		# Not needed for BTRFS anymore
		# Needed for XFS
		# TODO: Add check for this using config
		fstrim.enable = true;

		# Intel thermal management
		thermald.enable = true;

		# Profile sync daemon
		psd = {
			enable = true;
			resyncTimer = "30min";
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
