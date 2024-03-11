{ pkgs, ... }:
{

	services = {
		# nice daemon, important for desktop responsiveness
		# disabled because it disables cgroupsv2 that are needed for systemd-oomd
		ananicy = {
			enable = false;
			# Needs the community rules package to work well, in the meantime, use the original ananicy
			# package = pkgs.ananicy-cpp;
		};
		
		
		locate = {
			enable = true;
			package = pkgs.plocate;
			interval = "daily";
			localuser = null;
			prunePaths = [];
			pruneNames = [];
		};
		vnstat.enable = true;
		smartd = {
			enable = true;
		};
		
		
		# Not needed for BTRFS anymore
		#fstrim.enable = false;
		# These used to go on udev.extraRules, not needed anymore
		#SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", RUN+="${pkgs.optimizeIntelCPUperformancePolicy}/bin/scriptOptimizeIntelCPUperformancePolicy --mode=charger"
		#SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", RUN+="${pkgs.optimizeIntelCPUperformancePolicy}/bin/scriptOptimizeIntelCPUperformancePolicy --mode=charger"

		
		# Enable printing
		
		psd = {
			enable = true;
		};
		
		
		# Antivirus
		clamav = {
			# Disabled as it's quite annoying to use 1GB of ram always on a system with less than 32GB of ram (my current laptop lmao)
			# Both sets have their settings values.
			daemon = {
				enable = false;
				settings = {
				};
			};
			updater = {
				enable = false;
				# By default the updater runs @ every hour, and does 12 database checks per day.
			};
		};
	};
}
